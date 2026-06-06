local pack = require("utils.packages")

pack.add({
  { "catppuccin/nvim" },
  { "neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim",            require = "packages.mason" },
  { "mason-org/mason-lspconfig.nvim" },
  { "nvimtools/none-ls.nvim",          require = "packages.null-ls" },
  { "nvimtools/none-ls-extras.nvim" },
  { "saghen/blink.cmp",                require = "packages.blink-cmp" },
  { "saghen/blink.lib" },
  { "windwp/nvim-autopairs",           setup = true },
  { "windwp/nvim-ts-autotag",          setup = true },
  { "nvim-mini/mini.extra",            setup = true },
  { "nvim-mini/mini.icons",            setup = true },
  { "nvim-mini/mini.indentscope",      setup = true },
  { "nvim-mini/mini.comment",          setup = true },
  { "nvim-mini/mini.files",            require = "packages.mini-files" },
  { "nvim-mini/mini.pick",             require = "packages.mini-pick" },
  { "nvim-mini/mini.diff",             require = "packages.mini-diff" },
  { "nvim-mini/mini.surround",         require = "packages.mini-surround" },
  { "nvim-lua/plenary.nvim" },
  { "olimorris/codecompanion.nvim",    require = "packages.codecompanion", version = vim.version.range("^19.0.0") },
  { "nvim-treesitter/nvim-treesitter", require = "packages.treesitter" },
  { "tpope/vim-fugitive",              require = "packages.fugitive" },
})

vim.api.nvim_create_user_command("PackClean", function()
  pack.clean()
end, { nargs = 0 })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  pack.update(opts.args)
end, { nargs = "*" })
