local function enable_transparency()
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
end

return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        transparent = true,
        styles = {
          comments = { italic = false }, -- Disable italics in comments
          sidebars = 'transparent',
          floats = 'transparent',
        },
        on_colors = function(colors)
          colors.fg_gutter = '#989C94' -- Set the color for the gutter (line numbers, etc.)
        end,
        on_highlights = function(highlights, colors)
          highlights.Folded = { fg = colors.fg_gutter, bg = 'NONE', italic = false }
          highlights.CursorLine = {
            bg = '#0A0A0A',
          }
          highlights.LspReferenceText = {
            bg = '#222436',
          }
          highlights.LspReferenceRead = {
            bg = '#222436',
          }
          highlights.LspReferenceWrite = {
            bg = '#222436',
          }
          highlights.Comment = {
            fg = '#989C94',
            italic = false, -- Disable italics in comments
          }
        end,
      }

      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
}
