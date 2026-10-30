return {
  { "Mofiqul/dracula.nvim", lazy = true },

  -- Let LazyVim apply the colorscheme so it loads at the right time (no tokyonight flash)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
