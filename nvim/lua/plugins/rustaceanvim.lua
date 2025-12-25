-- ================================================================================================
-- TITLE : rustaceanvim
-- ABOUT : A heavily modified fork of rust-tools.nvim
-- LINKS :
--   > github : https://github.com/mrcjkb/rustaceanvim
-- ================================================================================================

return {
  'mrcjkb/rustaceanvim',
  ft = { 'rust' },
  opts = {
    dap = {},
    server = {
      on_attach = function(client, bufnr)
        require('utils.lsp').on_attach(client, bufnr)
        vim.keymap.set('n', '<leader>cR', function()
          vim.cmd.RustLsp 'codeAction'
        end, { buffer = bufnr })
        vim.keymap.set('n', '<leader>dr', function()
          vim.cmd.RustLsp 'debuggables'
        end, { buffer = bufnr })
      end,
      default_settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          checkOnSave = {
            command = 'clippy',
          },
          diagnostics = {
            enable = true,
          },
          procMacro = {
            enable = true,
          },
          files = {
            exclude = {
              '.direnv',
              '.git',
              '.jj',
              '.github',
              '.gitlab',
              'bin',
              'node_modules',
              'target',
              'venv',
              '.venv',
            },
            watcher = 'client',
          },
        },
      },
    },
  },
  config = function(_, opts)
    local has_mason = pcall(require, 'mason')
    if has_mason then
      local codelldb = vim.fn.exepath 'codelldb'
      if codelldb ~= '' then
        local is_linux = (vim.uv or vim.loop).os_uname().sysname == 'Linux'
        local lib_ext = is_linux and '.so' or '.dylib'
        local mason_root = vim.fn.stdpath 'data' .. '/mason'
        local library_path = mason_root .. '/packages/codelldb/extension/lldb/lib/liblldb' .. lib_ext
        opts.dap.adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb, library_path)
      end
    end
    vim.g.rustaceanvim = vim.tbl_deep_extend('force', vim.g.rustaceanvim or {}, opts or {})
    if vim.fn.executable 'rust-analyzer' == 0 then
      vim.notify('rust-analyzer not found in PATH', vim.log.levels.ERROR, { title = 'rustaceanvim' })
    end
  end,
}
