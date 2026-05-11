require("mason").setup({ ui = { backdrop = 100 } })

require("mason-lspconfig").setup({
  automatic_enable = {
    exclude = {
      "julials"
      "efm",     -- Already using none-ls, do not auto enable efm.
    }
  },
  ensure_installed = { "lua_ls" },
})

vim.lsp.enable("julials")
