return {
  {
    "carlos-algms/agentic.nvim",
    --- @type agentic.PartialUserConfig
    opts = {
      -- swap to "opencode-acp" when you want opencode; <localLeader>s to swap mid-session
      provider = "claude-agent-acp",
    },
    keys = {
      { "<C-\\>", function() require("agentic").toggle() end, mode = { "n", "v", "i" }, desc = "Toggle Agentic Chat" },
      { "<C-'>", function() require("agentic").add_selection_or_file_to_context() end, mode = { "n", "v" }, desc = "Add to Agentic Context" },
      { "<C-,>", function() require("agentic").new_session() end, mode = { "n", "v", "i" }, desc = "New Agentic Session" },
      { "<A-i>r", function() require("agentic").restore_session() end, mode = { "n", "v", "i" }, silent = true, desc = "Agentic Restore Session" },
      { "<leader>ad", function() require("agentic").add_current_line_diagnostics() end, mode = { "n" }, desc = "Add Line Diagnostics to Agentic" },
      { "<leader>aD", function() require("agentic").add_buffer_diagnostics() end, mode = { "n" }, desc = "Add Buffer Diagnostics to Agentic" },
    },
  },

  -- render-markdown: include AgenticChat buffers
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante", "AgenticChat" },
    },
    ft = { "markdown", "Avante", "AgenticChat" },
  },

  -- blink.cmp: disable in AgenticInput prompt buffers
  {
    "saghen/blink.cmp",
    opts = {
      enabled = function()
        return not vim.tbl_contains({ "AgenticInput" }, vim.bo.filetype)
      end,
    },
  },

  -- lualine: prevent conflicts with Agentic's custom window decorations
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.disabled_filetypes = opts.options.disabled_filetypes or {}
      local agentic_ft = { "AgenticChat", "AgenticInput", "AgenticCode", "AgenticFiles", "AgenticDiagnostics" }
      opts.options.disabled_filetypes.statusline = vim.list_extend(opts.options.disabled_filetypes.statusline or {}, agentic_ft)
      opts.options.disabled_filetypes.winbar = vim.list_extend(opts.options.disabled_filetypes.winbar or {}, agentic_ft)
      return opts
    end,
  },
}
