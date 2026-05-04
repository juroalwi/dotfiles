local map = require("utils.keymaps").map

map({ "x", "i" }, "<C-c>", "<ESC>")   -- Make <C-c> behave as  <ESC>.
map("n", "<C-s>", ":w<CR>")           -- Write file.
map("n", "<C-q>", ":bd<CR>")          -- Quit buffer.
map("n", "<C-n>", ":let @/ = ''<CR>") -- Clear highlighted text from last search.

-- Neovim files.
map("n", "<LEADER>vc", ":e " .. vim.fn.stdpath("config") .. "<CR>") -- Open root configuration file.
map("n", "<LEADER>vd", ":e " .. vim.fn.stdpath("data") .. "<CR>")   -- Open data directory.

-- Navigate bewtween buffers.
map({ "n", "v" }, "<TAB>", ":bnext<CR>", { unique = false })
map({ "n", "v" }, "<S-TAB>", ":bprev<CR>", { unique = false })

-- Resize windows.
map("n", "<C-DOWN>", ":resize +2<CR>")
map("n", "<C-UP>", ":resize -2<CR>")
map("n", "<C-LEFT>", ":vertical resize -2<CR>")
map("n", "<C-RIGHT>", ":vertical resize +2<CR>")

-- Open new line but stay in normal mode.
map("n", "ñ", "o<ESC>")
map("n", "Ñ", "O<ESC>")

-- Sessions.
map("n", "<LEADER>ws", ":mks! ~/.local/state/nvim/sessions/", { silent = false })
map("n", "<LEADER>wl", ":so ~/.local/state/nvim/sessions/", { silent = false })
map("n", "<LEADER>wd", ":!rm ~/.local/state/nvim/sessions/*<cr>", { silent = false })

-- Stay in indent mode when indenting.
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Avoid copying when pasting on top of selected text.
map("x", "p", function()
  return "pgv\"" .. vim.v.register .. "y`>"
end, { expr = true })
map("x", "P", function()
  return "Pgv\"" .. vim.v.register .. "y`>"
end, { expr = true })

-- Popup menu navigation.
map("i", "<TAB>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<TAB>"
end, { expr = true, unique = false })
map("i", "<S-TAB>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-TAB>"
end, { expr = true, unique = false })
map("i", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or require("nvim-autopairs").autopairs_cr()
end, { expr = true, unique = false })
