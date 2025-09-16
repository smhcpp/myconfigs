--------------Options-----------
--------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true   -- Enable true color support
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.scrolloff = 10         -- Keep 10 lines when scrolling
vim.opt.shiftwidth = 2         -- Shift 2 spaces when indenting
vim.opt.tabstop = 2            -- 1 tab = 2 spaces
vim.opt.softtabstop = 2        -- Number of spaces per tab in insert mode
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.smarttab = true 
vim.opt.smartindent = true
vim.opt.incsearch = true       -- Show matches while typing
vim.opt.ignorecase = true      -- Case-insensitive searching
vim.opt.hlsearch = false       -- Disable search highlighting
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.signcolumn = 'yes'
vim.o.showtabline = 2
--------------------------------
----------Loading Lazy----------
--------------------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { 
      "catppuccin/nvim", 
      name = "catppuccin", 
      priority = 1000 
    },
    {
      "akinsho/toggleterm.nvim", -- Better terminal
      config = function()
        require("toggleterm").setup()
        vim.keymap.set("n", "<leader>,", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
      end
    },
    {
      'lervag/vimtex',
      ft = 'tex', -- Only load for LaTeX files
      config = function()
        vim.g.vimtex_view_method = 'zathura' -- PDF viewer (change to 'skim' on macOS)
        vim.g.vimtex_compiler_method = 'latexmk' -- Default compiler
        vim.g.vimtex_syntax_enabled = 1 -- Enhanced syntax highlighting
        vim.g.vimtex_view_forward_search_on_start = 1  -- Auto-open PDF
        vim.g.vimtex_view_automatic = 1  
      end
    },   
    {
      "lewis6991/gitsigns.nvim",
      config = true,
      event = "BufReadPre",
    },
    {
      "tpope/vim-fugitive",
      cmd = { "Git", "Gdiffsplit", "Gclog" },
    },
    {
      "sindrets/diffview.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      cmd = { "DiffviewOpen", "DiffviewClose" },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      opts = {
        ensure_installed = { "lua", "python", "zig", "c", "bash" },
        highlight = { enable = true },
        indent = { enable = true },
      },
    },
    {
      "neovim/nvim-lspconfig"
    },
    {
      "hrsh7th/cmp-nvim-lsp"
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "L3MON4D3/LuaSnip",  -- Add snippet support
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets"
      }
    },
    {
      "williamboman/mason.nvim",
      config = true
    },
    {
      "williamboman/mason-lspconfig.nvim"  -- Bridge between Mason and LSPConfig
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      }
    },
    {
      "rmagatti/auto-session",
      config = function()
        local auto_session = require("auto-session")

        auto_session.setup({
          auto_restore_enabled = false,
          auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
        })

        local keymap = vim.keymap
        -- dont use zh, zv, zx, zn.
        keymap.set("n", "<leader>zr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
        keymap.set("n", "<leader>zs", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
      end,
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
          defaults = {
            path_display = { "smart" },
            mappings = {
              i = {
                ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                ["<C-j>"] = actions.move_selection_next, -- move to next result
                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              },
            },
          },
        })

        telescope.load_extension("fzf")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fg", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = { "InsertEnter" },
      dependencies = {
        "hrsh7th/nvim-cmp",
      },
      config = function()
        -- import nvim-autopairs
        local autopairs = require("nvim-autopairs")

        -- configure autopairs
        autopairs.setup({
          check_ts = true, -- enable treesitter
          ts_config = {
            lua = { "string" }, -- don't add pairs in lua string treesitter nodes
            javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
            java = false, -- don't check treesitter on java
          },
        })

        -- import nvim-autopairs completion functionality
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        -- import nvim-cmp plugin (completions plugin)
        local cmp = require("cmp")

        -- make autopairs and completion work together
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
    {
      'numToStr/Comment.nvim',
      config = true, -- Automatic configuration
      keys = { -- Lazy-load the plugin when these keys are pressed
        { "<leader>/", desc = "Toggle comment" },
        { "<leader>/", mode = "v", desc = "Toggle comment" },
      }
    },
  },
  install = { colorscheme = { "catppuccin" } },  -- Changed to match your config
})

--------------------------------
---------Loading Plugins--------
--------------------------------

require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,      -- Show dotfiles (hidden files)
      hide_gitignored = false,    -- Show gitignored files
      hide_hidden = false,        -- Show truly hidden files
      visible = true,             -- Make hidden items visible by default
      never_show = {              -- Exclude these patterns (even when visible=true)
        ".git",
        ".DS_Store",
        "thumbs.db"
      }
    },
    follow_current_file = {
      enabled = true,             -- Auto-reveal files from hidden dirs
    },
    window = {
      width =30,  -- Set fixed width (default is 40)
      -- OR for dynamic sizing:
      max_width = 35,  -- Maximum expandable width
      min_width = 25,  -- Minimum collapsible width
      auto_expand_width = false,  -- Prevent auto-resizing
      mappings = {
        ["<cr>"] = "open",        -- Enter key opens files or directories
        ["l"] = "open",           -- 'l' key also opens files or directories
        ["c"] = "close_node",     -- 'h' key collapses the current directory
        ["h"] = "navigate_up",    -- 'P' key navigates up to the parent directory
        -- Add other mappings as needed
      },
    },
    -- Other filesystem configurations
  },
  -- Other Neo-tree configurations

})

require('lualine').setup()

-- Basic configuration (add anywhere after Lazy setup)
require('Comment').setup({
  toggler = {
    line = '<leader>/', -- Toggle line comment
  },
  opleader = {
    line = '<leader>/', -- Toggle line comment
  },
  -- For visual mode mapping
  mappings = {
    basic = true,
    extra = false
  }
})

-- Configure Gitsigns (line decorations)
require('gitsigns').setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
})

-- LSP Setup
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "zls" }  -- Add your desired LSP servers
})

local lspconfig = require("lspconfig")
local cmp = require("cmp")

-- Setup nvim-cmp
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
    ['<C-h>'] = cmp.mapping.abort(),  
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- LSP keymaps
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "<leader>lbd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>lbh", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>lws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>ln", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>lrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<leader>lh", vim.lsp.buf.signature_help, opts)
end

-- Consolidated LSP server setup
local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if server == "texlab" then
    opts.settings = {
      texlab = {
        build = {
          args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        },
        forwardSearch = {
          executable = "zathura",
          args = { "--synctex-forward", "%l:1:%f", "%p" },
        },
      },
    }
  elseif server == "zls" then
    opts.cmd = { "/usr/bin/zls" }
  elseif server == "lua_ls" then
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    }
  end

  lspconfig[server].setup(opts)
end

--------------------------------
----------Mapping Keys----------
--------------------------------

-- General file operations
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", ":q!<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })

-- Buffer management
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bf", ":bfirst<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bl", ":blast<CR>", { noremap = true, silent = true })

-- Clipboard operations (unified style)
vim.keymap.set({"n", "v"}, "<Leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>p", '"+p', { noremap = true, silent = true })

-- Line movement (improved with descriptions)
vim.keymap.set('n', 'K', ':m .-2<CR>==', { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set('n', 'J', ':m .+1<CR>==', { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })

-- Tab movements
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { noremap = true, silent = true, desc = "Open new tab" }) -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { noremap = true, silent = true, desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { noremap = true, silent = true, desc = "Go to next tab" }) -- go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { noremap = true, silent = true, desc = "Go to previous tab" }) -- go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { noremap = true, silent = true, desc = "Open current buffer in new tab" }) -- move current buffer to new tab

-- Vimtex keys
vim.keymap.set('n', '<leader>vc', '<cmd>VimtexCompile<CR>', { desc = "LaTeX Compile" })
vim.keymap.set('n', '<leader>vv', '<cmd>VimtexView<CR>', { desc = "View PDF" })
vim.keymap.set('n', '<leader>vt', '<cmd>VimtexTocToggle<CR>', { desc = "Toggle TOC" })

-- Split operations  do not use zr, zs -> for session management.
vim.keymap.set("n", "<leader>zv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>zh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>ze", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
vim.keymap.set("n", "<leader>zx", "<cmd>close<CR>", { desc = "Close current split" }) 
vim.keymap.set("n", "<leader>zz", "<C-w>w", { desc = "Cycle through open splits" }) -- split window vertically

-- Key mappings
vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>gl", "<cmd>Gclog<CR>", { desc = "Git log" })
vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
vim.keymap.set("n", "[c", function() require('gitsigns').prev_hunk() end)
vim.keymap.set("n", "]c", function() require('gitsigns').next_hunk() end)

-- Visual mode reconfiguration:
vim.keymap.set('n', 'vv', 'v', { noremap = true })
vim.keymap.set('n', 'vl', 'V', { noremap = true })
vim.keymap.set('n', 'vb', '<C-v>', { noremap = true })
vim.keymap.set('n', 'v', '<Nop>', { noremap = true })
vim.keymap.set('n', 'V', '<Nop>', { noremap = true })
vim.keymap.set('n', '<C-v>', '<Nop>', { noremap = true })

-- Diffview commands
vim.keymap.set("n", "<leader>gv", "<cmd>DiffviewOpen<CR>", { desc = "View diffs" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diff view" })

vim.keymap.set("n", "<leader>tt", function()
    if vim.o.showtabline == 2 then
        vim.o.showtabline = 0
    else
        vim.o.showtabline = 2
    end
end, { silent = true, noremap = true, desc = "Toggle Tab Bar" })

-- Enhanced keymaps (optional but recommended)
vim.keymap.set({'n', 'v'}, '<leader>/', function()
  require('Comment.api').toggle.linewise.current()
end, { desc = "Toggle comment" })

-- For block comments (optional)
vim.keymap.set('v', '<leader>b', function()
  require('Comment.api').toggle.blockwise(vim.fn.visualmode())
end, { desc = "Toggle block comment" })

-- Enter Functionality
vim.keymap.set('n', '<CR>', 'i<CR><Esc>', { noremap = true, desc = "Insert new line and return to normal mode" })


vim.cmd.colorscheme("catppuccin")
