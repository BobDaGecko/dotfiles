-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- No format-on-save for web files: hand-formatted projects (e.g. swing-lab) would get
-- whole-file rewrites from vtsls/html/cssls. Format on demand with <leader>cf, or
-- turn it back on for the buffer with <leader>uF.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_no_autoformat_web", { clear = true }),
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "css" },
  callback = function()
    vim.b.autoformat = false
  end,
})
