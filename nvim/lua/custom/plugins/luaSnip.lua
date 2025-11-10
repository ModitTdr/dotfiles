return {
  -- Snippet engine
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local luasnip = require 'luasnip'

      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load {
        paths = { vim.fn.stdpath 'config' .. '/snippets' },
      }

      vim.keymap.set({ 'i', 's' }, '<C-k>', function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<C-j>', function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { silent = true })
    end,
  },
  -- Snippet source for nvim-cmp
  {
    'saadparwaiz1/cmp_luasnip',
    dependencies = { 'L3MON4D3/LuaSnip' },
  },
}
