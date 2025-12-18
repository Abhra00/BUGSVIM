-- ================================================================================================
-- TITLE : incline.nvim
-- ABOUT : Incline is a plugin for creating lightweight floating statuslines
-- -- LINKS :
--   > github :https://github.com/b0o/incline.nvim
-- ================================================================================================
return {
  'b0o/incline.nvim',
  dependencies = { 'folke/tokyonight.nvim' },
  event = 'BufReadPre',
  priority = 1200,
  config = function()
    local colors = require('tokyonight.colors').setup { style = 'night' }
    require('incline').setup {
      highlight = {
        groups = {
          InclineNormal = { guibg = colors.orange, guifg = colors.bg },
          InclineNormalNC = { guifg = colors.magenta2, guibg = colors.bg_highlight },
        },
      },
      window = { margin = { vertical = 0, horizontal = 1 } },
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
        if vim.bo[props.buf].modified then
          filename = '[+] ' .. filename
        end

        local icon, color = require('nvim-web-devicons').get_icon_color(filename)
        return { { icon, guifg = color }, { ' ' }, { filename } }
      end,
    }
  end,
}
