local pick = require("mini.pick")
local link = require("utils.highlights").link
local map = require("utils.keymaps").map

pick.setup({
  mappings = {
    paste            = "",
    choose           = "",
    refine           = "",
    choose_marked    = "",
    refine_marked    = "",
    choose_smart     = {
      char = "<CR>",
      func = function()
        local matches = pick.get_picker_matches()
        local opts = pick.get_picker_opts()
        if matches.marked and #matches.marked > 0 then
          (opts.source.choose_marked or pick.default_choose_marked)(matches.marked)
        elseif matches.current then
          (opts.source.choose or pick.default_choose)(matches.current)
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
        vim.api.nvim_feedkeys(vim.keycode("<TAB>"), "n", false)
      end,
    },
    custom_move_up   = {
      char = "<C-p>",
      func = function()
        vim.api.nvim_feedkeys(vim.keycode("<S-TAB>"), "n", false)
      end,
    },

    move_down        = "<TAB>",
    move_up          = "<S-TAB>",
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
    config = function()
      return { width = vim.o.columns }
    end,
    prompt_prefix = "❯ ",
  },
})

pick.registry.files_hidden = function()
  local command = {
    "rg",
    "--files",
    "--hidden",
    "--no-ignore",
    "--glob", "!**/.git/*",
    "--glob", "!**/node_modules/*",
    "--glob", "!**/dist/*",
    "--glob", "!**/build/*",
    "--glob", "!**/coverage/*",
    "--glob", "!**/.jest-cache/*",
    "--glob", "!**/.next/*",
    "--glob", "!**/.cache/*",
  }
  return pick.builtin.cli({ command = command })
end

map("n", "<LEADER>p", function()
  vim.cmd("Pick files")
end, { noremap = true, silent = true, unique = true })

map("n", "<LEADER>h", function()
  vim.cmd("Pick files_hidden")
end, { noremap = true, silent = true, unique = true })

map("n", "<LEADER>f", function()
  vim.cmd("Pick grep_live")
end, { noremap = true, silent = true, unique = true })

local function is_test_file(path)
  return path:match("%.test%.") ~= nil
      or path:match("%.spec%.") ~= nil
      or path:match("/__tests__/") ~= nil
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PoiMiniPick", { clear = true }),
  pattern = "MiniPickMatch",
  callback = function()
    local matches = pick.get_picker_matches()

    if not matches or not matches.all_inds then return end

    local result = {}
    local tests = {}
    local non_tests = {}

    for i, idx in ipairs(matches.all_inds) do
      local item = matches.all[i]
      local path = type(item) == "string" and item or tostring(item)
      if is_test_file(path) then
        tests[#tests + 1] = idx
      else
        non_tests[#non_tests + 1] = idx
      end
    end

    if #tests == 0 then return end

    for _, v in ipairs(non_tests) do result[#result + 1] = v end
    for _, v in ipairs(tests) do result[#result + 1] = v end

    pick.set_picker_match_inds(result)
  end,
})

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
