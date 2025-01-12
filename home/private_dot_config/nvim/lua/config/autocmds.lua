-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- ~/.config/nvim/lua/config/autocmds.lua

-- highlight trailing whitespace
vim.cmd([[
  autocmd BufReadPre * hi TrailingWhitespace guibg=red|match TrailingWhitespace /\s\+$/
]])

-- set filetype for .tf files
vim.filetype.add({
  extension = {
    tf = "terraform",
  },
})
