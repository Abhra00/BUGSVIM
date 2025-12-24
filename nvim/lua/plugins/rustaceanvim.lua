-- ================================================================================================
-- TITLE : rustaceanvim
-- ABOUT : A heavily modified fork of rust-tools.nvim
-- LINKS :
--   > github : https://github.com/mrcjkb/rustaceanvim
-- ================================================================================================

local on_attach = require('utils.lsp').on_attach

local get_codelldb_adapter = function()
  local mason_registry = require 'mason-registry'
  if mason_registry.is_installed 'codelldb' then
    local mason_data = vim.fn.stdpath 'data' .. '/mason'
    local pkg_name = 'codelldb'
    local install_dir = mason_data .. '/packages/' .. pkg_name
    local extension_path = install_dir .. '/extension/'
    local adapter_path = extension_path .. 'adapter/codelldb'
    local lib_base = extension_path .. 'lldb/lib/liblldb'
    local os_name = vim.loop.os_uname().sysname
    local lib_ext = os_name == 'Linux' and '.so' or '.dylib'
    local lib_path = lib_base .. lib_ext
    local cfg = require 'rustaceanvim.config'
    return cfg.get_codelldb_adapter(adapter_path, lib_path)
  end
end

local config = function()
  local settings = {
    tools = {
      hover_actions = {
        auto_focus = true,
      },
    },
    server = {
      on_attach = on_attach,
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
          },
        },
      },
    },
    dap = {},
  }
  local ok, adapter = pcall(get_codelldb_adapter)
  if ok then
    settings.dap.adapter = adapter
  end
  vim.g.rustaceanvim = settings
end

return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  config = config,
}
