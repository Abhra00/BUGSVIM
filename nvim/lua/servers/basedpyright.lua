-- ================================================================================================
-- TITLE : basedpyright (Python Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/DetachHead/basedpyright
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from blink-cmp or similar)
--- @return nil This function doesn't return a value, it configures the LSP server
return function(capabilities)
  vim.lsp.config('basedpyright', {
    capabilities = capabilities,
    settings = {
      basedpyright = {
        disableOrganizeImports = true, -- Using Ruff's import organizer
        disableLanguageServices = false,
        analysis = {
          ignore = { '*' }, -- Ignore all files for analysis to exclusively use Ruff for linting
          typeCheckingMode = 'strict', -- Use strict type checking
          diagnosticMode = 'openFilesOnly', -- Only analyze open files
          useLibraryCodeForTypes = true,
          autoImportCompletions = true, -- whether pyright offers auto-import completions
        },
      },
    },
  })
end
