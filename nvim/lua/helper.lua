H = {}

function H.statusline_path()
  local path = vim.fn.expand("%:p")
  if path == "" then return " [No Name] " end
  return " " .. vim.fn.fnamemodify(path, ":p:h:t") .. "/" .. vim.fn.fnamemodify(path, ":t") .. " "
end

function H.smart_tab_edit(path)
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  local is_empty = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr)) <= 1
  local is_no_name = buf_name == ""
  if is_no_name and is_empty then
    vim.cmd("edit " .. path)
  else
    vim.cmd("tabedit " .. path)
  end
end

return H
