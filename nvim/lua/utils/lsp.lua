-- ================================================================================================
-- TITLE: Neovim lsp config
-- ABOUT: sets the base for lsp configuration
-- ================================================================================================

local M = {}

M.on_attach = function(client_or_event, bufnr_or_nil)
  local client, bufnr

  -- Detect which calling convention is being used
  if type(client_or_event) == 'table' and client_or_event.data then
    local event = client_or_event
    client = vim.lsp.get_client_by_id(event.data.client_id)
    bufnr = event.buf
  else
    client = client_or_event
    bufnr = bufnr_or_nil
  end

  if not client then
    return
  end

  local keymap = vim.keymap.set
  local function opts(desc)
    return { noremap = true, silent = true, buffer = bufnr, desc = '[LSP]:' .. desc }
  end

  -- stylua: ignore start
  -- Native LSP Keymaps
  keymap("n", "<leader>gd", vim.lsp.buf.definition, opts("Go to definition"))
  keymap("n", "<leader>gS", function() vim.cmd("vsplit") vim.lsp.buf.definition() end, opts("Go to definition (split)"))
  keymap("n", "<leader>gD", vim.lsp.buf.declaration, opts("Go to declaration"))
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
  keymap("n", "<leader>D", vim.diagnostic.open_float, opts("Line diagnostics"))
  keymap("n", "<leader>C", function() vim.diagnostic.open_float(nil, { scope = "cursor" }) end, opts("Cursor diagnostics"))
  keymap("n", "<leader>[d", function () vim.diagnostic.jump({count = -1}) end, opts("Previous diagnostic"))
  keymap("n", "<leader>]d", function () vim.diagnostic.jump({count = 1}) end, opts("Next diagnostic"))
  keymap("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
  -- stylua: ignore end

  -- Incremental renaming with inc-rename.nvim
  keymap('n', '<leader>rN', function()
    local inc_rename = require 'inc_rename'
    return ':' .. inc_rename.config.cmd_name .. ' ' .. vim.fn.expand '<cword>'
  end, {
    expr = true,
    desc = '[LSP]: Rename (inc-rename.nvim)',
  })

  -- Organize Imports (if supported)
  Snacks.util.lsp.on({ method = 'textDocument/codeAction', bufnr = bufnr }, function(buf)
    keymap('n', '<leader>oi', function()
      vim.lsp.buf.code_action {
        context = { only = { 'source.organizeImports' }, diagnostics = {} },
        apply = true,
      }
      vim.defer_fn(function()
        require('conform').format { bufnr = buf }
      end, 50)
    end, { noremap = true, silent = true, buffer = buf, desc = '[LSP]: Organize imports' })
  end)

  -- Document highlighting
  Snacks.util.lsp.on({ method = 'textDocument/documentHighlight', bufnr = bufnr }, function(buf)
    local group = vim.api.nvim_create_augroup('lsp_document_highlight_' .. buf, { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = group,
      buffer = buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = group,
      buffer = buf,
      callback = vim.lsp.buf.clear_references,
    })
  end)

  -- Folding
  Snacks.util.lsp.on({ method = 'textDocument/foldingRange', bufnr = bufnr }, function(buf)
    vim.api.nvim_set_option_value('foldmethod', 'expr', { scope = 'local' })
    vim.api.nvim_set_option_value('foldexpr', 'v:lua.vim.lsp.foldexpr()', { scope = 'local' })
  end)

  -- Inlay Hints
  Snacks.util.lsp.on({ method = 'textDocument/inlayHint', bufnr = bufnr }, function(buf)
    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
  end)

  -- Code Lens
  if vim.lsp.codelens then
    Snacks.util.lsp.on({ method = 'textDocument/codeLens', bufnr = bufnr }, function(buf)
      vim.lsp.codelens.refresh()

      vim.keymap.set('n', '<leader>cr', vim.lsp.codelens.refresh, {
        buffer = buf,
        desc = 'Refresh Codelens',
      })

      vim.keymap.set({ 'n', 'x' }, '<leader>cc', vim.lsp.codelens.run, {
        buffer = buf,
        desc = 'Run Codelens',
      })
    end)
  end
end

return M
