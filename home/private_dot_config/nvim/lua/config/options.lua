-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.backspace = "2"
opt.confirm = false -- disable confirm save on exit
opt.shell = "/bin/zsh"
-- option nvim 0.9 better dif
opt.diffopt:append("linematch:60")
opt.relativenumber = true -- set relative line numbers

-- options python lsp
vim.g.lazyvim_python_lsp = "basedpyright"
-- vim.g.lazyvim_python_ruff = "ruff_lsp"
vim.g.deprecation_warnings = true -- enable deprecation warnings
-- inlay AI completion with TAB instead of traditional completion
vim.g.ai_cmp = false
-- better coop with fzf-lua
vim.env.FZF_DEFAULT_OPTS = ""
vim.g.snacks_animate = false
