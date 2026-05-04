local M = {}

M.map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { silent = true, remap = false, unique = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.unmap = function(mode, lhs, opts)
  vim.keymap.del(mode, lhs, opts)
end

return M
