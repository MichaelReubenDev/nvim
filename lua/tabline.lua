-- Simple tabline module for numbered tabs
local M = {}

function M.tabline()
  local s = ''
  local tab_count = vim.fn.tabpagenr('$')
  
  for i = 1, tab_count do
    -- Check if tab page is valid before accessing it
    local tab_valid = pcall(vim.api.nvim_tabpage_is_valid, i)
    if not tab_valid then
      goto continue
    end
    
    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    
    -- Safety check to prevent invalid window access
    if not buflist or #buflist == 0 or winnr > #buflist then
      goto continue
    end
    
    local bufnr = buflist[winnr]
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
      goto continue
    end
    
    local bufname = vim.fn.bufname(bufnr)
    local filename = vim.fn.fnamemodify(bufname, ':t')
    
    -- If no filename, show [No Name]
    if filename == '' then
      filename = '[No Name]'
    end
    
    -- Highlight current tab
    if i == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end
    
    -- Add tab number and filename
    s = s .. ' ' .. i .. ': ' .. filename .. ' '
    
    ::continue::
  end
  
  -- Fill the rest of the tabline
  s = s .. '%#TabLineFill#%T'
  
  return s
end

function M.safe_tabline()
  local ok, result = pcall(M.tabline)
  if ok then
    return result
  else
    return ''
  end
end

return M