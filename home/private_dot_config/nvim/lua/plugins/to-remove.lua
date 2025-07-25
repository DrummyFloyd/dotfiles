return {
  -- Remove once https://github.com/LazyVim/LazyVim/pull/6053 ie merge
  {
    "LazyVim/LazyVim",
    url = "https://github.com/dpetka2001/LazyVim",
    branch = "fix/mason-v2",
  },
  -- Remove once https://github.com/LazyVim/LazyVim/pull/5900 is released
  {
    "zbirenbaum/copilot.lua",
    opts = function()
      require("copilot.api").status = require("copilot.status")
    end,
  },
}
