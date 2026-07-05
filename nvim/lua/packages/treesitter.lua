require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    -- Highlight.
    pcall(vim.treesitter.start)

    -- Auto install.
    local ensureInstalled = {
      "lua",
      "python",
      "typescript",
      "javascript",
      "tsx",
      "jsx",
      "html",
      "css",
      "json"
    }
    local alreadyInstalled = require("nvim-treesitter.config").get_installed()
    local parsersToInstall = vim.iter(ensureInstalled)
        :filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
        :totable()
    require("nvim-treesitter").install(parsersToInstall)
  end,
})
