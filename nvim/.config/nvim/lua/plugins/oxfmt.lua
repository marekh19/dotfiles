-- Only run oxfmt when the project has an oxfmt config file.
-- The `lang/typescript/oxc` extra registers oxfmt as a formatter for JS/TS/Vue/Svelte/Astro
-- unconditionally, which formats files in repos that haven't opted into oxfmt. Mirrors the
-- pattern from the `formatting/prettier` extra (`vim.g.lazyvim_prettier_needs_config`), which
-- oxc doesn't expose its own flag for.
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.oxfmt = {
        condition = function(_, ctx)
          return vim.fs.root(ctx.dirname, {
            ".oxfmtrc.json",
            ".oxfmtrc.jsonc",
            "oxfmt.config.ts",
          }) ~= nil
        end,
      }
    end,
  },
}
