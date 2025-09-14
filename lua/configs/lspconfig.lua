-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "ts_ls",    -- TypeScript
  -- "eslint",   -- ESLint (configured separately below)
  "jdtls",        -- Java Language Server
  "pyright",      -- Python
  "clangd",       -- C/C++
  -- "rust_analyzer",-- Rust (removed from auto-setup)
  "solidity_ls",  -- Solidity
  "sourcekit"     -- Swift
}
local nvlsp = require "nvchad.configs.lspconfig"
-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Manually configure rust-analyzer with custom path
lspconfig.rust_analyzer.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "/opt/homebrew/bin/rust-analyzer" }, -- or wherever it's installed
}

-- Configure ESLint with specific flags
lspconfig.eslint.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "vscode-eslint-language-server", "--stdio" },
  root_dir = lspconfig.util.root_pattern(
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    'eslint.config.ts',
    'package.json'
  ),
  settings = {
    workingDirectories = { mode = "auto" },
    validate = "on",
    packageManager = "npm",
    useESLintClass = true,
    codeActionOnSave = {
      enable = false,
      mode = "all"
    },
    format = false,
    quiet = false,
    onIgnoredFiles = "off",
    rulesCustomizations = {},
    run = "onType",
    problems = {
      shortenToSingleLine = false
    },
    nodePath = "",
  },
}

