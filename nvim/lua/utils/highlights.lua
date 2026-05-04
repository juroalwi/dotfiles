local M = {}

M.get = function(src)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = src })
  if not ok then
    vim.notify("Highlight group not found: " .. src, vim.log.levels.WARN)
    return {}
  end
  return hl
end

M.link = function(from, to)
  vim.api.nvim_set_hl(0, from, {
    link = to,
  })
end

M.copy = function(from, to, opts)
  local fg, bg = nil, nil
  if type(to) == "table" then
    fg = to.fg and M.get(to.fg[1])[to.fg[2]] or nil
    bg = to.bg and M.get(to.bg[1])[to.bg[2]] or nil
  else
    local hl = M.get(to)
    fg = hl.fg
    bg = hl.bg
  end
  opts = opts or {}
  vim.api.nvim_set_hl(0, from, {
    fg = fg,
    bg = bg,
    bold = opts.bold or false,
    italic = opts.italic or false,
    underline = opts.underline or false,
    underdouble = opts.underdouble or false,
    underdotted = opts.underdotted or false,
    underdashed = opts.underdashed or false,
  })
end

return M
