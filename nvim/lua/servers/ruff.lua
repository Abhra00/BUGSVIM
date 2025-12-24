-- ================================================================================================
-- TITLE : ruff (Additional Python Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/astral-sh/ruff
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from blink-cmp or similar)
--- @return nil This function doesn't return a value, it configures the LSP server
return function(capabilities)
  vim.lsp.config('ruff', {
    capabilities = capabilities,
    settings = {
      cmd_env = { RUFF_TRACE = 'messages' },
      init_options = {
        settings = {
          logLevel = 'error',
        },
      },
    },
  })
end
