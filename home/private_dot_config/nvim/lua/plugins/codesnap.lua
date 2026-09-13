-- CodeSnap.nvim v2 -- pretty code snapshots
-- Docs: https://github.com/mistricky/codesnap.nvim
--
-- v2 notes (the old v1 options below no longer exist):
--  * no `build` step: the Rust `generator` is precompiled and downloaded on first
--    use (linux-x86_64_generator.so, from the matching GitHub release)
--  * `save_path` is gone -- `CodeSnapSave` takes an explicit path argument and
--    only accepts the `.png` extension, and it does not expand "~"
--  * mac_window_bar / has_breadcrumbs / bg_theme / code_font_family /
--    has_line_number / watermark moved into `snapshot_config`
--
-- Wayland: the clipboard is owned by the nvim process, so a snapshot copied with
-- `CodeSnap` disappears once nvim quits. Install wl-clip-persist to keep it.
local function timestamped_png()
  local dir = vim.fn.expand("~/Pictures/codesnap")

  vim.fn.mkdir(dir, "p")

  local name = vim.fn.expand("%:t:r")

  return string.format("%s/%s-%s.png", dir, name == "" and "snapshot" or name, os.date("%Y%m%d-%H%M%S"))
end

return {
  "mistricky/codesnap.nvim",
  version = "^2",
  cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapASCII", "CodeSnapHighlight", "CodeSnapshot" },
  -- CodeSnapHighlightSave exists but `save_highlight()` is still an empty stub
  -- upstream (v2.1.0), so it is not mapped here.
  keys = {
    { "<leader>cs", "<Esc><cmd>CodeSnap<cr>", mode = "x", desc = "CodeSnap to Clipboard" },
    { "<leader>cS", "<Esc><cmd>CodeSnapshot<cr>", mode = "x", desc = "CodeSnap to File" },
    { "<leader>ch", "<Esc><cmd>CodeSnapHighlight<cr>", mode = "x", desc = "CodeSnap Highlight to Clipboard" },
    { "<leader>cA", "<Esc><cmd>CodeSnapASCII<cr>", mode = "x", desc = "CodeSnap ASCII to Clipboard" },
  },
  opts = {
    show_line_number = true,
    show_workspace = true,
    highlight_color = "#ffffff20",
    snapshot_config = {
      -- built-in themes are Sublime themes; a VSCode theme can be pulled in with
      -- an "Asset URL" (name@url), e.g.
      -- theme = "tokyonight@https://raw.githubusercontent.com/enkia/tokyo-night-vscode-theme/master/themes/tokyo-night-storm-color-theme.json",
      theme = "candy",
      -- 3 by default; bump for a sharper (bigger) image
      scale_factor = 3,
      -- watermark cannot be removed with "none" (upstream merge bug re-adds it as
      -- a string and the generator then fails); an empty content renders nothing
      watermark = { content = "" },
      line_number_color = "#495162",
      window = {
        mac_window_bar = false,
        radius = 12,
        margin = { x = 60, y = 60 },
        border = { width = 1, color = "#ffffff30" },
        shadow = { radius = 20, color = "#00000040" },
      },
      -- CaskaydiaCove/Pacifico are bundled in the generator. Any other family is
      -- taken from the installed system fonts, but a wider one (FiraCode Nerd
      -- Font for instance) makes long lines overflow the window: upstream sizes
      -- the window with the default font metrics.
      code_config = {
        font_family = "CaskaydiaCove Nerd Font",
        breadcrumbs = {
          enable = true,
          separator = "/",
          color = "#80848b",
          font_family = "CaskaydiaCove Nerd Font",
        },
      },
      background = {
        start = { x = 0, y = 0 },
        ["end"] = { x = "max", y = "max" },
        stops = {
          { position = 0, color = "#7aa2f7" },
          { position = 1, color = "#bb9af7" },
        },
      },
    },
  },
  config = function(_, opts)
    require("codesnap").setup(opts)

    -- `CodeSnapSave` needs an explicit path, so wrap it into a no-argument command
    vim.api.nvim_create_user_command("CodeSnapshot", function()
      require("codesnap").save(timestamped_png())
    end, { range = "%", desc = "Save a CodeSnap snapshot in ~/Pictures/codesnap" })
  end,
}
