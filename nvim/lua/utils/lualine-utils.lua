-- ================================================================================================
-- TITLE: Neovim lualine utils
-- ABOUT: defines some utility function for lualine
-- ================================================================================================
local M = {}

-- Lualine components
M.lualine = {}

-- Pretty path
---@param opts? {relative: "cwd"|"root", modified_hl: string?, directory_hl: string?, filename_hl: string?, modified_sign: string?, readonly_icon: string?, length: number?}
function M.lualine.pretty_path(opts)
  opts = vim.tbl_extend('force', {
    relative = 'cwd',
    modified_hl = 'MatchParen',
    directory_hl = '',
    filename_hl = 'Bold',
    modified_sign = '',
    readonly_icon = ' 󰌾 ',
    length = 3,
  }, opts or {})

  return function(self)
    local path = vim.fn.expand '%:p'
    if path == '' then
      return ''
    end

    -- preserve original path for display
    local norm_path = vim.fs.normalize(path)

    local root_utils = require 'utils.root'
    local root = root_utils.get { normalize = true }
    local cwd = root_utils.cwd()

    -- windows case-insensitive safety
    if vim.fn.has 'win32' == 1 then
      norm_path = norm_path:lower()
      root = root:lower()
      cwd = cwd:lower()
    end

    -- make path relative
    if opts.relative == 'cwd' and norm_path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    elseif opts.relative == 'root' and norm_path:find(root, 1, true) == 1 then
      path = path:sub(#root + 2)
    end

    -- platform separator
    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, '[\\/]')

    -- shorten path
    if opts.length ~= 0 and #parts > opts.length then
      parts = { parts[1], '…', unpack(parts, #parts - opts.length + 2, #parts) }
    end

    -- filename highlighting
    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = parts[#parts] .. opts.modified_sign
      parts[#parts] = M.lualine.format(self, parts[#parts], opts.modified_hl)
    else
      parts[#parts] = M.lualine.format(self, parts[#parts], opts.filename_hl)
    end

    -- directory highlighting
    local dir = ''
    if #parts > 1 then
      dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
      dir = M.lualine.format(self, dir .. sep, opts.directory_hl)
    end

    -- readonly icon
    local readonly = ''
    if vim.bo.readonly then
      readonly = M.lualine.format(self, opts.readonly_icon, opts.modified_hl)
    end

    return dir .. parts[#parts] .. readonly
  end
end

-- Root dir
---@param opts? {cwd:false, subdirectory: true, parent: true, other: true, icon?:string}
function M.lualine.root_dir(opts)
  opts = vim.tbl_extend('force', {
    cwd = false,
    subdirectory = true,
    parent = true,
    other = true,
    icon = '󱉭 ',
    color = function()
      return { fg = Snacks.util.color 'Special' }
    end,
  }, opts or {})

  local function get()
    local root_utils = require 'utils.root'
    local cwd = root_utils.cwd()
    local root = root_utils.get { normalize = true }
    local name = vim.fs.basename(root)

    if root == cwd then
      -- root is cwd
      return opts.cwd and name
    elseif root:find(cwd, 1, true) == 1 then
      -- root is subdirectory of cwd
      return opts.subdirectory and name
    elseif cwd:find(root, 1, true) == 1 then
      -- root is parent directory of cwd
      return opts.parent and name
    else
      -- root and cwd are not related
      return opts.other and name
    end
  end

  return {
    function()
      return (opts.icon and opts.icon .. ' ') .. get()
    end,
    cond = function()
      return type(get()) == 'string'
    end,
    color = opts.color,
  }
end

-- Pretty date
function M.lualine.pretty_time()
  local hour = tonumber(os.date '%H')
  local clocks = {
    '󱑊 ', -- 12
    '󱐿 ', -- 1
    '󱑀 ', -- 2
    '󱑁 ', -- 3
    '󱑂 ', -- 4
    '󱑃 ', -- 5
    '󱑄 ', -- 6
    '󱑅 ', -- 7
    '󱑆 ', -- 8
    '󱑇 ', -- 9
    '󱑈 ', -- 10
    '󱑉 ', -- 11
  }
  -- Set icons
  local icon = clocks[(hour % 12) + 1]
  return icon .. os.date '%R'
end

-- Format helper for lualine
function M.lualine.format(component, text, hl_group)
  text = text:gsub('%%', '%%%%')
  if not hl_group or hl_group == '' then
    return text
  end

  ---@type table<string, string>
  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]

  if not lualine_hl_group then
    local utils = require 'lualine.utils.utils'
    ---@type string[]
    local gui = vim.tbl_filter(function(x)
      return x
    end, {
      utils.extract_highlight_colors(hl_group, 'bold') and 'bold',
      utils.extract_highlight_colors(hl_group, 'italic') and 'italic',
    })

    lualine_hl_group = component:create_hl({
      fg = utils.extract_highlight_colors(hl_group, 'fg'),
      gui = #gui > 0 and table.concat(gui, ',') or nil,
    }, 'LV_' .. hl_group) --[[@as string]]

    component.hl_cache[hl_group] = lualine_hl_group
  end

  return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

return M
