require("codecompanion").setup({
  interactions = {
    chat = {
      adapter = "copilot",
      model = "gpt-4.1",
      keymaps = {
        send = {
          modes = { n = "<C-s>", i = "<C-s>" },
          opts = {},
        },
        close = {
          modes = {
            n = "<C-q>",
            i = "<C-q>",
          },
        }
      },
    },
    inline = {
      adapter = "copilot",
    },
    background = {
      chat = {
        callbacks = {
          ["on_ready"] = {
            actions = {
              "interactions.background.builtin.chat_make_title",
            },
            enabled = true,
          },
        },
        opts = {
          enabled = true,
        },
      },
    },
  },
  display = {
    diff = {
      enabled = true,
      threshold_for_chat = 6,
      word_highlights = {
        additions = true,
        deletions = true,
      },
    },
  },
})

vim.keymap.set("n", "<LEADER>a", ":CodeCompanionActions<CR>")
vim.keymap.set("n", "<LEADER>c", ":CodeCompanionChat Toggle<CR>")
vim.keymap.set("v", "<LEADER>c", ":CodeCompanionChat<CR>")
