return {
  -- Snippet engine
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*', -- optional, but recommended
    build = 'make install_jsregexp', -- needed for advanced regex
    dependencies = {
      -- VSCode-style snippet loader
      'rafamadriz/friendly-snippets',
    },
    config = function()
      -- Load VSCode-style snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      -- ✅ Load custom Lua snippets from this folder
      require('luasnip.loaders.from_lua').load {
        paths = vim.fn.stdpath 'config' .. '/lua/custom/snippets',
      }
    end,
  },

  -- Snippet source for nvim-cmp
  {
    'saadparwaiz1/cmp_luasnip',
    dependencies = { 'L3MON4D3/LuaSnip' },
  },
}
