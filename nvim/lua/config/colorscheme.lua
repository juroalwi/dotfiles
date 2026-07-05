local copy = require("utils.highlights").copy

local update_highlights = function()
  -- Custom color groups.
  copy("PoiMute", "Conceal")
  copy("PoiAccent", "Special")
  copy("PoiError", "DiagnosticError")
  copy("PoiWarn", "DiagnosticWarn")
  copy("PoiInfo", "DiagnosticInfo")
  copy("PoiHint", "DiagnosticHint")

  vim.api.nvim_exec_autocmds("User", {
    pattern = "PoiHighlightsReady",
  })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("PoiColorscheme", { clear = true }),
  pattern = "*",
  callback = update_highlights,
})

vim.cmd("colorscheme catppuccin")
