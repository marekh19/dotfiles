# git-sweep

Deletes local git branches and linked worktrees that are finished. Runs daily
through a systemd user timer. Linux only: it reads `/proc` to find worktrees
that are in use.

Without `--apply`, it only prints what it would delete and why it keeps the
rest.

## What it deletes

A **branch** is finished when both are true:

- Its tip is in `origin/<default branch>`, or its tip is the head of a merged
  GitHub PR, or its tip is contained in a merged PR with the same branch name.
  The PR checks cover squash merges and need `gh`.
- It has been idle for 3 or more days.

It keeps a branch that is checked out in any worktree or has a stash entry. It
never deletes the default branch.

A **linked worktree** is finished when all are true:

- Its branch is finished, or its detached HEAD is in a remote branch.
- `git status` shows no modified or untracked files.
- It is not locked, and no rebase, merge, cherry-pick, or bisect is in
  progress.
- No process has its working directory or an open file inside it, and Neovim
  has no swap file for a file inside it.
- Its HEAD has not changed for 3 or more days.

Removing a worktree also deletes its git-ignored files, such as `.env` and
`node_modules`.

It scans repos that are direct children of `~/coding/apify` and
`~/coding/personal`. A repo needs `origin/HEAD` to be set; otherwise git-sweep
skips it. To set it, run `git remote set-head origin --auto` in the repo.

## Install

```sh
cd ~/dotfiles
stow git-sweep
systemctl --user daemon-reload
systemctl --user enable --now git-sweep.timer
```

The timer runs `git-sweep --apply` once a day, at a random time within one
hour of midnight. If the computer was off at that time, it runs at the next
boot.

## Usage

```sh
git-sweep                              # dry run, all repos
git-sweep --repo ~/coding/apify/foo    # dry run, one repo
git-sweep --apply                      # delete, all repos
git-sweep --apply --repo ~/coding/apify/foo
```

Run a dry run before the first `--apply`, and read the `delete` lines.

To check the timer:

```sh
systemctl --user list-timers git-sweep.timer   # next run
journalctl --user -u git-sweep.service         # output of past runs
systemctl --user start git-sweep.service       # run now
```

The timer has no SSH agent, so `git fetch` can fail. git-sweep then prints
`warn` and uses the last fetched state, which can only make it keep more.

## Settings

Set these as environment variables. For the timer, add `Environment=` lines to
`.config/systemd/user/git-sweep.service`.

| Variable | Default | Meaning |
|---|---|---|
| `GIT_SWEEP_ROOTS` | `~/coding/apify ~/coding/personal` | Folders to scan, separated by spaces |
| `GIT_SWEEP_MIN_IDLE_DAYS` | `3` | Days without activity before a branch or worktree can be deleted |
| `GIT_SWEEP_ARCHIVE_DAYS` | `30` | Days the archived branch tips are kept |

## Restore a deleted branch

Before git-sweep deletes a branch, it saves the tip as
`refs/sweep-archive/<date>/<branch>`. Each deletion is also logged in
`~/.local/state/git-sweep/deleted.tsv`.

```sh
git for-each-ref refs/sweep-archive
git branch my-branch refs/sweep-archive/2026-11-04/my-branch
```

A deleted worktree cannot be restored, but its commits stay on its branch.
Recreate it with `git worktree add <path> <branch>`.

## Limitations

- Linux only. The script exits with an error if `/proc` is missing.
- It cannot see processes inside Docker containers, so a worktree that is only
  bind-mounted into a container counts as unused.
