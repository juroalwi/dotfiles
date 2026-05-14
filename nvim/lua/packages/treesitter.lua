require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    -- Highlight.
    pcall(vim.treesitter.start)

    -- Indentation.
    vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"

    -- Auto install.
    local ensureInstalled = {
      "lua",
      "python",
      "typescript",
      "html",
      "css",
      "json"
    }
    local alreadyInstalled = require("nvim-treesitter.config").get_installed()
    local parsersToInstall = vim.iter(ensureInstalled)
        :filter(function(parser)
          return not vim.tbl_contains(alreadyInstalled, parser)
        end)
        :totable()
    require("nvim-treesitter").install(parsersToInstall)
  end,
})
