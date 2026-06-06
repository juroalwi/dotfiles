local blink = require("blink.cmp")
local link = require("utils.highlights").link

blink.build():wait(60000)

blink.setup({
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = { enabled = true },
  keymap = {
    preset = "default",
    ["<CR>"] = { "accept", "fallback" },
    ["<TAB>"] = { "select_next", "fallback" },
    ["<S-TAB>"] = { "select_prev", "fallback" },
    ["<C-h>"] = { "hide" },
    ["<C-j>"] = { "snippet_forward" },
    ["<C-k>"] = { "snippet_backward" },
    ["<C-l>"] = { "show" },
    ["<C-f>"] = { "scroll_documentation_down" },
    ["<C-b>"] = { "scroll_documentation_up" },
  },
  appearance = {
    kind_icons = {
      Keyword = "",
      Value = "",
      Text = "",
      Constant = "󰏿",
      Unit = "󰬺",
      Event = "",
      Snippet = "",
      Color = "",
      Operator = "",
      TypeParameter = "",
      Interface = "",
      Struct = "󰙅",
      Enum = "",
      EnumMember = "",
      Class = "",
      Constructor = "",
      Property = "",
      Variable = "",
      Field = "",
      Function = "",
      Method = "",
      Module = "",
      Reference = "",
      File = "",
      Folder = "",
    },
  },
  completion = {
    ghost_text = { enabled = true },
    accept = { auto_brackets = { enabled = true } },
    list = {
      selection = {
        preselect = false,  -- When `true`, will automatically select the first item in the completion list.
        auto_insert = true, -- When `true`, inserts the completion item automatically when selecting it.
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      update_delay_ms = 50,
    },
    menu = {
      border = "rounded",
      auto_show = true,
      auto_show_delay_ms = 0,
      draw = {
        columns = { { "kind_icon", "label", "label_description", gap = 2 } },
        components = {
          source_name = {
            width = { max = 30 },
            text = function(ctx)
              return "[" .. string.lower(ctx.source_name) .. "]"
            end,
            highlight = "BlinkCmpSource",
          },
        },
      },
    },
  },
  cmdline = {
    enabled = true,
    keymap = {
      ["<CR>"] = { "accept_and_enter", "fallback" },
      ["<C-h>"] = { "hide" },
      ["<C-l>"] = { "show" },
    },
    completion = {
      menu = { auto_show = true },
      ghost_text = { enabled = true },
      list = {
        selection = {
          preselect = false,  -- When `true`, will automatically select the first item in the completion list.
          auto_insert = true, -- When `true`, inserts the completion item automatically when selecting it.
        },
      },
    },
  },
  term = {
    enabled = true,
    keymap = {
      ["<CR>"] = { "accept", "fallback" },
      ["<C-h>"] = { "hide" },
      ["<C-l>"] = { "show" },
    },
    completion = {
      menu = { auto_show = true },
      ghost_text = { enabled = true },
      list = {
        selection = {
          preselect = false,  -- When `true`, will automatically select the first item in the completion list.
          auto_insert = true, -- When `true`, inserts the completion item automatically when selecting it.
        },
      },
    },
  },
})

vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PoiBlinkCmpHighlights", { clear = true }),
  pattern = "PoiHighlightsReady",
  callback = function()
    link("BlinkCmpMenu", "Pmenu")
    link("BlinkCmpMenuBorder", "PmenuBorder")
  end,
})
