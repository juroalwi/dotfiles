local diff = require("mini.diff")
local map = require("utils.keymaps").map

diff.setup({
  view = {
    style = "sign",
    signs = { add = "┃", change = "┃", delete = "┃" },
    priority = 200,
  },
  delay = {
    text_change = 60,
  },
  mappings = {
    textobject = "gh",
    apply = "gh",
    reset = "gH",
    goto_first = "[H",
    goto_prev = "[h",
    goto_next = "]h",
    goto_last = "]H",
  },
  options = {
    algorithm = "patience",
  },
})

map("n", "<LEADER>o", function()
  diff.toggle_overlay()
end)
