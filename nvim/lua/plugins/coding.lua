---@diagnostic disable: undefined-doc-name
return {
  -- Improved viewing for markdown files
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      heading = {
        icons = { " 󰼏 ", " 󰼐 ", " 󰼑 ", " 󰼒 ", " 󰼓 ", " 󰼔 " },
        position = "inline",
      },
    },
  },
  -- Blink-cmp
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          winblend = vim.o.pumblend,
        },
      },
      signature = {
        window = {
          winblend = vim.o.pumblend,
        },
      },
    },
  },
}
