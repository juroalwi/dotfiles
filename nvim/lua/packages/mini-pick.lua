local pick = require("mini.pick")
local link = require("utils.highlights").link
local map = require("utils.keymaps").map

pick.setup({
  mappings = {
    choose_smart     = {
      char = "<CR>",
      func = function()
        local matches = pick.get_picker_matches()
        local opts = pick.get_picker_opts()
        if matches.marked and #matches.marked > 0 then
          local choose_marked = opts.source.choose_marked or pick.default_choose_marked
          choose_marked(matches.marked)
        elseif matches.current then
          local choose = opts.source.choose or pick.default_choose
          choose(matches.current)
        end
        return true
      end,
    },
    paste_clipboard  = {
      char = "<C-r>",
      func = function()
        local clipboard = vim.fn.getreg("+")
        local query = pick.get_picker_query()
        table.insert(query, clipboard)
        pick.set_picker_query(query)
      end,
    },
    custom_move_down = {
      char = "<C-n>",
      func = function()
        vim.api.nvim_feedkeys(vim.keycode('<TAB>', true, true, true), 'n', false)
      end,
    },
    custom_move_up   = {
      char = "<C-p>",
      func = function()
        vim.api.nvim_feedkeys(vim.keycode('<S-TAB>', true, true, true), 'n', false)
      end,
    },

    paste            = "",

    move_down        = "<TAB>",
    move_up          = "<S-TAB>",

    choose           = "<C-y>",
    choose_marked    = "<M-y>",
    refine           = "<C-f>",
    refine_marked    = "<M-f>",

    stop             = "<C-q>",
    mark             = "<C-x>",
    mark_all         = "<C-a>",
    move_start       = "<C-g>",
    toggle_info      = "<C-z>",
    toggle_preview   = "<C-e>",
    delete_word      = "<C-w>",
    delete_left      = "<C-u>",

    scroll_left      = "<C-h>",
    scroll_down      = "<C-j>",
    scroll_up        = "<C-k>",
    scroll_right     = "<C-l>",
  },
  window = {
    prompt_prefix = " ",
  },
})

pick.registry.files_hidden = function()
  local command = { "rg", "--files", "--hidden", "--glob", "!.git" }
  return pick.builtin.cli({ command = command })
end

map("n", "<LEADER>f", function()
  vim.cmd("Pick files_hidden")
end, { noremap = true, silent = true, unique = true })

map("n", "<LEADER>s", function()
  vim.cmd("Pick grep_live")
end, { noremap = true, silent = true, unique = true })

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PoiMiniPickHighlights", { clear = true }),
  pattern = "PoiHighlightsReady",
  callback = function()
    link("MiniPickPrompt", "MiniPickNormal")
    link("MiniPickPromptPrefix", "MiniPickNormal")
    link("MiniPickPromptCaret", "MiniPickNormal")
    link("MiniPickBorderText", "MiniPickNormal")
  end,
})
