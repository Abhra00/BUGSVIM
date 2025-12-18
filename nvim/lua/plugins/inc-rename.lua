-- ================================================================================================
-- TITLE : inc-rename.nvim
-- ABOUT : Incremental renaming with visual feedback
-- -- LINKS :
--   > github :https://github.com/smjonas/inc-rename.nvim
-- ================================================================================================

return {
  'smjonas/inc-rename.nvim',
  cmd = 'IncRename',
  config = function()
    require('inc_rename').setup {
      input_buffer_type = 'snacks',
    }
  end,
}
