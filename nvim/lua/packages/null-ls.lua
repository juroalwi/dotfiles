local null_ls = require("null-ls")

null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.prettier,
    require("none-ls.diagnostics.eslint_d").with({
      env = { ESLINT_USE_FLAT_CONFIG = "false" },
      ignore_stderr = true,
    }),
  },
})
