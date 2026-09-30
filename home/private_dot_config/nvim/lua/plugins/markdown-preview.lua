-- Maintained Lua fork of iamcco/markdown-preview.nvim (no Node.js needed).
-- Same plugin name as the one in LazyVim's lang.markdown extra, so this spec
-- merges into it: override every field that only makes sense upstream.
--  TODO: make a PR to use this fork ?
return {
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    build = false,
    cmd = function()
      return { "MarkdownPreview", "MarkdownPreviewRefresh", "MarkdownPreviewStop" }
    end,
    keys = function()
      return {
        { "<leader>cp", "<cmd>MarkdownPreview<cr>", ft = "markdown", desc = "Markdown Preview" },
        { "<leader>cP", "<cmd>MarkdownPreviewStop<cr>", ft = "markdown", desc = "Markdown Preview Stop" },
      }
    end,
    opts = {},
    config = function(_, opts)
      require("markdown_preview").setup(opts)
    end,
  },
}
