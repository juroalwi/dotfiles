vim.o.title = false   -- When true, show file title on top of the terminal.
vim.o.mouse = "a"     -- When "a", Enable mouse support.
vim.o.timeout = false -- When true, abort command keystrokes reading after certain amount of time without typing.

-- Text editting.
vim.o.wrap = false              -- When true, break long lines and display them as if they were multiple lines (they keep being one single line).
vim.o.clipboard = "unnamedplus" -- When "unnamedplus", allow neovim to access the system clipboard.

-- Indentation.
vim.o.smartindent = true -- When true, auto indentation after '{', before '}' or after any cinword.
vim.o.autoindent = true   -- When true, copy indent from current line when starting a new line.
vim.o.expandtab = true    -- When true, replace \t characters with spaces.
vim.o.tabstop = 2         -- How many columns wide is a \t character worth.
vim.o.shiftwidth = 2      -- How many columns wide is an indent level worth.

-- Search.
vim.o.hlsearch = true   -- When true, highlight searched word.
vim.o.ignorecase = true -- When true, ignore upper cases in search patterns.
vim.o.smartcase = true  -- When true, don't ignore upper cases if pattern contains at least one upper case.

-- Splits.
vim.o.splitbelow = true -- When true, force all horizontal splits to go below current window.
vim.o.splitright = true -- When true, force all vertical splits to go to the right of current window.

-- Cursor.
vim.o.cursorline = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.updatetime = 400 -- Delay before triggering CursorHold event (default is 4000).

-- Scroll.
vim.o.scrolloff = 8      -- Minimum number of screen lines to keep above and below the cursor when scrolling vertically.
vim.o.sidescrolloff = 16 -- Minimum number of screen columns to keep to the left and right of the cursor when scrolling horizontally.

-- UI.
vim.o.winborder = "solid"
vim.o.pumborder = "solid"
vim.o.signcolumn = "yes"          -- When 'number', merge sign column into number column.
vim.opt.fillchars = { eob = " " } -- Character displayed at the end of buffer.
