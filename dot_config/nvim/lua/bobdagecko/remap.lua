-- ============================================================================
-- Window & Navigation
-- ============================================================================

-- Split window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to upper window" })

-- Project viewer (netrw)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Project [V]iewer" })

-- Centered half-page scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page (centered)" })

-- Centered search navigation
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- ============================================================================
-- UI & Editor Experience
-- ============================================================================

-- Clear search highlight on Escape
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Exit terminal mode easily
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable Ex mode (anti-frustration)
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- Fix vertical block edit exit behavior
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Ensure <C-c> triggers Escape behavior" })

-- Quickfix list navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next Quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Prev Quickfix item" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next Location List item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev Location List item" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Diagnostic Navigation
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic' })

-- ============================================================================
-- Text Manipulation
-- ============================================================================

-- Move highlighted lines up/down and auto-indent
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Append next line to current without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below (keep cursor)" })

-- Paste over selection without losing paste buffer
vim.keymap.set("x", "<leader>P", [["_dP]], { desc = "Paste over (retain register)" })

-- Delete without overriding clipboard (Void register)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- Interactive search and replace for word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor globally" })

-- If you use `vim.o.clipboard = 'unnamedplus'`, these are redundant.
-- Uncomment if you disable unnamedplus and want isolated OS clipboard logic.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to OS clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to OS clipboard" })

-- Paste from the system clipboard (optional: if you want <leader>p to be OS-pasting)
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from OS clipboard" })

-- ============================================================================
-- System & Utility
-- ============================================================================

-- Make current bash/script file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file e[x]ecutable" })

-- Source current file (reload config)
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Source current file" })

-- ============================================================================
-- Language Specific & Third-Party Tools (Primeagen Extras)
-- ============================================================================

-- Go Error Handling Snippets
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", { desc = "Go: insert if err return" })
vim.keymap.set("n", "<leader>ea", "oassert.NoError(err, \"\")<Esc>F\";a", { desc = "Go: insert assert NoError" })
vim.keymap.set("n", "<leader>ef", "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj", { desc = "Go: insert if err Fatal" })
vim.keymap.set("n", "<leader>el", "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i", { desc = "Go: insert if err Logger" })

-- Tmux Sessionizer (Requires external bash script and tmux)
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
-- vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
