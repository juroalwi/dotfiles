return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME -- Add Neovim's methods for easier code writing.
        },
      },
      format = {
        enable = true,
        defaultConfig = {
          quote_style = "double",
        },
      },
    },
  },
}
