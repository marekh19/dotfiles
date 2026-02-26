return {
  "zenbones-theme/zenbones.nvim",
  dependencies = "rktjmp/lush.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    vim.cmd([[colorscheme tokyobones]])
  end,
}
