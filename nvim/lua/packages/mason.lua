require("mason").setup({ ui = { backdrop = 100 } })

require("mason-lspconfig").setup({
  automatic_enable = {
    exclude = {
      "julials", -- Manually start julials on ftplugin/julia.lua to avoid lsp crash (known Mason issue).
    }
  },
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "html",
    "cssls",
  },
})
