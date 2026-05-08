require("mason").setup({ ui = { backdrop = 100 } })

require("mason-lspconfig").setup({
  automatic_enable = {
    exclude = {
      "julials"
    }
  },
  ensure_installed = { "efm", "lua_ls" },
})

vim.lsp.enable("julials")
