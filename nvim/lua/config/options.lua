-- Options
-- NOTE: Options are automatically loaded before lazy.nvim startup

vim.opt.encoding = "utf-8" -- Character encoding
vim.opt.fileencoding = "utf-8" -- File character encoding
vim.opt.number = true -- Line numbers
vim.opt.title = true -- Show title in terminal
vim.opt.autoindent = true -- Auto indentation
vim.opt.smartindent = true -- Smart indentation
vim.opt.hlsearch = true -- Search highlighting
vim.opt.backup = false -- Disable backup files
vim.opt.showcmd = true -- Show partial commands in status line
vim.opt.cmdheight = 1 -- Command line height
vim.opt.laststatus = 3 -- Global statusline
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.scrolloff = 10 -- Keep cursor away from screen edges
vim.opt.shell = "fish" -- Default shell
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" } -- Skip backup for temporary files
vim.opt.inccommand = "split" -- Live preview of substitutions
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true -- Smart tab behavior
vim.opt.breakindent = true -- Preserve indentation on wrapped lines
vim.opt.shiftwidth = 2 -- Indentation width
vim.opt.tabstop = 2 -- Tab width
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { "start", "eol", "indent" } -- Allow backspace over everything
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" }) -- Ignore node_modules in file searches
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor" -- Keep cursor position when splitting
vim.opt.mouse = "" -- Disable mouse support
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = {
  tab = "» ", -- Tab character
  trail = "·", -- Trailing spaces
  nbsp = "␣", -- Non-breaking space
}

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.opt.formatoptions:append({ "r" }) -- Add asterisks in block comments

-- File type associations
vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0 -- Hide command line when not in use (Neovim 0.8+)
end

-- File types
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})

-- Lazyvim picker
vim.g.lazyvim_picker = "snacks"

-- Lazyvim python options
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- Lazyvim rust options
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"
