// Replaces pi's footer with the same one-line status as ~/.claude/statusline-command.sh:
// model with reasoning effort, context-window usage, and 5h rate-limit usage with its local reset time.
// The 5h part supports Anthropic, claude-bridge, and openai-codex models.

import type { ExtensionAPI, ExtensionContext, Theme } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";

const BAR_WIDTH = 10;
const EFFORT_LABELS: Readonly<Record<string, string>> = {
	minimal: "min",
	low: "lo",
	medium: "med",
	high: "hi",
	xhigh: "xhi",
};
// Anthropic and the claude-bridge provider report plan usage in these response headers.
const FIVE_HOUR_UTILIZATION_HEADER = "anthropic-ratelimit-unified-5h-utilization";
const FIVE_HOUR_RESET_HEADER = "anthropic-ratelimit-unified-5h-reset";
// Codex reports a primary and a secondary window and does not fix which one is the 5h window.
const CODEX_WINDOWS = ["primary", "secondary"] as const;
const CODEX_FIVE_HOUR_MINUTES = 300;

type LimitSource = "anthropic" | "codex";
type FiveHourLimit = { percent: number; resetsAt?: Date };
type CodexWindow = { minutes: number; percent: number; resetSeconds: number };

const LIMIT_SOURCES: Readonly<Record<string, LimitSource>> = {
	anthropic: "anthropic",
	"claude-bridge": "anthropic",
	"openai-codex": "codex",
};

const bar = (theme: Theme, percent: number) => {
	const filled = Math.min(BAR_WIDTH, Math.max(0, Math.round((percent * BAR_WIDTH) / 100)));
	return "█".repeat(filled) + theme.fg("dim", "░".repeat(BAR_WIDTH - filled));
};

// 81234 -> 81k, 1000000 -> 1M, 1500000 -> 1.5M
const formatTokens = (count: number) => {
	if (count >= 999_500) return `${(count / 1e6).toFixed(1).replace(/\.0$/, "")}M`;
	if (count >= 1000) return `${Math.round(count / 1000)}k`;
	return String(count);
};

const formatTime = (date: Date) =>
	`${String(date.getHours()).padStart(2, "0")}:${String(date.getMinutes()).padStart(2, "0")}`;

const isRecord = (value: unknown): value is Record<string, unknown> => typeof value === "object" && value !== null;

// Missing, empty, null, or malformed values become NaN, so callers only need Number.isFinite().
const toNumber = (value: unknown) => {
	if (typeof value === "number") return value;
	if (typeof value === "string" && value.trim() !== "") return Number(value);
	return Number.NaN;
};

const toFiveHourLimit = (percent: number, resetSeconds: number): FiveHourLimit => ({
	percent,
	resetsAt: Number.isFinite(resetSeconds) ? new Date(resetSeconds * 1000) : undefined,
});

const parseAnthropicHeaders = (headers: Record<string, string>): FiveHourLimit | undefined => {
	const utilization = toNumber(headers[FIVE_HOUR_UTILIZATION_HEADER]);
	if (!Number.isFinite(utilization)) return undefined;
	return toFiveHourLimit(utilization * 100, toNumber(headers[FIVE_HOUR_RESET_HEADER]));
};

const pickCodexFiveHour = (windows: readonly CodexWindow[]): FiveHourLimit | undefined => {
	const window = windows.find(
		({ minutes, percent }) => minutes === CODEX_FIVE_HOUR_MINUTES && Number.isFinite(percent),
	);
	return window && toFiveHourLimit(window.percent, window.resetSeconds);
};

// The SSE transport sends these headers; the WebSocket transport sends a codex.rate_limits event instead.
const parseCodexHeaders = (headers: Record<string, string>) =>
	pickCodexFiveHour(
		CODEX_WINDOWS.map((name) => ({
			minutes: toNumber(headers[`x-codex-${name}-window-minutes`]),
			percent: toNumber(headers[`x-codex-${name}-used-percent`]),
			resetSeconds: toNumber(headers[`x-codex-${name}-reset-at`]),
		})),
	);

const parseCodexEvent = (data: unknown) => {
	if (!isRecord(data) || data.type !== "codex.rate_limits" || !isRecord(data.rate_limits)) return undefined;
	const limits = data.rate_limits;
	return pickCodexFiveHour(
		CODEX_WINDOWS.map((name) => limits[name])
			.filter(isRecord)
			.map((window) => ({
				minutes: toNumber(window.window_minutes),
				percent: toNumber(window.used_percent),
				resetSeconds: toNumber(window.reset_at),
			})),
	);
};

export default function (pi: ExtensionAPI) {
	const fiveHourLimits = new Map<LimitSource, FiveHourLimit>();
	let requestRender: (() => void) | undefined;

	const storeLimit = (source: LimitSource, limit: FiveHourLimit | undefined) => {
		if (!limit) return;
		fiveHourLimits.set(source, limit);
		requestRender?.();
	};

	// Hide the limit of other providers and stale values after their reset time.
	const currentLimit = (provider: string | undefined) => {
		const source = provider === undefined ? undefined : LIMIT_SOURCES[provider];
		const limit = source && fiveHourLimits.get(source);
		if (!limit) return undefined;
		if (limit.resetsAt && limit.resetsAt.getTime() <= Date.now()) return undefined;
		return limit;
	};

	const renderLine = (ctx: ExtensionContext, theme: Theme) => {
		const dim = (text: string) => theme.fg("dim", text);
		const separator = ` ${dim("│")} `;

		const model = ctx.model;
		const modelName = model ? model.name.replace(/^Claude /, "").replace(/ 1M$/, "") : "no model";
		const level = pi.getThinkingLevel();
		const effort = EFFORT_LABELS[level] ?? level;
		const modelPart =
			model?.reasoning && level !== "off" ? `${modelName} ${dim("(")}${effort}${dim(")")}` : modelName;

		const usage = ctx.getContextUsage();
		const contextPercent = usage?.percent ?? 0;
		const contextValue = usage
			? `${usage.tokens === null ? "?" : formatTokens(usage.tokens)}${dim("/")}${formatTokens(usage.contextWindow)}`
			: `${Math.round(contextPercent)}%`;
		const contextPart = `${dim("ctx")} ${bar(theme, contextPercent)} ${contextValue}`;

		const fiveHourLimit = currentLimit(model?.provider);
		if (!fiveHourLimit) return modelPart + separator + contextPart;

		const reset = fiveHourLimit.resetsAt ? ` ${dim("resets")} ${formatTime(fiveHourLimit.resetsAt)}` : "";
		const fiveHourPart = `${dim("5h")} ${bar(theme, fiveHourLimit.percent)} ${Math.round(fiveHourLimit.percent)}%${reset}`;
		return modelPart + separator + contextPart + separator + fiveHourPart;
	};

	pi.on("session_start", (_event, ctx) => {
		if (!ctx.hasUI) return;
		ctx.ui.setFooter((tui, theme, footerData) => {
			requestRender = () => tui.requestRender();
			return {
				invalidate() {},
				dispose() {
					requestRender = undefined;
				},
				render(width: number): string[] {
					const line = truncateToWidth(renderLine(ctx, theme), width, theme.fg("dim", "..."));
					// Other extensions report state through setStatus(), so keep it visible when they do.
					const statuses = [...footerData.getExtensionStatuses().entries()]
						.sort(([a], [b]) => a.localeCompare(b))
						.map(([, text]) => text.replace(/\s+/g, " ").trim());
					if (statuses.length === 0) return [line];
					return [line, truncateToWidth(statuses.join(" "), width, theme.fg("dim", "..."))];
				},
			};
		});
	});

	pi.on("after_provider_response", (event) => {
		storeLimit("anthropic", parseAnthropicHeaders(event.headers));
		storeLimit("codex", parseCodexHeaders(event.headers));
	});

	pi.on("provider_stream_event", (event) => {
		if (LIMIT_SOURCES[event.provider] !== "codex") return;
		storeLimit("codex", parseCodexEvent(event.data));
	});
}
