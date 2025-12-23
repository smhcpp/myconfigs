vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.timeoutlen = 300
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.signcolumn = 'yes'
vim.o.showtabline = 2
vim.opt.redrawtime = 1500
vim.opt.updatetime = 250
vim.opt.lazyredraw = true
vim.o.winborder = "rounded"

vim.keymap.set("n", "<leader>w", function()
  vim.lsp.buf.format({ async = false })
  vim.cmd("w")
end, { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", ":q!<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gk", "<cmd>tabn<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gj", "<cmd>tabp<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "vl", "V", { noremap = true, silent = true })
vim.keymap.set("n", "vv", "v", { noremap = true, silent = true })
vim.keymap.set("n", "vb", "<C-v>", { noremap = true, silent = true })
vim.keymap.set("n", "va", "ggVG", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sj", ":split | wincmd j<CR>", { silent = true })
vim.keymap.set("n", "<leader>sk", ":split | wincmd k<CR>", { silent = true })
vim.keymap.set("n", "<leader>sl", ":vsplit | wincmd l<CR>", { silent = true })
vim.keymap.set("n", "<leader>sh", ":vsplit | wincmd h<CR>", { silent = true })
vim.keymap.set("n", "<leader>zz", "<C-w>w")
vim.keymap.set("n", "<leader>zh", "<C-w>h")
vim.keymap.set("n", "<leader>zj", "<C-w>j")
vim.keymap.set("n", "<leader>zk", "<C-w>k")
vim.keymap.set("n", "<leader>zl", "<C-w>l")
vim.keymap.set("n", "<C-j>", "7jzz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "7kzz", { noremap = true, silent = true })
vim.keymap.set("i", "<C-j>", "<Esc>10ji", { noremap = true, silent = true })
vim.keymap.set("i", "<C-k>", "<Esc>10ki", { noremap = true, silent = true })
vim.keymap.set("n", "<CR>", "i<CR><ESC>", { noremap = true, silent = true })
vim.keymap.set("n", "<BS>", "i<BS><ESC>l", { noremap = true, silent = true })
vim.keymap.set("n", "<TAB>", "10l", { noremap = true, silent = true })
vim.keymap.set("n", "<S-TAB>", "10h", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gn", function()
  local current_dir = vim.fn.expand("%:p:h")
  vim.cmd("tabnew")
  if current_dir ~= "" and vim.fn.isdirectory(current_dir) == 1 then
    vim.cmd("lcd " .. current_dir)
  end
end)

vim.keymap.set("n", "<leader>tt", function()
  vim.cmd("lcd %:p:h")
  local cmd = [[cmd /q /k "prompt $g & cls"]]
  vim.cmd("botright split | term " .. cmd)
  vim.cmd("startinsert")
end, { silent = true })

vim.keymap.set("n", "<leader>t", function()
  vim.cmd("lcd %:p:h")
  local cmd = [[cmd /q /k "prompt $g & cls"]]
  vim.cmd("vertical botright split | term " .. cmd)
  vim.cmd("startinsert")
end, { silent = true })

vim.keymap.set("n", "<leader>qq", function()
  vim.cmd("mksession! " .. session_path)
  vim.cmd("qa")
end, { silent = true })

vim.keymap.set("n", "<leader>e", function()
  require("oil").open(vim.fn.expand("%:p:h"))
end)
vim.keymap.set('n', '<leader>r', function()
  local root = require("project_nvim.project").get_project_root()
  require("oil").open(root)
end)
vim.keymap.set('n', '<leader>ff', "<cmd>FzfLua files<CR>")
vim.keymap.set('n', '<leader>fp', function()
  require('fzf-lua').files({ cwd = require('project_nvim.project').get_project_root() })
end)
vim.keymap.set('n', '<leader>fg', "<cmd>FzfLua live_grep<CR>")
vim.keymap.set('n', '<leader>/', function()
  helper.smart_tab_edit("$MYVIMRC")
end)
vim.keymap.set('n', '<leader>go', "<cmd>FzfLua lsp_document_symbols<CR>")
vim.keymap.set("n", "J", ":m .+1<CR>==")
vim.keymap.set("n", "K", ":m .-2<CR>== ")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
