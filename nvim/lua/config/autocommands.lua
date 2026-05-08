-- When opening a new buffer, place cursor at the last position in which it was left.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("PoiBufferLastPosition", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos(".", vim.fn.getpos("'\""))
      vim.api.nvim_feedkeys("zz", "n", true)
    end
  end,
})

-- Highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("PoiHighlightYank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Update git branch global variable.
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = vim.api.nvim_create_augroup("PoiGitBranch", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.buftype ~= "" then -- Omit 'help', 'terminal', 'nofile', 'quickfix', etc.
      return
    end

    vim.system(
      { "git", "branch", "--show-current" },
      { text = true },
      function(obj)
        if obj.code == 0 then
          local branch = obj.stdout:gsub("%s+", "")
          vim.schedule(function()
            vim.b.git_branch = branch ~= "" and branch or nil
            vim.api.nvim_exec_autocmds("User", {
              pattern = "PoiGitBranchReady",
            })
          end)
        end
      end
    )
  end,
})
