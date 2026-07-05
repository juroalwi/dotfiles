vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  float = {
    header = "",
    suffix = "",
    scope = "line",
    source = true,
    severity_sort = true,
  },
  virtual_text = {
    prefix = "■",
    spacing = 0,
    source = false,
  },
  signs = {
    priority = 100, -- Lower than mini.diff git hunk signs priority.
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "PoiError",
      [vim.diagnostic.severity.WARN] = "PoiWarn",
      [vim.diagnostic.severity.INFO] = "PoiInfo",
      [vim.diagnostic.severity.HINT] = "PoiHint",
    },
  },
  jump = {
    on_jump = function()
      vim.diagnostic.open_float()
    end,
  },
})
