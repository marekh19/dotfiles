-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
-- take "-" as a part of word
opt.iskeyword:append("-")

-- require prettier config to enable auto-formatting with prettier plugin
vim.g.lazyvim_prettier_needs_config = true

-- macOS uses pbcopy/pbpaste automatically. A Linux host without a display has no
-- clipboard tool, so copy through OSC 52 to the terminal on the local machine.
-- Paste reads Neovim's own register because OSC 52 reads are slow and the
-- terminal may ask for permission each time; use the terminal paste for system text.
local has_display = vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY
if vim.fn.has("mac") == 0 and not has_display then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
