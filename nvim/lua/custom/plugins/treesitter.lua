return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      autotag = {  -- ✅ was "autotage" and had typo in "truee"
        enable = true,
      },
      ensure_installed = {
        "lua",
        "tsx",
        "typescript",
        "html",
        "css",
        "prisma",
      },
      auto_install = false,
    })
  end,
}

