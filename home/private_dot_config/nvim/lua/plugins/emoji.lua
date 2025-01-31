return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "moyiz/blink-emoji.nvim",
    },
    opts_extend = { "sources.default" },
    opts = {
      sources = {
        default = {
          "emoji",
        },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15,
            opts = { insert = true },
          },
        },
      },
    },
  },
}
