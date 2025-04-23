-- Pull in the APIs
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

config.front_end = "WebGpu"

config.initial_rows = 50
config.initial_cols = 120

config.set_environment_variables = {
	XDG_CONFIG_HOME = "/Users/jimmie/.config",
}
-- Spawn a nu shell in login mode
config.default_prog = { "/run/current-system/sw/bin/nu", "-l" }

-- Colors
config.color_scheme = "Tokyo Night"
config.colors = {
	background = "#282c34",
}

-- Fonts
config.font_size = 13.0
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = 500 })

-- Behavior
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
-- config.use_dead_keys = false
config.scrollback_lines = 5000

config.inactive_pane_hsb = {
	saturation = 0.3,
	brightness = 0.5,
}

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, _)
	local name = window:active_key_table()
	if name then
		name = "Layer: " .. name .. " "
	end
	window:set_right_status(name or "Layer: Base ")
end)

config.disable_default_key_bindings = false
config.leader = { key = "Space", mods = "CMD", timeout_milliseconds = 1500 }

config.keys = {
	-- Panes Navigation
	{ key = "UpArrow", mods = "CMD", action = act.ActivatePaneDirection("Up") },
	{ key = "k", mods = "CMD", action = act.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CMD", action = act.ActivatePaneDirection("Down") },
	{ key = "j", mods = "CMD", action = act.ActivatePaneDirection("Down") },
	{ key = "LeftArrow", mods = "CMD", action = act.ActivatePaneDirection("Left") },
	{ key = "h", mods = "CMD", action = act.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CMD", action = act.ActivatePaneDirection("Right") },
	{ key = "l", mods = "CMD", action = act.ActivatePaneDirection("Right") },
	{ key = "Space", mods = "LEADER", action = act.PaneSelect },

	-- Create Panes
	{
		key = "UpArrow",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Up",
		}),
	},
	{
		key = "k",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Up",
		}),
	},
	{
		key = "DownArrow",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Down",
		}),
	},
	{
		key = "j",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Down",
		}),
	},

	{
		key = "RightArrow",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "l",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "LeftArrow",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Left",
		}),
	},
	{
		key = "h",
		mods = "CMD|SHIFT",
		action = act.SplitPane({
			direction = "Left",
		}),
	},

	-- Resize Panes
	{
		key = "UpArrow",
		mods = "CMD|ALT",
		action = act.AdjustPaneSize({
			"Up",
			1,
		}),
	},
	{
		key = "DownArrow",
		mods = "CMD|ALT",
		action = act.AdjustPaneSize({
			"Down",
			1,
		}),
	},
	{
		key = "RightArrow",
		mods = "CMD|ALT",
		action = act.AdjustPaneSize({
			"Right",
			1,
		}),
	},
	{
		key = "LeftArrow",
		mods = "CMD|ALT",
		action = act.AdjustPaneSize({
			"Left",
			1,
		}),
	},

	--  Tab Navigation
	{ key = "RightArrow", mods = "CMD|CTRL", action = act.ActivateTabRelative(1) },
	{ key = "l", mods = "CMD|CTRL", action = act.ActivateTabRelative(1) },
	{ key = "LeftArrow", mods = "CMD|CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "h", mods = "CMD|CTRL", action = act.ActivateTabRelative(-1) },

	{
		key = "n",
		mods = "LEADER",
		action = act.SplitVertical({}),
	},
	-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{
		key = "p",
		mods = "CMD",
		action = act.ActivateKeyTable({
			name = "panes",
		}),
	},

	{
		key = "r",
		mods = "CMD",
		action = act.ActivateKeyTable({
			name = "resize",
			one_shot = false,
		}),
	},

	{
		key = "t",
		mods = "CMD",
		action = act.ActivateKeyTable({
			name = "tabs",
		}),
	},
	{
		key = "Enter",
		mods = "ALT",
		action = "DisableDefaultAssignment",
	},
}

config.key_tables = {
	panes = {
		{ key = "p", action = act.PaneSelect },
		{ key = "Escape", action = act.PopKeyTable },
		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "Enter", action = act.PopKeyTable },

		{
			key = "d",
			action = act.CloseCurrentPane({ confirm = true }),
		},

		{
			-- For Homerow Mod
			key = "f",
			action = act.TogglePaneZoomState,
		},
		{
			key = "z",
			action = act.TogglePaneZoomState,
		},
	},

	resize = {
		-- Resize Panes
		{ key = "UpArrow", action = act.AdjustPaneSize({
			"Up",
			1,
		}) },
		{ key = "DownArrow", action = act.AdjustPaneSize({
			"Down",
			1,
		}) },
		{ key = "RightArrow", action = act.AdjustPaneSize({
			"Right",
			1,
		}) },
		{ key = "LeftArrow", action = act.AdjustPaneSize({
			"Left",
			1,
		}) },
		{ key = "Escape", action = act.PopKeyTable },
		{ key = "Enter", action = act.PopKeyTable },
	},

	tabs = {
		{
			key = "r",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, _, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		{ key = "n", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "t", action = act.ShowTabNavigator },
		{ key = "d", action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "Escape", action = act.PopKeyTable },
		{ key = "Enter", action = act.PopKeyTable },
	},
}

-- return config
return config
