local pack = require("utils.packages")

vim.cmd('packadd nvim.undotree')

pack.add({
  { "catppuccin/nvim" },
  { "nvim-treesitter/nvim-treesitter", require = "packages.treesitter" },
  { "neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim",            require = "packages.mason" },
  { "mason-org/mason-lspconfig.nvim" },
  { "nvimtools/none-ls.nvim",          require = "packages.null-ls" },
  { "nvimtools/none-ls-extras.nvim" },
  { "nvim-mini/mini.pairs",            setup = true },
  { "nvim-mini/mini.extra",            setup = true },
  { "nvim-mini/mini.icons",            setup = true },
  { "nvim-mini/mini.indentscope",      setup = true },
  { "nvim-mini/mini.comment",          setup = true },
  { "nvim-mini/mini.files",            require = "packages.mini-files" },
  { "nvim-mini/mini.pick",             require = "packages.mini-pick" },
  { "nvim-mini/mini.diff",             require = "packages.mini-diff" },
  { "nvim-mini/mini.surround",         require = "packages.mini-surround" },

  { "nvim-lua/plenary.nvim" },
  { "saghen/blink.cmp",                require = "packages.blink-cmp",     version = "v1" },
  { "olimorris/codecompanion.nvim",    require = "packages.codecompanion", version = vim.version.range("^19.0.0") },
  { "tpope/vim-fugitive",              require = "packages.fugitive" },
})

vim.api.nvim_create_user_command("PackClean", function()
  pack.clean()
end, { nargs = 0 })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  pack.update(opts.args)
end, { nargs = "*" })
