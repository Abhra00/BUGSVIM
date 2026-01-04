-- Enable loader
if vim.loader then
  vim.loader.enable()
end

-- Inspect
_G.dd = function(...)
  require("snacks.debug").inspect(...)
end
-- Backtrace
_G.bt = function(...)
  require("snacks.debug").backtrace()
end
-- Profile
_G.p = function(...)
  require("snacks.debug").profile(...)
end

vim._print = function(_, ...)
  dd(...)
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
