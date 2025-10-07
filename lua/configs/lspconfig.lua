-- Load NvChad LSP config utilities
local nvlsp = require "nvchad.configs.lspconfig"

-- Configure individual LSP servers
local servers = {
  "html",
  "cssls",
  "ts_ls",    -- TypeScript
  "jdtls",        -- Java Language Server
  "pyright",      -- Python
  "clangd",       -- C/C++
  "solidity_ls",  -- Solidity
  "sourcekit"     -- Swift
}

-- Configure standard servers
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
end

-- Configure rust analyzer with custom path
vim.lsp.config("rust_analyzer", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "/opt/homebrew/bin/rust-analyzer" },
})

-- Configure ESLint with specific settings
vim.lsp.config("eslint", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "vscode-eslint-language-server", "--stdio" },
  root_dir = require("lspconfig.util").root_pattern(
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
})

