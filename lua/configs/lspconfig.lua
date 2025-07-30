-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "ts_ls",    -- TypeScript
  "eslint",       -- JavaScript linting
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
