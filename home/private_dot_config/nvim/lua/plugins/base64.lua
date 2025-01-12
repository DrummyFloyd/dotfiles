return {
  "taybart/b64.nvim",
  event = "VeryLazy",
  keys = function()
    local wk = require("which-key")
    wk.add({
      {
        mode = { "x" },
        { "<Leader>ed", "<cmd>lua require('b64').decode()<cr>", desc = "From Base64" },
        { "<Leader>ee", "<cmd>lua require('b64').encode()<cr>", desc = "To Base64" },
      },
    })
  end,
}
