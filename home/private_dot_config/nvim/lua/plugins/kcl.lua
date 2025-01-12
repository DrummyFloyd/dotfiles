return {
  { "kcl-lang/kcl.nvim" },
  {
    "kcl-lang/tree-sitter-kcl",
    build = ":TSUpdate kcl",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        require("nvim-treesitter.parsers").get_parser_configs().kcl = {
          install_info = {
            url = "https://github.com/kcl-lang/tree-sitter-kcl",
            files = { "src/parser.c" },
            branch = "main",
          },
          filetype = "kcl",
        }
      end,
    },
  },
}
