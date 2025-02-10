-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- exit insert mode with jj
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })
-- exit insert mode and save with jk
map("i", "jk", "<ESC>:w<CR>", { desc = "Exit insert mode and save" })

-- don't copy deleted char to the clipboard
map("n", "x", '"_x')

-- indcrement and decrement numbers
map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Increment number" })

-- restart lsp
map("n", "<leader>rs", "<Cmd>LspRestart<CR>", { desc = "Restart Lsp" })
