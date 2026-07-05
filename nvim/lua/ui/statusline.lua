local link = require("utils.highlights").link
local copy = require("utils.highlights").copy
local icons = require("utils.icons")

local M = {}

M.truncate_amount = function(amount)
  if amount > 99 then
    return ">99"
  end
  return tostring(amount)
end

M.get_git_status = function()
  local t = {}
  local diff = vim.b.minidiff_summary or {}
  local branch = vim.b.git_branch

  if diff.add and diff.add > 0 then
    table.insert(t, string.format("%s %s", icons.git.ADD, M.truncate_amount(diff.add)))
  end

  if diff.change and diff.change > 0 then
    table.insert(t, string.format("%s %s", icons.git.CHANGE, M.truncate_amount(diff.change)))
  end

  if diff.delete and diff.delete > 0 then
    table.insert(t, string.format("%s %s", icons.git.DELETE, M.truncate_amount(diff.delete)))
  end

  if branch and branch ~= "" then
    table.insert(t, string.format("%s %s", icons.git.BRANCH, branch))
  end

  return string.format("%%#PoiStatuslineGitStatus#%s%%#PoiStatusline#", table.concat(t, "  "))
end

M.get_diagnostics = function()
  local t = {}
  local severities = vim.diagnostic.severity
  local counts = vim.diagnostic.count(0) or {}

  for _, severity in ipairs(severities) do
    local index = severities[severity]
    local count = counts[index]
    if count and count > 0 then
      local hl_label = string.gsub(string.lower(severity), "^.", string.upper)
      local truncated_count = M.truncate_amount(count)
      local item = string.format("%%#PoiStatuslineDiagnostics%s#%s %s", hl_label, icons.diagnostics[severity], truncated_count)
      table.insert(t, item)
    end
  end

  return string.format("%s%%#PoiStatusline#", table.concat(t, "  "))
end

PoiStatusline = {
  set_colors = function()
    link("StatusLine", "Normal")
    link("StatusLineNc", "Normal")
    link("PoiStatusline", "Normal")
    copy("PoiStatuslineGitStatus", "PoiAccent")
    copy("PoiStatuslineDiagnosticsError", "PoiError")
    copy("PoiStatuslineDiagnosticsWarn", "PoiWarn")
    copy("PoiStatuslineDiagnosticsInfo", "PoiInfo")
    copy("PoiStatuslineDiagnosticsHint", "PoiHint")
  end,
  build = function()
    local diagnostics = M.get_diagnostics()
    local git_status = M.get_git_status()
    return string.format(" %s %%= %s%%< ", diagnostics, git_status)
  end}

-- Show vim mode on command line.
vim.o.showmode = true

-- Show one single statusline.
vim.o.laststatus = 3

-- Set statusline string dinamically (%! char at the beginning).
vim.o.statusline = "%!v:lua.PoiStatusline.build()"

-- Update statusline colors on each colorscheme change.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PoiStatuslineHighlights", { clear = true }),
  pattern = "PoiHighlightsReady",
  callback = PoiStatusline.set_colors,
})

-- Update statusline on each git branch change.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PoiStatuslineGitBranch", { clear = true }),
  pattern = "PoiGitBranchReady",
  callback = function()
    vim.cmd("redrawstatus")
  end
})
