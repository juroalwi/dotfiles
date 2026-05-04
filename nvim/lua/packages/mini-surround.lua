local map = require("utils.keymaps").map

require("mini.surround").setup({ n_lines = 100 })

map("n", "sn", ":lua MiniSurround.update_n_lines()<CR>")
