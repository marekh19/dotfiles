# disk-sweep

Frees disk space by deleting caches and rebuildable files that have not been
used recently. Runs weekly through a systemd user timer. Linux only: it reads
`/proc` to find repos that are in use.

Without `--apply`, it only prints what it would delete and why it keeps the
rest.

## What it deletes

Everything it deletes can be rebuilt or downloaded again. It never deletes
Docker volumes, Ollama models, Node versions, or source files.

| Target | Rule |
|---|---|
| `node_modules` in repos | The repo is idle (see below). It deletes every `node_modules` in the repo, including those in workspace packages. |
| pnpm stores | Runs `pnpm store prune` for each store version that a repo uses. Deletes a store version that no repo uses. |
| npm cache | Deletes files in `~/.npm/_cacache` not read for 30 days, then runs `npm cache verify`. |
| Cache folders | Deletes a version folder when no file inside was read for 30 days: `~/.npm/_npx`, Cypress, Playwright, Puppeteer, corepack. |
| Codex releases | Keeps the release that `current` points to and the releases in `selection-history`. Skips a package while Codex holds its `install.lock`. |
| Docker build cache | `docker builder prune --all` for cache not used for 7 days. |
| Docker images | `docker image prune --all` for images created 14 or more days ago that no container uses, running or stopped. |
| uv and Homebrew | `uv cache prune` and `brew cleanup --prune=30`. |

It also prints installed Node versions that no repo pins in `.nvmrc` or
`.node-version`, but it does not remove them.

A repo is **idle** when all are true:

- No file outside `node_modules` and `.git` changed in the last 30 days.
- `HEAD` did not move in the last 30 days in any of its worktrees. A commit,
  checkout, pull, or rebase moves it. `git fetch` does not.
- No process has its working directory or an open file inside it, and Neovim
  has no swap file for a file inside it.

It scans repos that are direct children of `~/coding/apify` and
`~/coding/personal`. To restore deleted `node_modules`, run `pnpm install`.

## Install

```sh
cd ~/dotfiles
stow disk-sweep
systemctl --user daemon-reload
systemctl --user enable --now disk-sweep.timer
```

The timer runs `disk-sweep --apply` every Monday at 10:00 Prague time. If the
machine was off at that time, it runs at the next boot.

## Usage

```sh
disk-sweep           # dry run
disk-sweep --apply   # delete
```

To check the timer:

```sh
systemctl --user list-timers disk-sweep.timer   # next run
journalctl --user -u disk-sweep.service         # output of past runs
systemctl --user start disk-sweep.service       # run now
```

Each deleted path and its size is logged in
`~/.local/state/disk-sweep/deleted.tsv`.

## Settings

Set these as environment variables. For the timer, add `Environment=` lines to
`.config/systemd/user/disk-sweep.service`.

| Variable | Default | Meaning |
|---|---|---|
| `DISK_SWEEP_ROOTS` | `~/coding/apify ~/coding/personal` | Folders with repos to scan, separated by spaces |
| `DISK_SWEEP_IDLE_DAYS` | `30` | Days without use before a repo's `node_modules` or a cache entry is deleted |
| `DISK_SWEEP_DOCKER_CACHE_DAYS` | `7` | Days without use before Docker build cache is deleted |
| `DISK_SWEEP_DOCKER_IMAGE_DAYS` | `14` | Minimum age of an unused Docker image before it is deleted |
| `DISK_SWEEP_PNPM_STORE_ROOT` | `~/.local/share/pnpm/store` | Folder that holds the pnpm store versions |

## Limitations

- Linux only. The script exits with an error if `/proc` is missing.
- Cache entries are judged by file access time. This needs the `relatime` or
  `strictatime` mount option, not `noatime`.
- It finds pnpm store users only in the scanned repos. Deleting a store that a
  project elsewhere uses does not break that project, because pnpm hard-links
  files into `node_modules`, but its next install downloads the packages again.
- It cannot see processes inside Docker containers, so a repo that is only
  bind-mounted into a container counts as unused.
- Docker filters images by creation time, not by last use. An unused image
  that was pulled yesterday but built a month ago is deleted.
