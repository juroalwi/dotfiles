require("nvim-treesitter").setup()
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start) -- Highlighting.
    vim.bo.indentexpr = (       -- Indentation.
      "v:lua.require('nvim-treesitter').indentexpr()"
    )
  end,
})
