return {

  "folke/sidekick.nvim",
  keys = {
    {
      "<c-,>",
      function()
        require("sidekick.cli").focus()
      end,

      mode = { "n", "x", "i", "t" },

      desc = "Sidekick Switch Focus",
    },
  },
}
