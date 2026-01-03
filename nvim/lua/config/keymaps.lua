-- Keymaps
-- NOTE: Keymaps are automatically loaded on the VeryLazy event

-- Discipline
local discipline = require("bugs.discipline")
discipline.cowboy()

-- For convenience
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Increment/Decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- Tab management
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<Tab>", "<Cmd>tabnext<CR>", opts)
keymap.set("n", "<S-Tab>", "<Cmd>tabprev<CR>", opts)

-- Split window
keymap.set("n", "ss", "<Cmd>split<CR>", opts)
keymap.set("n", "sv", "<Cmd>vsplit<CR>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><Left>", "<C-w><")
keymap.set("n", "<C-w><Right>", "<C-w>>")
keymap.set("n", "<C-w><Up>", "<C-w>+")
keymap.set("n", "<C-w><Down>", "<C-w>-")

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, opts)

keymap.set("n", "<C-k>", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, opts)

-- Hex to hsl
keymap.set("n", "<leader>r", function()
  require("bugs.hsl").replaceHexWithHSL()
end)
