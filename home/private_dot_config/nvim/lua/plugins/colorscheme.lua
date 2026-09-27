--- Colours from the desktop theme (~/.config/themes).
---
--- The theme script writes ~/.local/state/theme/current/nvim.json on every theme
--- change: a palette naming a colorscheme (gruvbox, tokyonight…) uses it, any
--- other palette (galet default, auto) is applied as a tokyonight style. When nvim
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

--- Maps the palette roles to the colours of a tokyonight style, so any palette
--- gets tokyonight's highlight groups: purple keywords, teal members, orange
--- constants, a quiet gutter… Shades tokyonight has and the palette lacks are
--- mixed from the palette's colours.
--- @param p table
--- @return table
local function tokyonight_colors(p)
  local blend = require("tokyonight.util").blend
  local teal = blend(p.term6, 0.5, p.term2)
  return {
    bg = p.surface,
    bg_dark = blend(p.surface, 0.8, "#000000"),
    bg_dark1 = blend(p.surface, 0.7, "#000000"),
    bg_highlight = p.surface_raised,
    blue = p.term4,
    blue0 = blend(p.term4, 0.45, p.surface),
    blue1 = p.term6,
    blue2 = blend(p.term6, 0.85, p.surface),
    blue5 = p.accent3,
    blue6 = blend(p.term6, 0.5, "#ffffff"),
    blue7 = blend(p.term4, 0.3, p.surface),
    comment = blend(p.text_mute, 0.75, p.surface),
    cyan = p.term6,
    dark3 = blend(p.text_mute, 0.65, p.surface),
    dark5 = p.text_mute,
    fg = p.text,
    fg_dark = blend(p.text, 0.8, p.surface),
    fg_gutter = p.outline,
    green = p.term2,
    green1 = blend(p.term6, 0.6, p.term2),
    green2 = blend(p.term6, 0.6, p.surface),
    magenta = p.term5,
    magenta2 = p.crit,
    orange = p.warn,
    purple = blend(p.term5, 0.8, p.surface),
    red = p.term1,
    red1 = p.crit,
    teal = teal,
    terminal_black = p.term8,
    yellow = p.term3,
    git = {
      add = blend(p.term6, 0.7, p.surface),
      change = blend(p.term4, 0.7, p.surface),
      delete = blend(p.term1, 0.6, p.surface),
    },
  }
end

local function apply()
  local theme = read_theme()
  if not theme or not theme.follow then
    vim.cmd.colorscheme(theme and theme.fallback or FALLBACK)
  elseif type(theme.colorscheme) == "string" then
    vim.cmd.colorscheme(theme.colorscheme)
  else
    require("tokyonight.colors").styles.theme = tokyonight_colors(theme.palette)
    require("tokyonight").load({ style = "theme" })
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

  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true, opts = { flavour = "macchiato" } },
}
