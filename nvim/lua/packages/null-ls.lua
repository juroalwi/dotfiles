local null_ls = require("null-ls")

null_ls.setup({
  border = "rounded",
  sources = {
    null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.prettierd,
  },
})
