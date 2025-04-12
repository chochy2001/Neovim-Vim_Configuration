-- Configuración de Mason
require("mason").setup()

-- Configuración de Mason LSPConfig
require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "html",
    "cssls",
    "bashls",
    "jsonls",
    "yamlls",
    "lua_ls",
    "marksman",
    "clangd",
    "rust_analyzer",
    "texlab",
  },
  automatic_installation = true,
})

-- Carga segura de lspconfig
local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("No se pudo cargar lspconfig", vim.log.levels.ERROR)
  return
end

-- Configuración por servidor
local servers = {
  pyright = {},
  html = {},
  cssls = {},
  bashls = {},
  jsonls = {},
  yamlls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
  marksman = {},
  clangd = {},
  rust_analyzer = {},
  texlab = {},
}

for server, config in pairs(servers) do
  local has_server = lspconfig[server]
  if has_server and type(has_server.setup) == "function" then
    has_server.setup(config)
  else
    vim.notify("No se pudo cargar el LSP: " .. server, vim.log.levels.WARN)
  end
end

