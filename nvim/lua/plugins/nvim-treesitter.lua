-- ================================================================================================
-- TITLE : nvim-treesitter
-- ABOUT : Treesitter configurations and abstraction layer for Neovim.
-- LINKS :
--   > nvim-treesitter             : https://github.com/nvim-treesitter/nvim-treesitter
--   > nvim-treesitter-context     : https://github.com/nvim-treesitter/nvim-treesitter-context
--   > nvim-ts-autotag             : https://github.com/windwp/nvim-ts-autotag
--   > nvim-treesitter-textobjects : https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- ================================================================================================

---@module "lazy"
---@type LazySpec
return {
  -- core nvim treesitter and treesitter context
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
    },
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local ts = require 'nvim-treesitter'

      -- Install core parsers at startup
      ts.install {
        'bash',
        'c',
        'cpp',
        'css',
        'diff',
        'fish',
        'git_config',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'html',
        'java',
        'javascript',
        'json',
        'latex',
        'lua',
        'luadoc',
        'make',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'rust',
        'regex',
        'scss',
        'svelte',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
      }

      local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

      local ignore_filetypes = {
        'checkhealth',
        'lazy',
        'mason',
        'snacks_dashboard',
        'snacks_notif',
        'snacks_win',
      }

      -- Auto-install parsers and enable highlighting on FileType
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        desc = 'Enable treesitter highlighting and indentation',
        callback = function(event)
          if vim.tbl_contains(ignore_filetypes, event.match) then
            return
          end

          local lang = vim.treesitter.language.get_lang(event.match) or event.match
          local buf = event.buf

          -- Start highlighting immediately (works if parser exists)
          pcall(vim.treesitter.start, buf, lang)

          -- Enable treesitter indentation
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- Install missing parsers (async, no-op if already installed)
          ts.install { lang }
        end,
      })
    end,
  },
  -- nvim treesitter textobjects
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      vim.g.no_plugin_maps = true
    end,
    config = function()
      local ts_textobjects = require 'nvim-treesitter-textobjects'
      ts_textobjects.setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          include_surrounding_whitespace = false,
        },
        move = {
          enable = true,
          set_jumps = true,
        },
      }
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterTextobjectsKeymaps', { clear = true }),
        callback = function(ev)
          local buf = ev.buf

          -- skip buffers without a treesitter parser
          local ok = pcall(vim.treesitter.get_parser, buf)
          if not ok then
            return
          end

          -- buffer-local keymap helper
          local function keymap(modes, lhs, rhs, desc)
            vim.keymap.set(modes, lhs, rhs, {
              buffer = buf,
              silent = true,
              desc = '[Treesitter] ' .. desc,
            })
          end

          -- ===== select =====
          keymap({ 'x', 'o' }, 'am', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
          end, 'Select function (outer)')

          keymap({ 'x', 'o' }, 'im', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
          end, 'Select function (inner)')

          keymap({ 'x', 'o' }, 'ac', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
          end, 'Select class (outer)')

          keymap({ 'x', 'o' }, 'ic', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
          end, 'Select class (inner)')

          keymap({ 'x', 'o' }, 'as', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
          end, 'Select scope')

          -- ===== swap =====
          keymap('n', '<leader>a', function()
            require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
          end, 'Swap with next parameter')

          keymap('n', '<leader>A', function()
            require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner'
          end, 'Swap with previous parameter')

          -- ===== move (next) =====
          keymap({ 'n', 'x', 'o' }, ']m', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
          end, 'Next function start')

          keymap({ 'n', 'x', 'o' }, ']]', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
          end, 'Next class start')

          keymap({ 'n', 'x', 'o' }, ']o', function()
            require('nvim-treesitter-textobjects.move').goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
          end, 'Next loop start')

          keymap({ 'n', 'x', 'o' }, ']s', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
          end, 'Next scope start')

          keymap({ 'n', 'x', 'o' }, ']z', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
          end, 'Next fold')

          keymap({ 'n', 'x', 'o' }, ']M', function()
            require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
          end, 'Next function end')

          keymap({ 'n', 'x', 'o' }, '][', function()
            require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
          end, 'Next class end')

          -- ===== move (previous) =====
          keymap({ 'n', 'x', 'o' }, '[m', function()
            require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
          end, 'Previous function start')

          keymap({ 'n', 'x', 'o' }, '[[', function()
            require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
          end, 'Previous class start')

          keymap({ 'n', 'x', 'o' }, '[M', function()
            require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
          end, 'Previous function end')

          keymap({ 'n', 'x', 'o' }, '[]', function()
            require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
          end, 'Previous class end')

          keymap({ 'n', 'x', 'o' }, ']d', function()
            require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects')
          end, 'Next conditional')

          keymap({ 'n', 'x', 'o' }, '[d', function()
            require('nvim-treesitter-textobjects.move').goto_previous('@conditional.outer', 'textobjects')
          end, 'Previous conditional')
        end,
      })
    end,
  },
  -- Automatically add closing tags for HTML and JSX
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },
}
