return {
  {
    "folke/snacks.nvim",
    opts = {
      scratch = {
        ft = "markdown",
      },
      picker = {
        sources = {
          explorer = {
            on_show = function(picker)
              local show = false
              local gap = 1
              local min_width, max_width = 20, 100
              --
              local rel = picker.layout.root
              local update = function(win) ---@param win snacks.win
                win.opts.row = vim.api.nvim_win_get_position(rel.win)[1]
                win.opts.col = vim.api.nvim_win_get_width(rel.win) + gap
                win.opts.height = 0.8
                local border = win:border_size().left + win:border_size().right
                win.opts.width = math.max(min_width, math.min(max_width, vim.o.columns - border - win.opts.col))
                win:update()
              end
              local preview_win = Snacks.win.new({
                relative = "editor",
                external = false,
                focusable = false,
                border = "rounded",
                backdrop = false,
                show = show,
                bo = {
                  filetype = "snacks_float_preview",
                  buftype = "nofile",
                  buflisted = false,
                  swapfile = false,
                  undofile = false,
                },
                on_win = function(win)
                  update(win)
                  picker:show_preview()
                end,
              })
              rel:on("WinResized", function()
                update(preview_win)
              end)
              picker.preview.win = preview_win
              picker.main = preview_win.win
            end,
            on_close = function(picker)
              picker.preview.win:close()
            end,
            layout = {
              -- preivew = 'main',
              layout = {
                backdrop = false,
                width = 40,
                min_width = 40,
                height = 0,
                position = "left",
                border = "none",
                box = "vertical",
                {
                  win = "input",
                  height = 1,
                  border = "rounded",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
                { win = "list", border = "none" },
                -- { win = 'preview', title = '{preview}', height = 0.4, border = 'top' },
              },
            },
            actions = {
              -- `<A-p>`
              toggle_preview = function(picker) --[[Override]]
                picker.preview.win:toggle()
              end,
            },
          },
        },
      },
    },
  },
}
