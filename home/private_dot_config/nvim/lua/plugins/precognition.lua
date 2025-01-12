-- Plugin configuration
return {
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local p = require("precognition")
      local toggleState
      opts.startVisible = false
      Snacks.toggle({
        name = "Precognition",
        get = function()
          return toggleState
        end,
        set = function(state)
          toggleState = p.toggle()
        end,
      }):map("<leader>uP")
    end,
  },
}
