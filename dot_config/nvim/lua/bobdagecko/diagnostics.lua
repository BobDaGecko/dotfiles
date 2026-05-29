-- ============================================================================
-- Purpose: Configure diagnostic behavior and provide navigation shortcuts.
-- ============================================================================

vim.diagnostic.config({
  -- Behavioral Controls
  update_in_insert = false,
  severity_sort = true,

  -- Visual Configuration
  float = {
    border = 'rounded',
    source = 'if_many'
  },
  underline = { 
    severity = { min = vim.diagnostic.severity.WARN } 
  },
  virtual_text = true,
  virtual_lines = false,
  
  -- Auto-open float when jumping to an error
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      })
    end,
  },
})
