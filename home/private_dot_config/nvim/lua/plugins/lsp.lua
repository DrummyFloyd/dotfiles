return {
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      -- diagnostics = {
      --   float = {
      --     border = "rounded",
      --   },
      -- },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- add mason ensure installed here
        "gitlab-ci-ls",
        "kcl",
        "tree-sitter-cli",
        "golangci-lint",
      })
      opts.max_concurrent_installers = 6
      opts.ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- add TS here
      })
      opts.auto_install = true
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        bashls = {
          settings = {
            bashls = {
              filetypes = { "sh", "zsh" },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              customTags = {
                -- gitlab-ci.yml
                "!reference sequence",
                -- Authentik blueprint
                "!Condition sequence",
                "!Context scalar",
                "!Enumerate sequence",
                "!Env scalar",
                "!Find sequence",
                "!Format sequence",
                "!If sequence",
                "!Index scalar",
                "!KeyOf scalar",
                "!Value scalar",
              },
            },
          },
        },
      },
    },
  },
}
