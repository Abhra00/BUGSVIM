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
  local function opts(desc, extra)
    local base = { noremap = true, silent = true, buffer = bufnr, desc = '[LSP]:' .. desc }
    return extra and vim.tbl_extend('force', base, extra) or base
  end

  -- stylua: ignore start
  -- Native LSP Keymaps
  keymap("n", "gl", function() Snacks.picker.lsp_config() end, opts("Lsp Info"))
  keymap("n", "gd", function() Snacks.picker.lsp_definitions() end, opts("Goto Definition"))
  keymap("n", "gS", function() vim.cmd("vsplit") vim.lsp.buf.definition() end, opts("Go to definition (split)"))
  keymap("n", "gD", function() Snacks.picker.lsp_declarations() end, opts("Goto Declaration"))
  keymap("n", "gr", function() Snacks.picker.lsp_references() end, opts("References", { nowait = true }))
  keymap("n", "gI", function() Snacks.picker.lsp_implementations() end, opts("Goto Implementation"))
  keymap("n", "gy", function() Snacks.picker.lsp_type_definitions() end, opts("Goto T[y]pe Definition"))
  keymap("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, opts("C[a]lls Incoming"))
  keymap("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, opts("C[a]lls Outgoing"))
  keymap("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
  keymap("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, opts("LSP Symbols"))
  keymap("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, opts("LSP Workspace Symbols"))
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
  keymap("n", "<leader>D", vim.diagnostic.open_float, opts("Line diagnostics"))
  keymap("n", "<leader>C", function() vim.diagnostic.open_float(nil, { scope = "cursor" }) end, opts("Cursor diagnostics"))
  keymap("n", "<leader>[d", function () vim.diagnostic.jump({count = -1}) end, opts("Previous diagnostic"))
  keymap("n", "<leader>]d", function () vim.diagnostic.jump({count = 1}) end, opts("Next diagnostic"))
  keymap("n", "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, opts("Next Reference"))
  keymap("n", "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, opts("Prev Reference"))
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
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == '' then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
  end)

  -- Code Lens
  if vim.lsp.codelens then
    Snacks.util.lsp.on({ method = 'textDocument/codeLens', bufnr = bufnr }, function(buf)
      -- Refresh the codelens once
      vim.lsp.codelens.refresh()
      -- Keymaps
      vim.keymap.set('n', '<leader>cr', vim.lsp.codelens.refresh, {
        buffer = buf,
        desc = 'Refresh Codelens',
      })
      vim.keymap.set({ 'n', 'x' }, '<leader>cc', vim.lsp.codelens.run, {
        buffer = buf,
        desc = 'Run Codelens',
      })
      -- Auto refresh code lens only when buffer content changes or when entering buffer
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
        buffer = buf,
        callback = function()
          vim.lsp.codelens.refresh { bufnr = buf }
        end,
      })
    end)
  end
end

return M
