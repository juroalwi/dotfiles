local map = require("utils.keymaps").map

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("PoiLspSetup", { clear = true }),
  pattern = "*",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    -- Code formatting.
    if client.server_capabilities.documentFormattingProvider then
      map({ "n", "x" }, "gq", function()
        vim.lsp.buf.format({ async = true })
        return "<ESC>"
      end, { buffer = args.buf, expr = true, unique = false })

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format({ async = false })
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
      local group = vim.api.nvim_create_augroup("PoiLspHighlight", { clear = true })
      vim.api.nvim_create_autocmd("CursorHold", {
        group = group,
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
