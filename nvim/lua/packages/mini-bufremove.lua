local bufremove = require("mini.bufremove")
local map = require("utils.keymaps").map

local disabled = { "fugitive", "fugitiveblame", "qf" }

local includes = function(t, e)
  for _, v in ipairs(t) do
    if v == e then
      return true
    end
  end
  return false
end

map("n", "<C-q>", function()
  if includes(disabled, vim.bo.filetype) then
    vim.cmd("bd")
  else
    bufremove.delete(0)
  end
end)
