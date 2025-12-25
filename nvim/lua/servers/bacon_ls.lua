-- ================================================================================================
-- TITLE : bacon-ls
-- LINKS :
--   > github: https://github.com/crisidev/bacon-ls
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from bink-cmp or similar)
--- @return nil
return function(capabilities)
  vim.lsp.config('bacon_ls', {
    cmd = { 'bacon-ls' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    capabilities = capabilities,
  })
end
