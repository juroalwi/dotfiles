local link = require("utils.highlights").link
local copy = require("utils.highlights").copy
local icons = require("utils.icons")

local has_tablineat = vim.fn.has("tablineat")

local M = {}

-- State.
M.buffers = {}          -- Each opened buffer with its UI properties (label, highlighting, etc.).
M.viewport_buffers = {} -- Each displayed buffer with its UI properties (label, highlighting, etc.).
M.tabs = ""             -- String for tabs.
M.config = {
  disabled = false,
  tabpage_section_position = "right", -- Where to show tabpage section in case of multiple vim tabpages. One of 'left', 'right', 'none'.
}

M.update_tabs_section = function()
  local tabs_amount = vim.fn.tabpagenr("$")
  if tabs_amount == 1 or PoiBufferline.config.tabpage_section_position == "none" then
    M.tabs = ""
  else
    M.tabs = string.format(" %s/%s ", vim.fn.tabpagenr(), tabs_amount)
  end
end

M.update_buffers_section = function()
  M.buffers = {}
  local current_buffer_id = vim.api.nvim_get_current_buf()
  for _, buffer_id in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buffer_id].buflisted then
      local buffer = { id = buffer_id }

      -- Label and path (to extend when there are multiple tabs with same label).
      buffer.path = vim.api.nvim_buf_get_name(buffer_id)
      if buffer.path ~= "" then
        buffer.label = vim.fn.fnamemodify(buffer.path, ":t")
      else -- Unnamed buffer.
        local buf_type = vim.bo[buffer_id].buftype
        if buf_type == "quickfix" then
          buffer.label = "Quickfix"
        elseif buf_type == "acwrite" or buf_type == "nofile" then
          buffer.label = "!"
        else
          buffer.label = "*"
        end
      end

      -- Click handler.
      if has_tablineat > 0 then
        buffer["click_handler"] = string.format("%%%d@v:lua.PoiBufferline.switch_buffer@", buffer_id)
      else
        buffer["click_handler"] = ""
      end

      -- Highlighting.
      local highlight
      if buffer_id == current_buffer_id then
        highlight = "PoiBufferlineCurrent"
      elseif vim.fn.bufwinnr(buffer_id) > 0 then
        highlight = "PoiBufferlineVisible"
      else
        highlight = "PoiBufferlineHidden"
      end
      buffer["hl"] = string.format("%%#%s#", highlight)
      table.insert(M.buffers, buffer)
    end
  end
end

M.extend_label = function(path, label)
  -- Add parent directory (if possible) to buffer name.
  -- Using `vim.pesc` prevents effect of problematic characters (like '.').
  local pattern = string.format("[^%s]+%s%s$", vim.pesc("/"), vim.pesc("/"), vim.pesc(label))
  return string.match(path, pattern) or label
end

M.format_buffers_labels = function()
  -- Add parent to repeated buffer labels to differentiate them.
  local repeated_label_buffer_indexes = M.get_repeated_label_buffer_indexes()
  local keep_running = #repeated_label_buffer_indexes > 0
  while keep_running do
    keep_running = false
    for _, buffer_index in ipairs(repeated_label_buffer_indexes) do
      local buffer = M.buffers[buffer_index]
      local old_label = buffer.label
      local new_label = M.extend_label(buffer.path, buffer.label)
      if old_label ~= new_label then
        keep_running = true
        buffer.label = new_label
      end
    end
    repeated_label_buffer_indexes = M.get_repeated_label_buffer_indexes()
    keep_running = #repeated_label_buffer_indexes > 0 and keep_running
  end

  -- Add padding and modified status.
  for _, buffer in ipairs(M.buffers) do
    if vim.bo[buffer.id].modified then
      buffer.label = string.format(" %s %s ", buffer.label, icons.file.MODIFIED)
    else
      buffer.label = string.format(" %s ", buffer.label)
    end
  end
end

M.get_repeated_label_buffer_indexes = function()
  local label_buffer_indexes = {}
  for index, buffer in ipairs(M.buffers) do
    local label = buffer.label
    if label_buffer_indexes[label] == nil then
      label_buffer_indexes[label] = { index }
    else
      table.insert(label_buffer_indexes[label], index)
    end
  end
  return vim.iter(vim.tbl_filter(function(x) return #x > 1 end, label_buffer_indexes))
      :flatten()
      :totable()
end

M.fit_viewport = function()
  -- Bufferline is a list of characters 1,...,n characters given by the concatenation of all buffer labels.
  -- The visible section of it on the screen is the viewport, which size is `viewport_length`.
  -- Its boundaries `viewport_left` and `viewport_right` must satisfy
  -- 1 <= viewport_left < viewport_right, and viewport_right <= n if n >= viewport_length, or viewport_right = viewport_length otherwise.
  -- Variable `offset` is the index on the list of last character from `active_buffer_id` label. We want this buffer
  -- to be displayed in the middle of screen if 1 < viewport_left and viewport_right < n.

  -- Detect active buffer id.
  local active_buffer_id = nil
  local current_buffer_id = vim.api.nvim_get_current_buf()
  if vim.bo[current_buffer_id].buflisted then
    active_buffer_id = current_buffer_id
  end

  -- Register each buffer length and position.
  local offset = 0
  local bufferline_total_length = 0
  for _, buffer in ipairs(M.buffers) do
    buffer.length = vim.api.nvim_strwidth(buffer.label)
    buffer.position = bufferline_total_length + 1
    bufferline_total_length = bufferline_total_length + buffer.length
    if buffer.id == active_buffer_id then
      offset = bufferline_total_length
    end
  end

  -- Compute viewport interval.
  local viewport_left
  local viewport_right
  local viewport_length = vim.o.columns - vim.api.nvim_strwidth(M.tabs)
  local half_viewport_length = math.floor(0.5 * viewport_length)
  if offset + half_viewport_length <= bufferline_total_length then
    viewport_left = offset - half_viewport_length
  else -- This way we avoid whitespace on the rightmost part of viewport when reaching the end of a long bufferline.
    viewport_left = bufferline_total_length - viewport_length
  end
  viewport_left = math.max(1, viewport_left) -- Otherwise it might be viewport_left <= 0.
  viewport_right = viewport_left + viewport_length - 1

  M.truncate_bufferline({ viewport_left, viewport_right })
end

M.truncate_bufferline = function(viewport_interval)
  M.viewport_buffers = {}
  local viewport_left, viewport_right = viewport_interval[1], viewport_interval[2]

  for _, buffer in ipairs(M.buffers) do
    local buffer_left = buffer.position
    local buffer_right = buffer.position + buffer.length - 1
    if (buffer_right >= viewport_left) and (buffer_left <= viewport_right) then
      -- Buffer must be displayed (even partially).
      local left_cut_amount = math.max(0, viewport_left - buffer_left)
      local right_cut_amount = math.max(0, buffer_right - viewport_right)
      buffer.label = vim.fn.strcharpart(buffer.label, left_cut_amount, buffer.length - right_cut_amount)
      table.insert(M.viewport_buffers, buffer)
    end
  end
end

M.build = function()
  local b = {}
  for _, buffer in ipairs(M.viewport_buffers) do
    -- Escape '%' in labels.
    table.insert(b, string.format("%s%s%s", buffer.hl, buffer.click_handler, string.gsub(buffer.label, "%%", "%%%%")))
  end

  -- Usage of `%X` makes filled space to the right 'non-clickable'.
  local result = string.format("%s%%X%%#PoiBufferlineFill#", table.concat(b, ""))

  if M.tabs ~= "" then
    local position = PoiBufferline.config.tabpage_section_position
    if position == "left" then
      result = string.format("%%#PoiBufferlineTab#%s%s", M.tabs, result)
    end
    if position == "right" then
      -- Use `%=` to make it stick to right hand side.
      result = string.format("%s%%=%%#PoiBufferlineTab#%s", result, M.tabs)
    end
  end

  return result
end

PoiBufferline = {
  config = M.config,
  set_colors = function()
    link("TabLine", "Normal")
    link("TabLineFill", "Normal")
    link("TabLineSel", "Normal")
    link("PoiBufferline", "Normal")
    copy("PoiBufferlineCurrent", "PoiAccent", { bold = true, italic = true })
    copy("PoiBufferlineVisible", "PoiAccent")
    copy("PoiBufferlineHidden", "PoiMute")
    copy("PoiBufferlineTab", "PoiMute")
  end,
  build = function()
    if M.config.disabled then
      return ""
    end
    M.update_tabs_section()
    M.update_buffers_section()
    M.format_buffers_labels()
    M.fit_viewport()
    return M.build()
  end,
  switch_buffer = function(id)
    vim.cmd("buffer " .. id)
  end,
}

-- Always show bufferline.
vim.o.showtabline = 2

-- Set bufferline string dinamically (%! char at the beginning).
vim.o.tabline = "%!v:lua.PoiBufferline.build()"

-- Update bufferline colors on each colorscheme change.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PoiBufferlineHighlights", { clear = true }),
  pattern = "PoiHighlightsReady",
  callback = PoiBufferline.set_colors,
})
