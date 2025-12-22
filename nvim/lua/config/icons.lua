-- ================================================================================================
-- TITLE: NeoVim icons
-- ABOUT: Set definitions for used icons globally
-- ================================================================================================

local M = {}

-- Diagnostics
M.diagnostics = {
  Error = ' ',
  Warn = ' ',
  Hint = ' ',
  Info = ' ',
}

-- Dap icons
M.dap = {
  Stopped = { '', 'DiagnosticWarn', 'DapStoppedLine' },
  Breakpoint = '',
  BreakpointCondition = '',
  BreakpointRejected = { '', 'DiagnosticError' },
  LogPoint = '󰚃',
}

-- Git icons
M.git = {
  added = ' ',
  modified = ' ',
  removed = ' ',
}

-- Some special file types
M.ft = {
  octo = ' ',
  gh = ' ',
  ['markdown.gh'] = ' ',
}

return M
