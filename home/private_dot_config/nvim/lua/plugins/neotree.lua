return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "s1n7ax/nvim-window-picker",
    opts = {
      hint = "floating-big-letter",
      show_prompt = false,
      filter_rules = {
        autoselect_one = true,
        bo = {
          filetype = { "NvimTree", "neo-tree", "notify", "smear-cursor" },

          buftype = { "terminal", "quickfix", "nofile" },
        },
      },
    },
  },
  opts = {
    window = {
      mappings = {
        ["S"] = "split_with_window_picker",
        ["s"] = "vsplit_with_window_picker",
      },
    },
  },
}
