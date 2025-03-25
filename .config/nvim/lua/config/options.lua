-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.title = true
vim.opt.colorcolumn = "120"

local share_path = os.getenv("HOME") .. "/.local/share"
vim.env.PATH =
  string.format("%s/nvim-python/bin:%s/nvim-node/aliases/default/bin:%s", share_path, share_path, vim.env.PATH)
