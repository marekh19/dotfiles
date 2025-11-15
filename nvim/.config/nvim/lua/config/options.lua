-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
-- take "-" as a part of word
opt.iskeyword:append("-")

-- require prettier config to enable auto-formatting with prettier plugin
vim.g.lazyvim_prettier_needs_config = true
