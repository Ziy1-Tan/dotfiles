local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font 'SauceCodePro Nerd Font'
config.font_size = 20
config.initial_cols = 120
config.initial_rows = 32
config.tab_bar_at_bottom = true

-- 启用标签栏
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

-- 自动更名标签页：显示 程序名 | 当前目录
wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local title = pane.title()

  -- 尝试获取当前命令
  local proc = ''
  if tab.is_zoomed then
    proc = '【ZOOM】'
  end

  -- 获取当前工作目录（简化显示）
  local cwd = pane.current_working_dir
  local dir = ''
  if cwd then
    -- 取目录名而非完整路径
    dir = cwd:gsub('.*/', '')
    if dir == '' then dir = '/' end
  end

  -- 组合显示
  local label = ''
  if title and title ~= '' then
    label = title .. ' | ' .. dir
  else
    label = dir
  end

  return wezterm.format {
    { Text = ' ' .. label .. ' ' },
  }
end)

return config
