local map = require("utils.keymaps").map

map({ "x", "i" }, "<C-c>", "<ESC>")              -- Make <C-c> behave as  <ESC>.
map("n", "<C-s>", ":w<CR>")                      -- Write file.
map("n", "<LEADER>n", ":noh<CR>")                -- Clear highlighted text from last search.
map("n", "<LEADER>m", ":messages<CR>")           -- Show messages list.

-- Open Neovim directories.
map("n", "<LEADER>vc", ":e " .. vim.fn.stdpath("config") .. "<CR>") -- Open root configuration file.
map("n", "<LEADER>vd", ":e " .. vim.fn.stdpath("data") .. "<CR>")   -- Open data directory.

-- Resize windows.
map("n", "<C-DOWN>", ":resize +2<CR>")
map("n", "<C-UP>", ":resize -2<CR>")
map("n", "<C-LEFT>", ":vertical resize -2<CR>")
map("n", "<C-RIGHT>", ":vertical resize +2<CR>")

-- Stay in indent mode when indenting.
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Avoid copying when pasting on top of selected text.
map("x", "p", function() return "pgv\"" .. vim.v.register .. "y`>" end, { expr = true })
map("x", "P", function() return "Pgv\"" .. vim.v.register .. "y`>" end, { expr = true })
