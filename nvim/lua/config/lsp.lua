local map = require("utils.keymaps").map
local methods = vim.lsp.protocol.Methods
local lsp_group = vim.api.nvim_create_augroup("PoiLspSetup", { clear = true })
local format_group = vim.api.nvim_create_augroup("PoiLspFormat", { clear = true })
local highlight_group = vim.api.nvim_create_augroup("PoiLspHighlight", { clear = true })

map("n", "<LEADER>ll", function()
  vim.cmd.tabnew(vim.lsp.log.get_filename())
end)

map("n", "<LEADER>lh", function()
  vim.cmd("checkhealth vim.lsp")
end)

map("n", "<LEADER>lr", function()
  vim.cmd("lsp restart")
end)

local format_on_save_enabled = false
map("n", "<LEADER>lt", function()
  format_on_save_enabled = not format_on_save_enabled
  vim.notify("Format on save " .. (format_on_save_enabled and "enabled" or "disabled"))
end)

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  pattern = "*",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    local lsp_map = function(mode, lhs, rhs)
      return map(mode, lhs, rhs, { buffer = args.buf, unique = false, nowait = true })
    end

    local with_mini_pick = function(cmd, fallback)
      return function()
        local ok, mini_extra = pcall(require, "mini.extra")
        if false then
          mini_extra.pickers.lsp({ scope = cmd })
        else
          fallback()
        end
      end
    end

    if client:supports_method(methods.textDocument_definition) then
      lsp_map("n", "gd", with_mini_pick("definition", vim.lsp.buf.definition))
    end

    if client:supports_method(methods.textDocument_typeDefinition) then
      lsp_map("n", "gt", with_mini_pick("type_definition", vim.lsp.buf.type_definition))
    end

    if client:supports_method(methods.textDocument_implementation) then
      lsp_map("n", "gi", with_mini_pick("implementation", vim.lsp.buf.implementation))
    end

    if client:supports_method(methods.textDocument_references) then
      lsp_map("n", "gr", with_mini_pick("document_symbol", vim.lsp.buf.references))
    end

    if client:supports_method(methods.textDocument_codeAction) then
      lsp_map("n", "ga", vim.lsp.buf.code_action)
    end

    if client:supports_method(methods.textDocument_rename) then
      lsp_map("n", "<LEADER>ln", vim.lsp.buf.rename)
    end

    if client:supports_method(methods.textDocument_formatting) then
      lsp_map("n", "<LEADER>lf", vim.lsp.buf.format)
      lsp_map("x", "<LEADER>lf", function()
        vim.lsp.buf.format()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", true)
      end)
    end

    -- Format on save.
    if client:supports_method(methods.textDocument_formatting) then
      vim.api.nvim_clear_autocmds({
        group = format_group,
        buffer = args.buf,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = args.buf,
        callback = function()
          if not format_on_save_enabled then
            return
          end
          vim.lsp.buf.format({
            bufnr = args.buf,
            async = false,
          })
        end,
      })
    end

    -- References highlighting.
    if client:supports_method(methods.textDocument_documentHighlight) then
      vim.api.nvim_clear_autocmds({
        group = highlight_group,
        buffer = args.buf,
      })
      vim.api.nvim_create_autocmd("CursorHold", {
        group = highlight_group,
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = highlight_group,
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
