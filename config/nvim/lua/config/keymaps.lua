-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Tab navigation
map("n", "<A-n>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<A-p>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Pane navigation
map("n", "<A-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<A-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<A-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<A-j>", "<C-w>j", { desc = "Go to lower window" })

-- Easy visual indentation
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- Execute macro saved in 'q' register
map("n", "qj", "@q", { desc = "Run macro q" })

-- Insert line below/above without entering insert mode
map("n", "<CR>", "o<Esc>", { desc = "Insert line below" })
map("n", "<S-CR>", "O<Esc>", { desc = "Insert line above" })

-- Keep cursor centered while paging
map("n", "<C-u>", "<C-u>zz", { desc = "Page up centered" })
map("n", "<C-d>", "<C-d>zz", { desc = "Page down centered" })

-- Better paste in visual mode
map("x", "<leader>p", [['_dP]], { desc = "Paste without yanking replaced text" })

-- Delete without yanking
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole register" })
-- TODO: :echo expand('%:p')
