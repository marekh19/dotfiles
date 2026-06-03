return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options.component_separators = ""
      opts.options.section_separators = { left = "", right = "" }
      -- disable section "z" section (clock)
      opts.sections.lualine_z = {}
      opts.sections.lualine_a = {
        {
          "mode",
          fmt = function(s)
            return " " .. s
          end,
        },
      }
    end,
  },
}
