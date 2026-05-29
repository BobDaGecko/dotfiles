-- =============================================================================
-- SECTION: User Interface & Visuals
-- =============================================================================

-- Enable Nerd Font support for beautiful, consistent glyphs across plugins
-- NOTE: Requires a font that supports glyphs (e.g., JetBrainsMono Nerd Font)
vim.g.have_nerd_font = true

-- Display absolute line number for the current line and relative numbers for others
-- This setup allows for rapid "jump to line" calculations while keeping current line context
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse support for all modes (Normal, Visual, Insert, Command)
-- Allows clicking to position the cursor, dragging to select, and resizing window splits
vim.o.mouse = 'a'

-- Hide the default mode indicator (e.g., -- INSERT --) in the command line
-- Most statusline plugins provide this information, making the core UI cleaner
vim.o.showmode = false

-- Always keep a column on the left side for signs like git changes or LSP markers
-- 'yes' keeps the column visible so your text doesn't shift when diagnostics appear
vim.o.signcolumn = 'yes'

-- Highlight the line currently under the cursor for better visual focus
vim.o.cursorline = true

-- Keep at least 10 lines of buffer above/below the cursor at all times
-- This prevents you from editing at the far edges of your screen, improving ergonomics
vim.o.scrolloff = 10

-- =============================================================================
-- SECTION: Editor Behavior & Performance
-- =============================================================================

-- Sync the Neovim registers with the system clipboard (unnamedplus uses the '+' register)
-- Ensures 'y' and 'p' interact directly with your OS clipboard (Windows/Linux)
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Split new windows to the right and bottom by default, which feels more natural
vim.o.splitright = true
vim.o.splitbelow = true

-- Case-insensitive search unless capital letters are used in the search term
-- Effectively balances standard fuzzy matching with exact, specific searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable visual, incremental feedback for substitution commands (e.g., :s/x/y)
-- The 'split' value shows the changes in a small preview window
vim.o.inccommand = 'split'

-- Prompt for confirmation before quitting modified files
-- Prevents accidental loss of work by surfacing a save-dialogue when you try to close
vim.o.confirm = true

-- =============================================================================
-- SECTION: Technical Tuning
-- =============================================================================

-- Decrease update time (in ms) to make background tasks (GitSigns, LSP diagnostics) feel live
vim.o.updatetime = 250

-- Decrease mapped sequence wait time (in ms)
-- Shortens the wait for multi-key map completions, making commands feel instantaneous
vim.o.timeoutlen = 300

-- Make visual lines respect indentation level so wrapped text remains aligned
vim.o.breakindent = true

-- Persistent undo: Save edit history to disk so undo/redo works after restarting files
vim.o.undofile = true

-- =============================================================================
-- SECTION: Whitespace & Invisibles
-- =============================================================================

-- Enable characters for invisible items and define them in a list
-- Helps you spot weird formatting issues like trailing whitespace or mixed tabs/spaces
vim.o.list = true
vim.opt.listchars = { 
  tab = '» ', 
  trail = '·',
  nbsp = '␣'
}
