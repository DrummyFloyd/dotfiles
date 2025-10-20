return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["*"] = { "trim_whitespace", "trim_newlines" },
        ["zsh"] = { "shfmt" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
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
        python = { "ruff" },
      },
    },
  },
}
