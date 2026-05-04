local MiniIcons = require("mini.icons")
local link = require("utils.highlights").link
local copy = require("utils.highlights").copy
local icons = require("utils.icons")

local M = {}

M.get_git_status = function()
  local t = {}
  local diff = vim.b.minidiff_summary or {}
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")

  if branch and branch ~= "" then
    table.insert(t, ("%s %s"):format(icons.git.BRANCH, branch))
  end

  if diff.add and diff.add > 0 then
    table.insert(t, ("%s %s"):format(icons.git.ADD, diff.add))
  end

  if diff.change and diff.change > 0 then
    table.insert(t, ("%s %s"):format(icons.git.CHANGE, diff.change))
  end

  if diff.delete and diff.delete > 0 then
    table.insert(t, ("%s %s"):format(icons.git.DELETE, diff.delete))
  end

  local val = table.concat(t, " ")
  if #val > 0 then
    val = " " .. val .. " "
  end

  return ("%%#PoiStatuslineGitStatus#%s%%#PoiStatusline#"):format(val), vim.fn.strdisplaywidth(val)
end

M.get_diagnostics = function()
  local t = {}
  local s = vim.diagnostic.severity
  local diag = vim.diagnostic.count(0) or {}

  if diag[s.ERROR] and diag[s.ERROR] > 0 then
    table.insert(t, ("%%#PoiStatuslineDiagnosticsError# %s %s"):format(icons.diagnostics.ERROR, diag[s.ERROR]))
  end

  if diag[s.WARN] and diag[s.WARN] > 0 then
    table.insert(t, ("%%#PoiStatuslineDiagnosticsWarn# %s %s"):format(icons.diagnostics.WARN, diag[s.WARN]))
  end

  if diag[s.INFO] and diag[s.INFO] > 0 then
    table.insert(t, ("%%#PoiStatuslineDiagnosticsInfo# %s %s"):format(icons.diagnostics.INFO, diag[s.INFO]))
  end

  if diag[s.HINT] and diag[s.HINT] > 0 then
    table.insert(t, ("%%#PoiStatuslineDiagnosticsHint# %s %s"):format(icons.diagnostics.HINT, diag[s.HINT]))
  end

  local val = table.concat(t, " ")
  if #val > 0 then
    val = " " .. val .. " "
  end

  return ("%%#PoiStatuslineDiagnostics#%s%%#PoiStatusline#"):format(val), vim.fn.strdisplaywidth(val)
end

M.get_path = function(max_characters)
  if vim.bo.buftype ~= "" then -- Exclude non-file buffers.
    return ""
  end
  local path = vim.fn.expand("%:~")
  if max_characters < 10 or path == "" then
    return ""
  end
  local path_max_characters = max_characters - 4 -- -2 for icon and space, -2 for padding.
  local icon_val, icon_hl = MiniIcons.get("file", path)
  if vim.fn.strdisplaywidth(path) > path_max_characters then
    path = "…" .. path:sub(-path_max_characters + 1) -- +1 for the "…" character.
  end
  return (" %%#%s#%s%%#PoiStatuslinePath# %s %%#PoiStatusline#"):format(icon_hl, icon_val, path)
end

M.get_position = function(short)
  local val = ""
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2] + 1 -- Column starts at 0.
  local total_rows = vim.api.nvim_buf_line_count(0)
  local progress_pct = math.floor((row / math.max(total_rows, 1)) * 100)
  if short then
    val = ("%s/%s %s "):format(row, total_rows, col)
  else
    val = ("%s/%s · %s%%%% · %s "):format(row, total_rows, progress_pct, col)
  end
  return "%#PoiStatuslinePosition#" .. val, vim.fn.strdisplaywidth(val)
end

PoiStatusline = {
  set_colors = function()
    link("StatusLine", "Normal")
    link("StatusLineNc", "Normal")
    link("PoiStatusline", "Normal")
    copy("PoiStatuslineGitStatus", "PoiAccent")
    copy("PoiStatuslineDiagnostics", "PoiAccent")
    copy("PoiStatuslineDiagnosticsError", "PoiError")
    copy("PoiStatuslineDiagnosticsWarn", "PoiWarn")
    copy("PoiStatuslineDiagnosticsInfo", "PoiInfo")
    copy("PoiStatuslineDiagnosticsHint", "PoiHint")
    copy("PoiStatuslinePath", "PoiMute")
    copy("PoiStatuslinePosition", "Normal")
  end,
  build = function()
    local current_width = vim.o.columns
    local short = current_width <= 80
    local git_status_val, git_status_len = M.get_git_status()
    local diag_val, diag_len = M.get_diagnostics()
    local pos_val, pos_len = M.get_position(short)
    local path_val = M.get_path(current_width - diag_len - pos_len - git_status_len)

    return ("%s%s%%=%s%%=%s"):format(git_status_val, diag_val, path_val, pos_val)
  end,
}

-- Show vim mode on command line.
vim.o.showmode = true

-- Show one single statusline.
vim.o.laststatus = 3

-- Set statusline string dinamically (%! char at the beginning).
vim.o.statusline = "%!v:lua.PoiStatusline.build()"

-- Update statusline colors on each colorscheme change.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PoiStatusline", { clear = true }),
  pattern = "PoiHighlightsReady",
  callback = PoiStatusline.set_colors,
})
