return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["*"] = { "trim_whitespace", "trim_newlines" },
        ["zsh"] = { "shfmt" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        ["ansible"] = { "ansible_lint" },
        ["zsh"] = { "shellcheck" },
        go = { "golangcilint" },
      },
    },
  },
}
