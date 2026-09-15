# Global preferences

## Writing

Applies to everything I read: chat, investigations, reports, issue and PR bodies, commits, plans, docs, and comments.

- Apply the plain-language principles of ISO 24495-1:2023.
- Lead with the result. Include evidence, limitations, and decisions that affect my next step.
- Use specific, literal wording that non-native English speakers can understand. Avoid idioms and slang. Be concise without omitting information needed to understand or act.
- Prefer short sentences with one main point each. Keep related conditions and consequences together when that makes the meaning clearer.
- Use active voice. Name who or what performs the action.
- Skip filler, process narration, repeated summaries, and restating diffs. Discuss rejected options only when they explain a decision I need to make.
- Avoid stock introductions, exaggerated claims, rhetorical contrasts, and sentence fragments used for dramatic emphasis.
- Prefer short paragraphs; use bullets for parallel points. Bold key terms only.
- No em dashes. No emoji unless I use them first.
- Keep comments and decision summaries to one or two sentences unless more detail is necessary to explain a constraint or consequence.

## Code comments

- Comment only what the code cannot explain: non-obvious constraints, limitations, and workarounds. Include removal conditions when useful; keep change history in commits.
- JSDoc only on public API others consume, and only for details the signature doesn't convey.

## Engineering

- Follow the repository's established conventions unless the task calls for changing them.
- Understand the affected flow before editing. Inspect affected callers when changing behavior or a contract; fix the root cause across affected paths.
- Reuse existing code, installed dependencies, and platform features; add only what the task needs.
- Prefer the simplest correct design; abstractions should solve a current problem. Make limits configurable when requirements justify it.
- Handle real inputs and failures. Validate inputs at trust boundaries and protect security, accessibility, and data integrity.
- Test meaningful behavior and regressions using the existing setup. Scale checks to risk. No new test frameworks unless asked.
- Run the repository's required checks relevant to the change. Report results and any checks you couldn't run, with the reason.

## TypeScript

- Functional and immutable. Prefer early returns.
- No `any`. Prefer inference, `satisfies`, and narrowing; justify unavoidable type assertions. `as const` is fine.
- No eslint-disable without a one-line justification.

## Git

- Routine commit: single-line Conventional Commits title, no body. Body only for a breaking change, a complex migration, or when I ask.
- New commit over `--amend`. Amend only to fix up my just-made, still-unpushed commit, or when I ask.
- Never push unless I say so, or unless push is a documented step of a slash command currently running. After a rebase, amend, or commit on a published branch, stop after the commit. I'll push.
- No Claude attribution in commits or PR bodies: no `Co-Authored-By` trailer or Claude Code footer.
- Never post replies to GitHub review comments yourself. Draft the reply in the session and let me copy it over.

## Tooling

Available: `gh` (authenticated, SSH), `rg`, `fd`, `fzf`, `jq`, `bat`, `delta`, `yq`.

- Node comes from `fnm`. Run it through the project's version, not a system binary.
- Shell is fish. Use `bash -c` for bash-specific syntax.
