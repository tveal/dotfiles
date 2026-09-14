-- Options are automatically loaded before lazy.nvim startup.
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.g.autoformat = false
vim.g.lazyvim_picker = "snacks"

-- override the default root detection logic to always use the current working
-- directory for commands like file finding, grepping, and Neo-tree
vim.g.root_spec = { "cwd" }

vim.diagnostic.enable(false)
vim.lsp.inlay_hint.enable(false)
vim.g.snacks_animate = false

vim.g.lazyvim_log_level = "info"
vim.g.lazyvim_debug = false

