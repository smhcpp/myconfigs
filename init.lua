--------------------------------
--------------Options-----------
--------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true  -- Enable true color support
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.scrolloff = 10        -- Keep 10 lines when scrolling
vim.opt.shiftwidth = 2        -- Shift 2 spaces when indenting
vim.opt.tabstop = 2           -- 1 tab = 2 spaces
vim.opt.softtabstop = 2       -- Number of spaces per tab in insert mode
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.smartindent = true
vim.opt.incsearch = true      -- Show matches while typing
vim.opt.ignorecase = true     -- Case-insensitive searching
vim.opt.hlsearch = false      -- Disable search highlighting
vim.opt.wrap = true
vim.opt.breakindent = true    -- Keep the indentation for wrapped lines
vim.opt.linebreak = true      -- Don't break words in the middle
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.signcolumn = 'yes'
vim.o.showtabline = 2
vim.o.winborder = "rounded"

vim.keymap.set("n", "<leader>w", function()
  vim.lsp.buf.format({ async = false }) -- run formatter first
  vim.cmd("w")                          -- then save
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", ":q!<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-j>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-u>zz", { noremap = true, silent = true })

-- Buffer management
vim.keymap.set("n", "<leader>bk", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bj", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bb", ":bfirst<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bl", ":blast<CR>", { noremap = true, silent = true })

-- Clipboard operations (unified style)
vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Leader>p", '"+p', { noremap = true, silent = true })

-- Line movement (improved with descriptions)
vim.keymap.set('n', 'K', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', 'J', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('n', '<CR>', 'i<CR><Esc>', { noremap = true })

vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })

-- Tab movements
vim.keymap.set("n", "gn", "<cmd>tabnew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gk", "<cmd>tabn<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gj", "<cmd>tabp<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gs", "^", { noremap = true, silent = true })
vim.keymap.set("n", "ge", "$", { noremap = true, silent = true })

--- Split operations
vim.keymap.set("n", "ze", "<C-w>=")
vim.keymap.set("n", "zz", "<C-w>w")
vim.keymap.set("n", "zh", "<C-w>h")
vim.keymap.set("n", "zj", "<C-w>j")
vim.keymap.set("n", "zk", "<C-w>k")
vim.keymap.set("n", "zl", "<C-w>l")

-- Visual mode
vim.keymap.set("n", "vv", "v")
vim.keymap.set("n", "vl", "V")
vim.keymap.set("n", "vb", "<C-v>")
vim.keymap.set("n", "va", "ggVG")

vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>tt", function()
  if vim.o.showtabline == 2 then
    vim.o.showtabline = 0
  else
    vim.o.showtabline = 2
  end
end, { silent = true, noremap = true })

-- Sessions
vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("mksession! Session.vim")
  end,
})
vim.keymap.set("n", "<leader>sl", ":source Session.vim<CR>", { desc = "Load Session" })
vim.keymap.set("n", "<leader>qq", ":mksession! Session.vim | qa<CR>", { silent = true })

-- Disabling bad keymaps:
--vim.keymap.set("n", "v", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "s", "<Nop>", { silent = true })

-- Split and Move
vim.keymap.set("n", "sj", ":split | wincmd j<CR>", { silent = true })
vim.keymap.set("n", "sk", ":split | wincmd k<CR>", { silent = true })
vim.keymap.set("n", "sl", ":vsplit | wincmd l<CR>", { silent = true })
vim.keymap.set("n", "sh", ":vsplit | wincmd h<CR>", { silent = true })

-- LSP Setup (Neovim 0.12 style)
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/vague2k/vague.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/supermaven-inc/supermaven-nvim' },
})


vim.lsp.config('zls', {
  cmd = { "C:/zig_14/zls.exe" },
  root_markers = { "build.zig", ".git" },
})
vim.lsp.enable('zls')
vim.lsp.enable('lua_ls')
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }

-- requiring the pacs
require('nvim-treesitter').setup({
  ensure_installed = { "zig", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
})
require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<C-l>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-u>",
  },
})
require('fzf-lua').setup({
  -- This makes it look "Modern" with rounded borders
  winopts = {
    height  = 0.85,
    width   = 0.80,
    row     = 0.35,
    col     = 0.50,
    border  = 'rounded',
    preview = {
      layout   = 'vertical', -- 'vertical' or 'horizontal'
      vertical = 'down:45%', -- preview on bottom 45% of window
    },
  },
})
require('mini.completion').setup({
  mappings = {
    force_twostep = '<C-n>',
    force_fallback = '<C-e>',
    scroll_down = '<C-j>',
    scroll_up = '<C-k>',
  },
})
require("oil").setup({
  keymaps = {
    ["q"] = "actions.close",
  },
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', '<leader>w', function()
      local view = vim.fn.winsaveview()
      vim.lsp.buf.format({ bufnr = args.buf, async = false })
      vim.cmd("w")
      vim.fn.winrestview(view)
    end, { buffer = args.buf })
  end,
})

-- Plugin Keymaps:
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>")
vim.keymap.set("n", "<leader>r", vim.lsp.buf.format)
vim.keymap.set('n', '<leader>f', "<cmd>FzfLua files<CR>")
vim.keymap.set('n', '<leader>g', "<cmd>FzfLua live_grep<CR>")
vim.keymap.set('n', 'go', "<cmd>FzfLua lsp_document_symbols<CR>")
--vim.keymap.set('n', '<leader>fb', "<cmd>FzfLua buffers<CR>")
--vim.keymap.set('n', '<leader>fh', "<cmd>FzfLua help_tags<CR>")
vim.cmd("colorscheme vague")
