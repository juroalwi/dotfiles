local map = require("utils.keymaps").map

local lsp_group = vim.api.nvim_create_augroup("PoiLspSetup", { clear = true })
local format_group = vim.api.nvim_create_augroup("PoiFormat", { clear = true })
local highlight_group = vim.api.nvim_create_augroup("PoiLspHighlight", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  pattern = "*",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    -- Code formatting.
    if client.server_capabilities.documentFormattingProvider then
      map({ "n", "x" }, "gq", function()
        vim.lsp.buf.format({
          bufnr = args.buf,
          async = false,
        })
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<ESC>", true, false, true),
          "n",
          true
        )
      end, { buffer = args.buf, unique = false })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({
            bufnr = args.buf,
            async = false,
          })
        end,
      })
    end

    -- Go to definition.
    if client.server_capabilities.definitionProvider then
      map("n", "gd", function()
        vim.lsp.buf.definition()
      end, { buffer = args.buf, unique = false })
    end

    -- References highlighting.
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd("CursorHold", {
        group = highlight_group,
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = highlight_group,
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
