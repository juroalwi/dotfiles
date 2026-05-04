local mason = "/home/juroalwi/.local/share/nvim/mason/bin/"

local prettier = {
  formatStdin = true,
  formatCommand = mason .. "prettierd --stdin-filepath ${INPUT}",
}

local eslint = {
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintSource = "efm/eslint_d",
  lintCommand = mason .. "eslint_d --no-color --format stylish --stdin-filename '${INPUT}' --stdin ",
  lintFormats = {
    "%\\s%#%l:%c %# %trror  %m",
    "%\\s%#%l:%c %# %tarning  %m",
  },
  rootMarkers = {
    "package.json",
    ".eslintrc",
    ".eslintrc.cjs",
    ".eslintrc.js",
    ".eslintrc.json",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    "eslint.config.cjs",
    "eslint.config.mjs",
    "eslint.config.js",
  },
}

local jsonlint = {
  lintSource = "efm/jsonlint",
  lintCommand = mason .. "jsonlint --sort-keys --compact",
  lintStdin = true,
  lintFormats = { "line %l, col %c, %m" },
  rootMarkers = { ".jsonlintrc" },
}

local stylua = {
  formatStdin = true,
  formatCanRange = true,
  formatCommand = mason
      .. "stylua --color Never ${--range-start:charStart} ${--range-end:charEnd} --stdin-filepath '${INPUT}' -",
  rootMarkers = { "stylua.toml", ".stylua.toml" },
}

local selene = {
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintSource = "efm/selene",
  lintCommand = mason .. "selene --display-style quiet -",
  lintFormats = { "%f:%l:%c: %trror%m", "%f:%l:%c: %tarning%m", "%f:%l:%c: %tote%m" },
  rootMarkers = { "selene.toml" },
}

local languages = {
  javascript = { prettier, eslint },
  javascriptreact = { prettier, eslint },
  typescript = { prettier, eslint },
  typescriptreact = { prettier, eslint },
  css = { prettier },
  html = { prettier },
  json = { prettier, jsonlint },
  yaml = { prettier },
  markdown = { prettier },
  -- lua = { stylua, selene },
}

return {
  cmd = { "efm-langserver" },
  filetypes = vim.tbl_keys(languages),
  root_markers = { ".git/", "package.json" },
  settings = {
    rootMarkers = { ".git/", "package.json" },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
    hover = false,
    documentSymbol = false,
    codeAction = true,
    completion = false,
  },
}
