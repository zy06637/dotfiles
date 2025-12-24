-- WezTerm Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- =============================================================================
-- 外观设置
-- =============================================================================

-- 配色方案: Gruvbox Dark Soft
config.color_scheme = "Gruvbox dark, soft (base16)"

-- 字体设置
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular" })
config.font_size = 14.0
config.line_height = 1.1

-- 窗口设置
config.window_background_opacity = 0.99
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- 初始窗口大小
config.initial_cols = 120
config.initial_rows = 35

-- =============================================================================
-- 标签栏设置
-- =============================================================================

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.tab_max_width = 32

-- 标签栏颜色 (Gruvbox 风格)
config.colors = {
	tab_bar = {
		background = "#32302f",
		active_tab = {
			bg_color = "#504945",
			fg_color = "#ebdbb2",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#32302f",
			fg_color = "#a89984",
		},
		inactive_tab_hover = {
			bg_color = "#3c3836",
			fg_color = "#ebdbb2",
		},
		new_tab = {
			bg_color = "#32302f",
			fg_color = "#a89984",
		},
		new_tab_hover = {
			bg_color = "#504945",
			fg_color = "#ebdbb2",
		},
	},
}

-- =============================================================================
-- 光标设置
-- =============================================================================

config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- =============================================================================
-- 快捷键设置
-- =============================================================================

config.keys = {
	-- 分屏操作
	{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- 窗格导航 (Vim 风格)
	{ key = "h", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },

	-- 调整窗格大小
	{ key = "LeftArrow", mods = "CMD|OPT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "CMD|OPT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "CMD|OPT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "CMD|OPT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

	-- 关闭当前窗格
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	-- 标签页操作
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "]", mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(1) },

	-- 快速切换标签页 (CMD + 数字)
	{ key = "1", mods = "CMD", action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = "CMD", action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = "CMD", action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = "CMD", action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = "CMD", action = wezterm.action.ActivateTab(4) },
	{ key = "6", mods = "CMD", action = wezterm.action.ActivateTab(5) },
	{ key = "7", mods = "CMD", action = wezterm.action.ActivateTab(6) },
	{ key = "8", mods = "CMD", action = wezterm.action.ActivateTab(7) },
	{ key = "9", mods = "CMD", action = wezterm.action.ActivateTab(-1) },

	-- 字体大小调整
	{ key = "=", mods = "CMD", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
	{ key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },

	-- 全屏切换
	{ key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen },

	-- 复制模式 (Vim 风格)
	{ key = "v", mods = "CMD|SHIFT", action = wezterm.action.ActivateCopyMode },

	-- 快速搜索
	{ key = "f", mods = "CMD", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },

	-- 显示启动器
	{ key = "p", mods = "CMD|SHIFT", action = wezterm.action.ShowLauncher },

	-- 重新加载配置
	{ key = "r", mods = "CMD|SHIFT", action = wezterm.action.ReloadConfiguration },

	-- Shift+Enter 发送 ESC+CR (从 ~/.wezterm.lua 合并)
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

-- =============================================================================
-- 性能与行为设置
-- =============================================================================

-- 滚动设置
config.scrollback_lines = 10000
config.enable_scroll_bar = false

-- 更新检查
config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400

-- 关闭确认
config.window_close_confirmation = "NeverPrompt"

-- 超链接检测
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- 添加自定义超链接规则 (匹配文件路径)
table.insert(config.hyperlink_rules, {
	regex = [[["]?([\w\d]{1}[-\w\d]+)(/[-\w\d\.]+)+["]?]],
	format = "$0",
})

-- =============================================================================
-- Shell 设置
-- =============================================================================

-- 默认 shell (macOS 使用 zsh)
config.default_prog = { "/bin/zsh", "-l" }

-- 环境变量
config.set_environment_variables = {
	TERM = "xterm-256color",
}

-- =============================================================================
-- 启动时的工作区设置 (可选)
-- =============================================================================

-- 如果需要启动时自动创建多个窗格，取消下面的注释:
-- wezterm.on("gui-startup", function(cmd)
--     local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
--     pane:split({ direction = "Right", size = 0.4 })
-- end)

return config
