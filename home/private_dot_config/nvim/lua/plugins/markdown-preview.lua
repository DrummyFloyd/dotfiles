-- mdkite.nvim: maintained Lua fork of iamcco/markdown-preview.nvim (no Node.js needed).
-- Its name differs from the plugin in LazyVim's lang.markdown extra, so disable that one.
--  TODO: drop once LazyVim/LazyVim#7264 is merged
return {
  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "selimacerbas/mdkite.nvim",
    cmd = "MdKite",
    keys = {
      { "<leader>cp", "<cmd>MdKite toggle<cr>", ft = "markdown", desc = "Markdown Preview" },
    },
    opts = {},
  },
  { "selimacerbas/kitehost.nvim", lazy = true },
}
