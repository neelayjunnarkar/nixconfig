# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "neelay";
    homeDirectory = "/home/neelay";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    ripgrep
    fd
    vscode
    firefox
    fish
    fzf
    htop
    tealdeer
    tree
    cheat
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  dconf.settings = {
    # Pin applications to desktop bar.
    "org/gnome/shell" = {
      favorite-apps = ["firefox.desktop" "org.wezfurlong.wezterm.desktop" "code.desktop"];
    };
    # Setup shortcuts for switching workspaces
    # and moving windows between workspaces.
    "org/gnome/shell/extensions/dash-to-dock" = {
      hot-keys = false;
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      move-to-workspace-1 = ["<Shift><Super>1"];
      move-to-workspace-2 = ["<Shift><Super>2"];
      move-to-workspace-3 = ["<Shift><Super>3"];
      move-to-workspace-4 = ["<Shift><Super>4"];
      move-to-workspace-5 = ["<Shift><Super>5"];
      move-to-workspace-6 = ["<Shift><Super>6"];
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 5;
    };
    # Swap control and caps lock.
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["ctrl:swapcaps"];
    };
    # Setup browser shortcut.
    "org/gnome/settings-daemon/plugins/media-keys" = {
      www = ["<Shift><Super>Return"];
    };
    # Setup custom shortcuts.
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
      binding = "<Super>Return";
      command = "wezterm start --always-new-process zellij";
      name = "Terminal";
    };
  };

  programs.git = {
    enable = true;
    userName = "Neelay";
    userEmail = "neelay.junnarkar@gmail.com";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set rnu

      set shiftwidth=4 smarttab
      set expandtab
      set tabstop=8 softtabstop=0
    '';
  };

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

      config.color_scheme = 'Gruvbox dark, hard (base16)'
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

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
