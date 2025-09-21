return {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  dependencies = { 'nvim-mini/mini.icons' },
  config = function()
    -- Get icons
    local icons = require 'config.icons'
    local img_previewer ---@type string[]?
    for _, v in ipairs {
      { cmd = 'chafa', args = { '{file}' } },
    } do
      if vim.fn.executable(v.cmd) == 1 then
        img_previewer = vim.list_extend({ v.cmd }, v.args)
        break
      end
    end
    local fzfLua = require 'fzf-lua'
    fzfLua.setup {
      -- Set fzf previewers
      previewers = {
        builtin = {
          extensions = {
            ['png'] = img_previewer,
            ['jpg'] = img_previewer,
            ['jpeg'] = img_previewer,
            ['gif'] = img_previewer,
            ['webp'] = img_previewer,
          },
          ueberzug_scaler = false,
          snacks = { enabled = false },
        },
      },
      -- Set fzf window options
      winopts = {
        border = vim.g.border_style,
        backdrop = 100,
        preview = {
          border = vim.g.border_style,
        },
      },
      -- Set fzf opts
      fzf_opts = {
        ['--ansi'] = true,
        ['--style'] = 'default',
        ['--info'] = 'inline-right',
        ['--height'] = '100%',
        ['--layout'] = 'reverse-list',
        ['--border'] = 'none',
        ['--highlight-line'] = true,
        ['--pointer'] = '██',
      },
      -- Set fzf colors
      fzf_colors = {
        true,
        ['fg'] = { 'fg', 'FzfLuaFg' },
        ['bg'] = { 'bg', 'FzfLuaBg' },
        ['preview-bg'] = { 'bg', 'FzfLuaBg' },
        ['hl'] = { 'fg', 'FzfLuaHl' },
        ['fg+'] = { 'fg', 'FzfLuaSelFg' },
        ['bg+'] = { 'bg', 'FzfLuaSelBg' },
        ['hl+'] = { 'fg', 'FzfLuaHlPlus' },
        ['info'] = { 'fg', 'PreProc' },
        ['prompt'] = { 'fg', 'FzfLuaPrompt' },
        ['pointer'] = { 'fg', 'FzfLuaPointer' },
        ['marker'] = { 'fg', 'FzfLuaMarker' },
        ['spinner'] = { 'fg', 'FzfLuaSpinner' },
        ['header'] = { 'fg', 'FzfLuaHeader' },
        ['gutter'] = -1,
      },
      -- Set fzf pickers
      files = {
        prompt = 'FILIES ' .. icons.ui.FzfLuaPromptSuffix,
        cwd_prompt = false,
      },
      buffers = {
        prompt = 'BUFFERS ' .. icons.ui.FzfLuaPromptSuffix,
      },
      oldfiles = {
        prompt = 'OLDFILES ' .. icons.ui.FzfLuaPromptSuffix,
      },
      live_grep = {
        prompt = 'LIVEGREP ' .. icons.ui.FzfLuaPromptSuffix,
      },
      grep = {
        prompt = 'GREP ' .. icons.ui.FzfLuaPromptSuffix,
      },
      blines = {
        prompt = 'BLINES ' .. icons.ui.FzfLuaPromptSuffix,
      },
      lines = {
        prompt = 'LINES ' .. icons.ui.FzfLuaPromptSuffix,
      },
      tags = {
        prompt = 'TAGS ' .. icons.ui.FzfLuaPromptSuffix,
      },
      btags = {
        prompt = 'BTAGS ' .. icons.ui.FzfLuaPromptSuffix,
      },
      helptags = {
        prompt = 'HELP ' .. icons.ui.FzfLuaPromptSuffix,
      },
      manpages = {
        prompt = 'MAN ' .. icons.ui.FzfLuaPromptSuffix,
      },
      colorschemes = {
        prompt = 'COLORS ' .. icons.ui.FzfLuaPromptSuffix,
      },
      keymaps = {
        prompt = 'KEYMAPS ' .. icons.ui.FzfLuaPromptSuffix,
      },
      commands = {
        prompt = 'COMMANDS ' .. icons.ui.FzfLuaPromptSuffix,
      },
      command_history = {
        prompt = 'HISTORY ' .. icons.ui.FzfLuaPromptSuffix,
      },
      search_history = {
        prompt = 'SEARCH ' .. icons.ui.FzfLuaPromptSuffix,
      },
      lsp = {
        prompt_postfix = icons.ui.FzfLuaPromptSuffix, -- use postfix for lsp
        symbols = {
          prompt = 'LSP-SYMBOLS ' .. icons.ui.FzfLuaPromptSuffix,
        },
        references = {
          prompt = 'LSP-REFS ' .. icons.ui.FzfLuaPromptSuffix,
        },
        definitions = {
          prompt = 'LSP-DEFS ' .. icons.ui.FzfLuaPromptSuffix,
        },
        declarations = {
          prompt = 'LSP-DECLS ' .. icons.ui.FzfLuaPromptSuffix,
        },
        implementations = {
          prompt = 'LSP-IMPLS ' .. icons.ui.FzfLuaPromptSuffix,
        },
        code_actions = {
          prompt = 'LSP-ACTIONS ' .. icons.ui.FzfLuaPromptSuffix,
        },
        diagnostics = {
          prompt = 'LSP-DIAGS ' .. icons.ui.FzfLuaPromptSuffix,
        },
      },
      git = {
        files = {
          prompt = icons.git.Branch .. ' GIT-FILES ' .. icons.ui.FzfLuaPromptSuffix,
        },
        status = {
          prompt = icons.git.Branch .. ' GIT-STATUS ' .. icons.ui.FzfLuaPromptSuffix,
        },
        diff = {
          prompt = icons.git.Branch .. ' GIT-DIFF ' .. icons.ui.FzfLuaPromptSuffix,
        },
        branches = {
          prompt = icons.git.Branch .. ' GIT-BRANCHES ' .. icons.ui.FzfLuaPromptSuffix,
        },
        tags = {
          prompt = icons.git.Branch .. ' GIT-TAGS ' .. icons.ui.FzfLuaPromptSuffix,
        },
        stash = {
          prompt = icons.git.Branch .. ' GIT-STASH ' .. icons.ui.FzfLuaPromptSuffix,
        },
      },
    }
    -- load ui select for fzf
    fzfLua.register_ui_select()

    -- set a vim motion to <Space> + f + f to search for files by their names
    vim.keymap.set('n', '<leader>ff', fzfLua.files, { desc = '[F]ind [F]iles Using FZF' })
    -- set a vim motion to <Space> + f + g to search for files based on the text inside of them
    vim.keymap.set('n', '<leader>fg', fzfLua.live_grep, { desc = '[F]ind By [G]rep Using FZF' })
    -- set a vim motion to <Space> + f + d to search for Code Diagnostics in the current project
    vim.keymap.set('n', '<leader>fd', fzfLua.diagnostics_document, { desc = '[F]ind [D]iagnostics Using FZF' })
    -- set a vim motion to <Space> + f + r to resume the previous search
    vim.keymap.set('n', '<leader>fr', fzfLua.resume, { desc = '[F]inder [R]esume Using FZF' })
    -- set a vim motion to <Space> + f + . to search for Recent Files
    vim.keymap.set('n', '<leader>f.', fzfLua.oldfiles, { desc = '[F]ind Recent Files Using FZF ("." for repeat)' })
    -- set a vim motion to <Space> + f + b to search Open Buffers
    vim.keymap.set('n', '<leader>fb', fzfLua.buffers, { desc = '[F]ind Existing [B]uffers Using FZF' })
    -- set a vim motion to <Space> + f + z to search through fzf builtin commands and use them
    vim.keymap.set('n', '<leader>fz', fzfLua.builtin, { desc = '[F]ind All Available FZF Builtin Commands' })
  end,
}
