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

      -- Added 2024-12-04 to fix a rendering bu
      config.front_end = "WebGpu"

      return config
    '';
  };
}
