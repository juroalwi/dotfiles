local map = require("utils.keymaps").map

map("n", "<LEADER>g", function()
  vim.cmd(":Git")
end)

map("n", "<LEADER>b", function()
  vim.cmd(":Git blame")
end)
