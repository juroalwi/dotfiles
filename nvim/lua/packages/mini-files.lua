local files = require("mini.files")
local link = require("utils.highlights").link
local map = require("utils.keymaps").map
local unmap = require("utils.keymaps").unmap

files.setup({
  options = {
    permanent_delete = false,
  },
  mappings = {
    close       = "<C-q>",
    synchronize = "<C-s>",
    reset       = "<SPACE>",
    go_in       = "<CR>",
    go_in_plus  = "<M-CR>",
    go_out      = "<BS>",
    go_out_plus = "<M-BS>",
    mark_goto   = "'",
    mark_set    = "m",
    reveal_cwd  = "gr",
    show_help   = "g?",
    trim_left   = "<",
    trim_right  = ">",
  }
})

local custom_go_in_plus = function() -- Behaves exactly the same as default, but executes trim_left on directories.
  local type = (files.get_fs_entry() or {}).fs_type
  if type == nil then
    return vim.notify("Cursor is not on valid entry")
  end
  if type == "file" then
    files.go_in()
    files.close()
  elseif type == "directory" then
    files.go_in()
    files.trim_left()
  end
end

local custom_reveal_cwd = function()
  local cwd_path = vim.fn.getcwd()
  files.open(cwd_path, false)
end

local update_cwd = function()
  local path = (files.get_fs_entry() or {}).path
  if path == nil then
    return vim.notify("Cursor is not on valid entry")
  end
  local dir = vim.fs.dirname(path)
  vim.fn.chdir(dir)
  vim.notify("Working directory updated to: " .. dir)
end

local open_ui = function()
  local path = (files.get_fs_entry() or {}).path
  if path == nil then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.ui.open(vim.fs.dirname(path))
end

local copy_path = function()
  local path = (files.get_fs_entry() or {}).path
  if path == nil then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg("+", path)
  vim.notify("Copied path: " .. path)
end

local show_dotfiles = true
local filter_show = function() return true end
local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end
local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  files.refresh({ content = { filter = show_dotfiles and filter_show or filter_hide } })
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PoiMiniFilesKeymaps", { clear = true }),
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    unmap("n", "<M-CR>", { buffer = buf_id })
    unmap("n", "gr", { buffer = buf_id })
    map("n", "<M-CR>", custom_go_in_plus, { buffer = buf_id })
    map("n", "gr", custom_reveal_cwd, { buffer = buf_id, nowait = true })
    map("n", "gu", update_cwd, { buffer = buf_id })
    map("n", "go", open_ui, { buffer = buf_id })
    map("n", "gp", copy_path, { buffer = buf_id })
    map("n", "g.", toggle_dotfiles, { buffer = buf_id })
  end,
})

map("n", "<LEADER>e", function()
  files.open(vim.api.nvim_buf_get_name(0), false)
end, { silent = true, noremap = true })

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PoiMiniFilesHighlights", { clear = true }),
  pattern = "PoiHighlightsReady",
  callback = function()
    link("MiniFilesTitle", "MiniFilesNormal")
    link("MiniFilesTitleFocused", "MiniFilesNormal")
  end,
})
