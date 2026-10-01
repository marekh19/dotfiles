return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      dashboard = { enabled = false },
      lazygit = { configure = false },
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          grep = {
            hidden = true,
          },
        },
      },
    },
    keys = {
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>E", false },
      { "<leader>e", false },
    },
  },
}
