-- Get default LSP capabilities
local default_capabilities = vim.lsp.protocol.make_client_capabilities()

-- Merge with blink.cmp capabilities
local capabilities = require('blink.cmp').get_lsp_capabilities(default_capabilities)

-- Language Server Protocol (LSP)
require 'servers.bacon_ls'(capabilities)
require 'servers.basedpyright'(capabilities)
require 'servers.bashls'(capabilities)
require 'servers.clangd'(capabilities)
require 'servers.lua_ls'(capabilities)
require 'servers.ruff'(capabilities)
require 'servers.tailwindcss'(capabilities)
require 'servers.ts_ls'(capabilities)

-- Enable lsp servers
vim.lsp.enable {
  'bacon_ls',
  'basedpyright',
  'bashls',
  'clangd',
  'lua_ls',
  'ruff',
  'tailwindcss',
  'ts_ls',
}
