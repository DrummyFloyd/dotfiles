return {
  {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    event = "VeryLazy",
    keys = function()
      local wk = require("which-key")
      wk.add({
        {
          mode = { "x" },
          {
            "<leader>cs",
            "<Esc><cmd>CodeSnap<cr>",
            icon = "󰄀",
            desc = "CodeSnap to Clipboard",
          },
          {
            "<leader>cS",
            "<Esc><cmd>CodeSnapSave<cr>",
            icon = "󰄀",
            desc = "CodeSnap to File",
          },
          {
            "<leader>ch",
            "<Esc><cmd>CodeSnapHighlight<cr>",
            icon = "󰄀",
            desc = "CodeSnap Highlight to Clipboard",
          },
          {
            "<leader>cH",
            "<Esc><cmd>CodeSnapSaveHighlight<cr>",
            icon = "󰄀",
            desc = "CodeSnap Highlight to File",
          },
          {
            "<leader>cA",
            "<Esc><cmd>CodeSnapASCII<cr>",
            icon = "󰄀",
            desc = "CodeSnap ASCII to Clipboard",
          },
        },
      })
    end,
    lazy = true,
    opts = {
      mac_window_bar = false,
      save_path = "~/Pictures/",
      has_breadcrumbs = true,
      show_workspace = true,
      bg_theme = "sea",
      watermark = "",
      code_font_family = "FiraCode Nerd Font",
      has_line_number = true,
    },
  },
}
