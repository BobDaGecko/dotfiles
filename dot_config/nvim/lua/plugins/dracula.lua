return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false, -- Colorschemes must load immediately
    priority = 1000, -- Load before all other plugins
    config = function()
      -- Apply the colorscheme
      vim.cmd.colorscheme("dracula")
    end,
  },
}
