local nvlsp = require "nvchad.configs.lspconfig"

local base_config = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "jdtls",
  "pyright",
  "clangd",
  "solidity_ls",
  "sourcekit",
}

local function configure(server, extra)
  vim.lsp.config(server, vim.tbl_deep_extend("force", base_config, extra or {}))
  vim.lsp.enable(server)
end

for _, server in ipairs(servers) do
  configure(server)
end

configure("rust_analyzer", {
  cmd = { "/opt/homebrew/bin/rust-analyzer" },
})

configure("eslint", {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  root_markers = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "package.json",
  },
  settings = {
    workingDirectories = { mode = "auto" },
    validate = "on",
    packageManager = "npm",
    useESLintClass = true,
    codeActionOnSave = {
      enable = false,
      mode = "all",
    },
    format = false,
    quiet = false,
    onIgnoredFiles = "off",
    rulesCustomizations = {},
    run = "onType",
    problems = {
      shortenToSingleLine = false,
    },
    nodePath = "",
  },
})

