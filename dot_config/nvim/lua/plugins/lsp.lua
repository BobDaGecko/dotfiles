-- Language servers for things installed through mise that no LazyVim lang extra covers.
-- The extras in lazyvim.json handle go, java, python, rust, sql and typescript/javascript.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {},
        templ = {}, -- a-h/templ (mise: go:github.com/a-h/templ/cmd/templ)
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "html", "css", "templ" } },
  },
}
