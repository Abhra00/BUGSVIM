-- Set up icons
-- stylua: ignore start
local icons = {
  Stopped               = { '', 'DiagnosticWarn', 'DapStoppedLine' },
  Breakpoint            = '',
  BreakpointCondition   = '',
  BreakpointRejected    = { '', 'DiagnosticError' },
  LogPoint              = '󰚃',
}
for name, sign in pairs(icons) do
  sign = type(sign) == 'table' and sign or { sign }
  vim.fn.sign_define('Dap' .. name, {
    text    = sign[1] --[[@as string]] .. ' ',
    texthl  = sign[2] or 'DiagnosticInfo',
    linehl  = sign[3],
    numhl   = sign[3],
  })
end
-- stylua: ignore end

-- Debugging setup
return {
  'mfussenegger/nvim-dap',
  cmd = {
    'DapContinue',
    'DapStepOver',
    'DapStepInto',
    'DapStepOut',
    'DapToggleBreakpoint',
  },
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    { 'leoluz/nvim-dap-go', ft = 'go' },
  },
  keys = {
    -- stylua: ignore start
    { '<leader>dt', function() require('dap').toggle_breakpoint() end, desc = '[D]ebug [T]oggle Breakpoint' },
    { '<leader>ds', function() require('dap').continue() end,          desc = '[D]ebug [S]tart' },
    { '<leader>dc', function() require('dapui').close() end,          desc = '[D]ebug [C]lose' },
    { '<leader>dn', function() require('dap').step_over() end,        desc = '[D]ebug Step [N]ext' },
    { '<leader>di', function() require('dap').step_into() end,        desc = '[D]ebug Step [I]nto' },
    { '<leader>do', function() require('dap').step_out() end,         desc = '[D]ebug Step [O]ut' },
    -- stylua: ignore end
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local godap = require 'dap-go'

    dapui.setup() -- Set up dapui
    godap.setup() -- Set up go debugger

    dap.configurations.java = {
      {
        type = 'java',
        request = 'attach',
        name = 'Debug (Attach) - Remote',
        hostName = '127.0.0.1',
        port = 5005,
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end
  end,
}
