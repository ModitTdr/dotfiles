return {
  'akinsho/bufferline.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers', -- show buffers (open files), not tabs
        diagnostics = 'nvim_lsp', -- optional: show LSP diagnostics in tabs
        show_buffer_close_icons = true,
        separator_style = 'thin', -- or "thin", "padded_slant", etc.
        tab_size = 14,
      },
    }
    vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>c', ':bd<CR>', { noremap = true, silent = true })

    -- Optional: Jump to specific buffer number with leader + number
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        vim.cmd('BufferLineGoToBuffer ' .. i)
      end, { noremap = true, silent = true })
    end
  end,
}
