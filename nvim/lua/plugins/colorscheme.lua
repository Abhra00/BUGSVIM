-- Colorscheme
return {
  "craftzdog/solarized-osaka.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    local transparent = true
    local Util = require("solarized-osaka.util")
    require("solarized-osaka").setup({
      transparent = transparent,
      ---@param highlights Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors)
        ---@diagnostic disable: inject-field
        -- LineNr
        highlights.LineNr = { fg = colors.yellow700 }
        -- Tabline
        highlights.TabLineFill = { fg = colors.base0, bg = transparent and colors.none or colors.base02 }
        -- stylua: ignore start
        -- Snacks Notifier
        highlights.SnacksNotifierDebug           = { fg = colors.fg, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierBorderDebug     = { fg = colors.base01, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierIconDebug       = { fg = colors.base01 }
        highlights.SnacksNotifierTitleDebug      = { fg = colors.base01 }
        highlights.SnacksNotifierError           = { fg = colors.fg, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierBorderError     = { fg = colors.red500, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierIconError       = { fg = colors.red500 }
        highlights.SnacksNotifierTitleError      = { fg = colors.red500 }
        highlights.SnacksNotifierInfo            = { fg = colors.fg, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierBorderInfo      = { fg = colors.blue500, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierIconInfo        = { fg = colors.blue500 }
        highlights.SnacksNotifierTitleInfo       = { fg = colors.blue500 }
        highlights.SnacksNotifierTrace           = { fg = colors.fg, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierBorderTrace     = { fg = colors.magenta500, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierIconTrace       = { fg = colors.magenta500 }
        highlights.SnacksNotifierTitleTrace      = { fg = colors.magenta500 }
        highlights.SnacksNotifierWarn            = { fg = colors.fg, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierBorderWarn      = { fg = colors.yellow500, bg = transparent and colors.none or colors.bg }
        highlights.SnacksNotifierIconWarn        = { fg = colors.yellow500 }
        highlights.SnacksNotifierTitleWarn       = { fg = colors.yellow500 }
        -- Snacks Dashboard
        highlights.SnacksDashboardDesc           = { fg = colors.cyan500 }
        highlights.SnacksDashboardFooter         = { fg = colors.yellow, italic = true }
        highlights.SnacksDashboardHeader         = { fg = colors.blue500 }
        highlights.SnacksDashboardIcon           = { fg = colors.cyan500, bold = true }
        highlights.SnacksDashboardKey            = { fg = colors.orange500 }
        highlights.SnacksDashboardSpecial        = { fg = colors.yellow500 }
        highlights.SnacksDashboardDir            = { fg = colors.base01 }
        -- Snacks Profiler
        highlights.SnacksProfilerIconInfo        = { bg = Util.blend(colors.blue500, colors.bg, 0.3), fg = colors.blue500 }
        highlights.SnacksProfilerBadgeInfo       = { bg = Util.blend(colors.blue500, colors.bg, 0.1), fg = colors.blue500 }
        highlights.SnacksFooterKey               = "SnacksProfilerIconInfo"
        highlights.SnacksFooterDesc              = "SnacksProfilerBadgeInfo"
        highlights.SnacksProfilerIconTrace       = { bg = Util.blend(colors.violet500, colors.bg, 0.3), fg = colors.base01 }
        highlights.SnacksProfilerBadgeTrace      = { bg = Util.blend(colors.violet500, colors.bg, 0.1), fg = colors.base01 }
        -- Snacks Indent Scope
        highlights.SnacksIndent                  = { fg = colors.base03, nocombine = true }
        highlights.SnacksIndentScope             = { fg = colors.violet700, nocombine = true }
        -- Snacks Zen mode
        highlights.SnacksZenIcon                 = { fg = colors.violet500 }
        -- Snacks Input
        highlights.SnacksInputIcon               = { fg = colors.cyan500 }
        highlights.SnacksInputBorder             = { fg = colors.blue500 }
        highlights.SnacksInputTitle              = { fg = colors.blue500 }
        -- Snacks Picker
        highlights.SnacksPickerInputBorder       = { fg = colors.base02, bg = colors.bg_float }
        highlights.SnacksPickerInputTitle        = { fg = colors.orange500, bg = colors.bg_float }
        highlights.SnacksPickerBoxTitle          = { fg = colors.blue500, bg = colors.bg_float }
        highlights.SnacksPickerSelected          = { fg = colors.magenta500 }
        highlights.SnacksPickerToggle            = "SnacksProfilerBadgeInfo"
        highlights.SnacksPickerPickWinCurrent    = { fg = colors.fg, bg = colors.magenta300, bold = true }
        highlights.SnacksPickerPickWin           = { fg = colors.fg, bg = colors.base02, bold = true }
        highlights.SnacksPickerBorder            = { fg = colors.base02, bg = colors.bg_float }
        highlights.SnacksPickerTitle             = "Title"
        highlights.SnacksPickerPreviewTitle      = { fg = colors.blue500, bg = colors.bg_float }
        highlights.SnacksGhLabel                 = { fg = colors.blue500, bold = true }
        highlights.SnacksGhDiffHeader            = { bg = Util.blend(colors.blue500, colors.bg, 0.1), fg = colors.blue500 }
      end,
    })
  end,
}
