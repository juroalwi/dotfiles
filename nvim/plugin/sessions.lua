local map = require("utils.keymaps").map
local state_dir = vim.fn.stdpath("state")
local restore_session_file = state_dir .. "/restart-session.vim"

-- Manage sessions.
map("n", "<LEADER>ws", ":mks! " .. state_dir .. "/sessions/", { silent = false })
map("n", "<LEADER>wl", ":so " .. state_dir .. "/sessions/", { silent = false })
map("n", "<LEADER>wd", ":!rm " .. state_dir .. "/sessions/", { silent = false })

-- Restart and reopen session.
map("n", "<LEADER>r", function()
  vim.cmd("mks! " .. restore_session_file)
  vim.cmd("restart")
end)
vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  group = vim.api.nvim_create_augroup("PoiRestartSession", { clear = true }),
  callback = function()
    if vim.fn.filereadable(restore_session_file) == 1 then
      vim.cmd("silent! source " .. restore_session_file)
      vim.fn.delete(restore_session_file)
    end
  end,
})

