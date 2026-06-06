local null_ls = require("null-ls")

null_ls.setup({
  border = "rounded",
  sources = {
    null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.prettierd,
    -- require("none-ls.diagnostics.eslint_d"),
    -- require("none-ls.formatting.eslint_d"),
    -- require("none-ls.code_actions.eslint_d"),
  },
})
