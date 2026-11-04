return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      checkbox = {
        enabled = true,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          -- markdownlint-cli2 ignores --config when it comes after the "-" stdin glob.
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.json" },
        },
      },
    },
  },
}
