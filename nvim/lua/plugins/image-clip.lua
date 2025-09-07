return {
  'HakonHarnes/img-clip.nvim',
  ft = { 'markdown', 'tex', 'typst', 'org' },
  cmd = { 'PasteImage' },
  keys = {
    { '<leader>ip', '<cmd>PasteImage<cr>', desc = '[P]aste [I]mage from clipboard' },
    {
      '<leader>if',
      function()
        local fzf = require 'fzf-lua'
        local img_clip = require 'img-clip'

        fzf.files {
          actions = {
            ['default'] = function(selected, opts)
              local filepath = selected[1]:gsub('^[^%w/\\]*%s*', '')
              img_clip.paste_image(nil, filepath)
            end,
          },
        }
      end,
      desc = '[I]mage picker with FzfLua',
    },
  },
  opts = {},
}
