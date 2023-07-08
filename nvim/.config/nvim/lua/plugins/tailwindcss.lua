-- Add color bg to tailwindcss classes in the editor
return {
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
        hsl_fn = true,
      },
    },
  },
}
