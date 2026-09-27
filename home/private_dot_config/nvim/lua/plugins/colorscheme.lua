--- Colours from the desktop theme (~/.config/themes).
---
--- The theme script writes ~/.local/state/theme/current/nvim.json on every theme
--- change: a palette naming a colorscheme (gruvbox, tokyonight…) uses it, any
--- other palette (galet default, auto) is applied through mini.base16. When nvim
--- does not follow the theme (~/.config/themes/settings.json), the fallback
--- colorscheme is used. Running instances pick changes up on their own.

local THEME_FILE = vim.fn.expand("~/.local/state/theme/current/nvim.json")
local FALLBACK = "tokyonight"

--- @return table|nil
local function read_theme()
  local ok, lines = pcall(vim.fn.readfile, THEME_FILE)
  if not ok or #lines == 0 then
    return nil
  end
  local decoded, theme = pcall(vim.json.decode, table.concat(lines, "\n"))
  return decoded and theme or nil
end

--- Maps the palette roles to the 16 base16 slots.
--- @param p table
--- @return table
local function base16(p)
  return {
    base00 = p.surface,
    base01 = p.surface_raised,
    base02 = p.outline,
    base03 = p.text_mute,
    base04 = p.text_mute,
    base05 = p.text,
    base06 = p.text,
    base07 = p.term15,
    base08 = p.term1,
    base09 = p.accent2,
    base0A = p.term3,
    base0B = p.term2,
    base0C = p.term6,
    base0D = p.term4,
    base0E = p.term5,
    base0F = p.accent3,
  }
end

--- base16 draws the gutter and indent guides in the comment colour on a raised
--- background, so they stand out as much as the code. Draw them in the outline
--- colour on the editor background instead, as the tokyonight family does.
--- @param p table
local function tone_down(p)
  local groups = {
    LineNr = { fg = p.outline },
    LineNrAbove = { fg = p.outline },
    LineNrBelow = { fg = p.outline },
    CursorLineNr = { fg = p.text_mute },
    SignColumn = { fg = p.text_mute },
    FoldColumn = { fg = p.outline },
    SnacksIndent = { fg = p.outline },
    SnacksIndentScope = { fg = p.text_mute },
    MiniIndentscopeSymbol = { fg = p.text_mute },
  }
  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

local function apply()
  local theme = read_theme()
  if not theme or not theme.follow then
    vim.cmd.colorscheme(theme and theme.fallback or FALLBACK)
  elseif type(theme.colorscheme) == "string" then
    vim.cmd.colorscheme(theme.colorscheme)
  else
    vim.cmd("highlight clear")
    require("mini.base16").setup({ palette = base16(theme.palette) })
    tone_down(theme.palette)
    vim.g.colors_name = "theme"
  end
end

--- Re-applies when the theme script rewrites nvim.json.
local function watch()
  local dir = vim.fn.fnamemodify(THEME_FILE, ":h")
  local handle = vim.uv.new_fs_event()
  if not handle or vim.fn.isdirectory(dir) == 0 then
    return
  end

  local timer = vim.uv.new_timer()
  handle:start(dir, {}, function(_, file)
    if file ~= "nvim.json" then
      return
    end
    -- The script rewrites the whole directory: wait for it to settle.
    timer:start(200, 0, vim.schedule_wrap(apply))
  end)
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        apply()
        watch()
      end,
    },
  },

  { "nvim-mini/mini.base16", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true, opts = { flavour = "macchiato" } },
}
