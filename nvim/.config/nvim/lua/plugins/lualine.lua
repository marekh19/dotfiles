return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- disable section "z" section (clock)
      opts.sections.lualine_z = {}
    end,
  },
}
