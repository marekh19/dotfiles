return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          layout = {
            layout = {
              position = "right",
              width = 36,
            },
          },
        },
        files = {
          hidden = true,
        },
      },
    },
  },
}
