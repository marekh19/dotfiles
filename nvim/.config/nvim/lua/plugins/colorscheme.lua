return {
  {
    "marekh19/meowsoot.nvim",
    -- dir = "/Users/marekhonzal/coding/personal/meowsoot.nvim",
    name = "meowsoot.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- THEME_NVIM is set by fish/.config/fish/theme.fish. Fall back to
      -- meowsoot when that colorscheme is not installed.
      colorscheme = function()
        if not pcall(vim.cmd.colorscheme, vim.env.THEME_NVIM or "meowsoot") then
          vim.cmd.colorscheme("meowsoot")
        end
      end,
    },
  },
}
