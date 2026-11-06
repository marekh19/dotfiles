#!/bin/bash
# Minimal one-line status: model with reasoning effort, context-window usage, 5h rate-limit usage
# and its local reset time. Context shown as tokens used/window, 5h as %, both with a compact progress bar.
# Values use normal intensity; separators, labels and empty bar cells are dim.

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '{low: "lo", medium: "med", high: "hi", xhigh: "xhi"}[.effort.level // ""] // .effort.level // empty')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
ctx_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
ctx_window=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
# jq formats the time because `date -d @epoch` is GNU-only and fails on macOS.
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty | localtime | strftime("%H:%M")')

dim=$'\033[2m'
reset=$'\033[0m'
sep=" ${dim}│${reset} "

bar() {
  local pct=${1:-0}
  local width=10
  local filled
  filled=$(printf '%.0f' "$pct")
  filled=$(((filled * width + 50) / 100))
  [ "$filled" -gt "$width" ] && filled=$width
  [ "$filled" -lt 0 ] && filled=0
  local empty=$((width - filled))
  [ "$filled" -gt 0 ] && printf '█%.0s' $(seq 1 "$filled")
  if [ "$empty" -gt 0 ]; then
    printf '%s' "$dim"
    printf '░%.0s' $(seq 1 "$empty")
    printf '%s' "$reset"
  fi
}

# 81234 -> 81k, 1000000 -> 1M, 1500000 -> 1.5M
fmt_tokens() {
  awk -v n="${1:-0}" 'BEGIN {
    if (n >= 999500) { s = sprintf("%.1f", n / 1e6); sub(/\.0$/, "", s); print s "M" }
    else if (n >= 1000) printf "%.0fk\n", n / 1000
    else print n
  }'
}

[ -n "$effort" ] && model="${model} ${dim}(${reset}${effort}${dim})${reset}"

if [ -n "$ctx_window" ]; then
  ctx_value="$(fmt_tokens "$ctx_tokens")${dim}/${reset}$(fmt_tokens "$ctx_window")"
else
  ctx_value=$(printf '%.0f%%' "$ctx_pct")
fi

line="${model}${sep}${dim}ctx${reset} $(bar "$ctx_pct") ${ctx_value}"

if [ -n "$five_pct" ]; then
  five_str="${dim}5h${reset} $(bar "$five_pct") $(printf '%.0f%%' "$five_pct")"
  [ -n "$five_reset" ] && five_str="$five_str ${dim}resets${reset} ${five_reset}"
  line="${line}${sep}${five_str}"
fi

printf '%s\n' "$line"
