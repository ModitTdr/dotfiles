local statusline = require 'mini.statusline'

-- Material Design inspired color palette for a modern, aesthetic feel
vim.api.nvim_set_hl(0, 'MiniStatuslineSaved', { fg = '#E0E0E0', bg = '#8BC34A', bold = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineModified', { fg = '#E0E0E0', bg = '#FFC107', bold = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { fg = '#616161', bg = 'NONE', italic = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeANormal', { fg = '#212121', bg = '#7CCF35', bold = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeAInsert', { fg = '#212121', bg = '#51A2FF', bold = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeAVisual', { fg = '#212121', bg = '#ED6AFF', bold = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeAReplace', { fg = '#212121', bg = '#F44336', bold = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeACommand', { fg = '#212121', bg = '#FF9800', bold = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeAOther', { fg = '#212121', bg = '#607D8B', bold = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfoA', { fg = '#BDBDBD', bg = 'NONE', italic = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineSeparator', { fg = '#616161', bg = 'NONE', bold = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineTruncate', { fg = '#212121', bg = 'NONE' })

-- Buffer status popup highlight groups (updated with a new theme)
vim.api.nvim_set_hl(0, 'BufferStatusSaved', { fg = '#8BC34A', bg = '#212121', blend = 20, bold = true })
vim.api.nvim_set_hl(0, 'BufferStatusModified', { fg = '#FFC107', bg = '#212121', blend = 20, bold = true })
vim.api.nvim_set_hl(0, 'BufferStatusReadonly', { fg = '#673AB7', bg = '#212121', blend = 20, bold = true })
vim.api.nvim_set_hl(0, 'BufferStatusHeader', { fg = '#E0E0E0', bg = '#424242', blend = 15, bold = true })
vim.api.nvim_set_hl(0, 'BufferStatusBorder', { fg = '#616161', bg = 'NONE' })

-- Rounded corner and minimalist split window separators
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'NONE', bg = 'NONE', bold = false })
vim.api.nvim_set_hl(0, 'VertSplit', { fg = 'NONE', bg = 'NONE', bold = false })
vim.opt.fillchars = {
  vert = ' ',
  horiz = ' ',
  horizup = ' ',
  horizdown = ' ',
  vertleft = ' ',
  vertright = ' ',
  verthoriz = ' ',
  eob = ' ',
  stl = ' ',
  stlnc = ' ',
}

-- Minimalist mode indicator with icons
local function section_mode()
  -- Using a combination of full names and icons for clarity and style
  local mode_map = {
    ['n'] = 'NORMAL ',
    ['i'] = 'INSERT 🖍',
    ['v'] = 'VISUAL ',
    ['V'] = 'VISUAL-LINE ',
    ['\22'] = 'VISUAL-BLOCK ',
    ['c'] = 'COMMAND  ',
    ['R'] = 'REPLACE ',
    ['t'] = 'TERMINAL ',
    ['!'] = 'SHELL  ',
  }
  local mode = vim.fn.mode()
  local mode_str = mode_map[mode] or ' UNKNOWN'
  local hl_map = {
    ['n'] = 'Normal',
    ['i'] = 'Insert',
    ['v'] = 'Visual',
    ['V'] = 'Visual',
    ['\22'] = 'Visual',
    ['c'] = 'Command',
    ['R'] = 'Replace',
    ['t'] = 'Other',
    ['!'] = 'Other',
  }
  local hl = 'MiniStatuslineModeA' .. (hl_map[mode] or 'Other')
  return ' ' .. mode_str .. ' ', hl
end

-- Minimal diagnostics with icons
local function section_diagnostics(args)
  if statusline.is_truncated(args.trunc_width) then
    return ''
  end
  -- Using a more Material-style icon set for diagnostics
  local signs = { ERROR = '●', WARN = '●', INFO = '●', HINT = '●' }
  local diag = statusline.section_diagnostics { signs = signs, icon = '' }
  return diag ~= '' and (' ' .. diag) or ''
end

-- Enhanced LSP section
local function section_lsp(args)
  if statusline.is_truncated(args.trunc_width) then
    return ''
  end
  local lsp = statusline.section_lsp { icon = '' }
  return lsp ~= '' and (' ' .. lsp) or ''
end

-- Clean git section
local function section_git(args)
  if statusline.is_truncated(args.trunc_width) then
    return ''
  end
  local git = statusline.section_git { icon = '' }
  return git ~= '' and (' ' .. git) or ''
end

-- Buffer status popup functionality (unchanged as it's a great feature)
local function get_buffer_status()
  local buffers = {}
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name == '' then
        name = '[No Name]'
      else
        name = vim.fn.fnamemodify(name, ':t')
      end
      local status = 'saved'
      local icon = '✓'
      local hl = 'BufferStatusSaved'
      if vim.bo[buf].modified then
        status = 'modified'
        icon = '●'
        hl = 'BufferStatusModified'
      elseif vim.bo[buf].readonly then
        status = 'readonly'
        icon = '🔒'
        hl = 'BufferStatusReadonly'
      end
      table.insert(buffers, {
        buf = buf,
        name = name,
        status = status,
        icon = icon,
        hl = hl,
        is_current = buf == current_buf,
      })
    end
  end
  return buffers
end

local function section_time(args)
  if statusline.is_truncated(args.trunc_width or 90) then
    return ''
  end
  local time = os.date '%H:%M' -- You can change this to '%I:%M %p' for 12-hour
  return '  ' .. time .. ' '
end

local function show_buffer_status()
  local buffers = get_buffer_status()
  if #buffers == 0 then
    return
  end
  local saved_count = 0
  local modified_count = 0
  local readonly_count = 0
  local max_name_length = 0
  for _, buf in ipairs(buffers) do
    max_name_length = math.max(max_name_length, #buf.name)
    if buf.status == 'saved' then
      saved_count = saved_count + 1
    elseif buf.status == 'modified' then
      modified_count = modified_count + 1
    elseif buf.status == 'readonly' then
      readonly_count = readonly_count + 1
    end
  end
  local width = math.min(math.max(max_name_length + 15, 40), 80)
  local height = math.min(#buffers + 4, 20)
  local lines = {}
  local highlights = {}
  table.insert(lines, ' Buffer Status Overview ')
  table.insert(highlights, { line = 0, col_start = 0, col_end = -1, hl_group = 'BufferStatusHeader' })
  local summary = string.format(' %d saved • %d modified • %d readonly ', saved_count, modified_count, readonly_count)
  table.insert(lines, summary)
  table.insert(highlights, { line = 1, col_start = 0, col_end = -1, hl_group = 'BufferStatusHeader' })
  table.insert(lines, string.rep('─', width - 2))
  for i, buf in ipairs(buffers) do
    local current_marker = buf.is_current and '► ' or '  '
    local line = string.format('%s%s %s', current_marker, buf.icon, buf.name)
    table.insert(lines, line)
    local icon_start = #current_marker
    table.insert(highlights, {
      line = i + 2,
      col_start = icon_start,
      col_end = icon_start + #buf.icon,
      hl_group = buf.hl,
    })
    if buf.is_current then
      table.insert(highlights, {
        line = i + 2,
        col_start = 0,
        col_end = 2,
        hl_group = 'BufferStatusHeader',
      })
    end
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    title = ' Buffers ',
    title_pos = 'center',
  })
  local ns = vim.api.nvim_create_namespace 'buffer_status'
  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(buf, ns, hl.hl_group, hl.line, hl.col_start, hl.col_end)
  end
  vim.api.nvim_win_set_option(win, 'winhighlight', 'Normal:BufferStatusSaved,FloatBorder:BufferStatusBorder')
  local close_events = { 'BufLeave', 'CursorMoved', 'CursorMovedI', 'InsertEnter' }
  local group = vim.api.nvim_create_augroup('BufferStatusFloat', { clear = true })
  for _, event in ipairs(close_events) do
    vim.api.nvim_create_autocmd(event, {
      group = group,
      callback = function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        vim.api.nvim_del_augroup_by_id(group)
      end,
    })
  end
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) then
      vim.keymap.set('n', '<Esc>', function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_del_augroup_by_id(group)
      end, { buffer = buf, nowait = true })
      vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_del_augroup_by_id(group)
      end, { buffer = buf, nowait = true })
      vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
          vim.api.nvim_del_augroup_by_id(group)
        end
      end, 5000)
    end
  end, 100)
end

-- Main setup
statusline.setup {
  use_icons = vim.g.have_nerd_font or false,
  content = {
    active = function()
      local mode, mode_hl = section_mode()
      local git = section_git { trunc_width = 60 }
      local diagnostics = section_diagnostics { trunc_width = 80 }
      local lsp = section_lsp { trunc_width = 70 }
      local time = section_time { trunc_width = 90 }

      return statusline.combine_groups {
        { hl = 'MiniStatuslineDevinfoA', strings = { git } },
        { hl = 'MiniStatuslineDevinfoA', strings = { diagnostics } },
        { hl = 'MiniStatuslineDevinfoA', strings = { lsp } },
        { hl = 'MiniStatuslineTruncate', strings = { '%=' } },
        { hl = 'MiniStatuslineDevinfoA', strings = { time } },
        { hl = mode_hl, strings = { mode } },
      }
    end,
    inactive = function()
      return ''
    end,
  },
}

-- Set up global statusline at bottom
vim.opt.laststatus = 3

-- Key mapping for buffer status
vim.keymap.set('n', '<leader>bs', show_buffer_status, {
  desc = 'Show buffer save status',
  silent = true,
})

vim.keymap.set('n', '<C-S-b>', show_buffer_status, {
  desc = 'Show buffer save status',
  silent = true,
})

return {}
