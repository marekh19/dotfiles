-- Seamless <C-h/j/k/l> between Neovim splits and herdr panes.
-- herdr side: `herdr plugin install paulbkim-dev/vim-herdr-navigation`.
--
-- LazyVim maps <C-h/j/k/l> to <C-w> window moves on the VeryLazy event, which
-- fires AFTER plugin `config`. So load the herdr-aware maps on `LazyVimKeymaps`
-- (fired right after LazyVim's default keymaps) so ours win — otherwise splits
-- move but focus never crosses out of Neovim.
return {
  "paulbkim-dev/vim-herdr-navigation",
  lazy = false,
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimKeymaps",
      callback = function()
        dofile(vim.fn.stdpath("data") .. "/lazy/vim-herdr-navigation/editor/nvim.lua")
      end,
    })
  end,
}
