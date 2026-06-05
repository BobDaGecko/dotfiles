-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.opt.clipboard = "unnamedplus"

-- Anti-frustration
vim.keymap.set("n", "Q", "<nop>")

-- Fix C-c not triggering InsertLeave (important for macros/vertical edit)
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Join line but keep cursor in place (plain J jumps you)
vim.keymap.set("n", "J", "mzJ`z")

-- Move visual selection up/down (LazyVim uses <A-j>/<A-k> but these feel better in visual)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Paste over selection without trashing your register
vim.keymap.set("x", "<leader>P", [["_dP]])

-- Location list nav (LazyVim doesn't bind  <leader>j/<leader>k)
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Centered search navigation
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
