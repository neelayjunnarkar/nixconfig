{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local mux = wezterm.mux

      --wezterm.on('gui-attached', function(domain)
      --  -- maximize all displayed windows on startup
      --  local workspace = mux.get_active_workspace()
      --  for _, window in ipairs(mux.all_windows()) do
      --    if window:get_workspace() == workspace then
      --      window:gui_window():maximize()
      --    end
      --  end
      --end)

      wezterm.on('gui-startup', function(cmd)
        local tab, pane, window = mux.spawn_window(cmd or {})
        window:gui_window():maximize()
      end)

      local config = wezterm.config_builder()

      config.enable_tab_bar = false

      config.window_background_opacity = 0.9
      config.window_decorations = "RESIZE"

      config.xcursor_size = nil
      config.xcursor_theme = nil

      local success, stdout, stderr = wezterm.run_child_process({"gsettings", "get", "org.gnome.desktop.interface", "cursor-theme"})
      if success then
        config.xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
      end

      local success, stdout, stderr = wezterm.run_child_process({"gsettings", "get", "org.gnome.desktop.interface", "cursor-size"})
      if success then
        config.xcursor_size = tonumber(stdout)
      end

      return config
    '';
  };
}
