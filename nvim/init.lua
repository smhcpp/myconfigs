_G.session_path = "C:/Users/judimer/Documents/Session.vim"
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>o", function()
  vim.cmd("update")
  if vim.bo.filetype == "lua" then
    vim.cmd("source %")
    print("Config reloaded!")
  else
    print("Saved (Not a config file)")
  end
end)
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/rmagatti/auto-session' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/ahmedkhalf/project.nvim' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/vague2k/vague.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/supermaven-inc/supermaven-nvim' },
  { src = 'https://github.com/hrsh7th/nvim-cmp' },     -- The engine
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' }, -- LSP source
  { src = 'https://github.com/hrsh7th/cmp-buffer' },   -- Text in current buffer source
  { src = 'https://github.com/hrsh7th/cmp-path' },     -- File paths source
  { src = 'https://github.com/L3MON4D3/LuaSnip' },
  { src = 'https://github.com/akinsho/bufferline.nvim' },
})

vim.filetype.add({ extension = { wgsl = "wgsl" } })

vim.lsp.config('zls', {
  cmd = { "C:/zig_14/zls.exe" },
  root_markers = { "build.zig", ".git" },
})
vim.lsp.config('wgsl_analyzer', {
  cmd = { "C:/wgsl_analyzer/wgsl_analyzer.exe" },
  filetypes = { "wgsl" },
  root_markers = { ".git", "build.zig" },
})
vim.lsp.config('rust_analyzer', {
  cmd = { "rust-analyzer" }, -- If it's in your PATH
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy", -- Use clippy for better error checking on save
      },
    },
  },
})
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('wgsl_analyzer')
vim.lsp.enable('zls')
vim.lsp.enable('lua_ls')

require('nvim-treesitter.install').compilers = { "clang", "gcc" }
local ok, ts = pcall(require, "nvim-treesitter.configs")
if ok then
  ts.setup({
    ensure_installed = { "rust", "glsl", "c", "zig", "lua", "wgsl", "vimdoc" },
    highlight        = { enable = true },
    indent           = { enable = true },
    sync_install     = true,
  })
end
--------------------------------------------------------------------------------
-- 6. ADDITIONAL PLUGIN SETUP & UI
--------------------------------------------------------------------------------
require("supermaven-nvim").setup({
  keymaps = { accept_suggestion = "<C-l>", clear_suggestion = "<C-]>", accept_word = "<C-u>" },
})
require("auto-session").setup({
  log_level = "error",
  auto_restore_enabled = true,
  auto_session_suppress_dirs = { "~/", "C:/", "C:/Users/judimer/Documents" },
  session_lens = {
    load_on_setup = true,
  },
})
require("project_nvim").setup({
  detection_methods = { "pattern" },
  patterns = { ".git", "build.zig", "Cargo.toml", "package.json" },
  exclude_dirs = { "~/.config/*", "C:/Users/judimer/AppData/Local/nvim/*" },
  manual_mode = false,
})
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    -- This adds the rounded borders and documentation window
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Esc>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept completion with Enter
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- High priority: LSP info
    { name = 'luasnip' },
  }, {
    { name = 'buffer' }, -- Lower priority: Text in file
    { name = 'path' },   -- File paths
  })
})
require("bufferline").setup({
  options = {
    mode = "tabs",            -- Use "tabs" if you like the native tab behavior
    show_buffer_icons = true, -- Removes the icons you didn't like
    show_buffer_close_icons = false,
    show_close_icon = false,
    indicator = { style = 'none' },
    separator_style = "thin", -- Clean vertical lines between tabs
    offsets = {
      {
        filetype = "oil",
        text = "File Explorer",
        text_align = "left",
        separator = true
      }
    }
  }
})
require('fzf-lua').setup({
  winopts = { height = 0.85, width = 0.80, border = 'rounded', preview = { layout = 'vertical', vertical = 'down:45%' } },
})
require("oil").setup({ keymaps = { ["q"] = "actions.close" }, default_file_explorer = true })

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

_G.helper = require("helper")
require("basics")
local icons_ok, devicons = pcall(require, "nvim-web-devicons")
if icons_ok then
  devicons.setup({ default = true })
end
vim.opt.statusline = "%{v:lua.helper.statusline_path()}%m %= %l:%c "
vim.cmd("colorscheme vague")
