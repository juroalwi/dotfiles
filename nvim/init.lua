vim.g.mapleader = " "

require("vim._core.ui2").enable({})

require("packages")
require("ui.bufferline")
require("ui.statusline")
require("config.options")
require("config.keymaps")
require("config.autocommands")
require("config.diagnostics")
require("config.lsp")
require("config.colorscheme")
