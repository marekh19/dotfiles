# dotfiles

![Terminal setup with Neovim, tmux, and Ghostty](./.github/images/showcase.png)

My personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

- **Shell:** [Fish](https://fishshell.com/) + [Starship](https://starship.rs/) prompt
- **Terminal:** [Ghostty](https://ghostty.org/)
- **Multiplexer:** [herdr](https://herdr.dev/)
- **Editor:** [Neovim](https://neovim.io/) (LazyVim)
- **WM:** [AeroSpace](https://github.com/nikitabobko/AeroSpace)
- **Theme:** [meowsoot](https://github.com/marekh19/meowsoot.nvim) - my own creation
- **Font:** JetBrains Mono

## Tools

[bat](https://github.com/sharkdp/bat) ·
[fzf](https://github.com/junegunn/fzf) ·
[lazygit](https://github.com/jesseduffield/lazygit) ·
[lazydocker](https://github.com/jesseduffield/lazydocker)

## Usage

Clone into your home directory and symlink any config with `stow`:

```sh
cd ~/dotfiles
stow fish ghostty herdr lazygit nvim starship  # …or any other package

# herdr: install the Neovim navigation plugin
herdr plugin install paulbkim-dev/vim-herdr-navigation
```

## Lazygit theme

The `lazygit` package installs Meowsoot Night for Linux and macOS. Run `lg` in
Fish or `<leader>gg` in Neovim after restarting it. Snacks' automatic Lazygit
configuration is disabled so both launchers use the installed theme. Lazygit
uses the terminal background, so keep Ghostty on Meowsoot Night too.

Refresh the configs from a local Meowsoot checkout after running `just extras`
there:

```sh
cp ~/coding/personal/meowsoot.nvim/extras/lazygit/meowsoot.yml lazygit/.config/lazygit/config.yml
cp lazygit/.config/lazygit/config.yml "lazygit/Library/Application Support/lazygit/config.yml"
```

These copies contain generated theme settings only. Refreshing them replaces
the entire file. Snacks' automatic editor setup is also disabled; Lazygit uses
its normal editor configuration, including Fish's `EDITOR=nvim`.
