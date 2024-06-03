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
      (final: prev: {
        zjstatus = inputs.zjstatus.packages.${prev.system}.default;
      })
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
    fzf
    htop
    tealdeer
    tree
    cheat
    # Use wl-copy and wl-paste to copy/paste in terminal in wayland.
    wl-clipboard
  ];

  # Enable home-manager
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
    # Number of workspaces
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
    # Keyboards
    "org/gnome/desktop/input-sources" = {
      sources =  [(lib.hm.gvariant.mkTuple ["xkb" "us+colemak"])  (lib.hm.gvariant.mkTuple ["xkb" "in+marathi"])];
      mru-sources = [(lib.hm.gvariant.mkTuple ["xkb" "us+colemak"])];
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
    settings = {
      ui.pane_frames = {
        hide_session_name = true;
        rounded_corners = true;
      };
    };
  };

  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
      default_tab_template {
          children
          pane size=1 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                format_left   "{mode}{tabs}"
                // format_center "{tabs}"
                format_right  "{command_git_branch}"
                format_space  ""

                border_enabled  "false"
                border_char     "─"
                border_format   "#[fg=#6C7086]{char}"
                border_position "top"

                hide_frame_for_single_pane "true"

                mode_normal  "#[bg=blue] "
                mode_tmux    "#[bg=#ffc387] "
  
                tab_normal   "#[fg=#6C7086] {name} "
                tab_active   "#[fg=#9399B2,bold,italic] {name} "

                command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                command_git_branch_format      "#[fg=blue] {stdout} "
                command_git_branch_interval    "10"
                command_git_branch_rendermode  "static"
              }
          }
      }
    }
  '';

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Remove greeting from fish.
      set fish_greeting
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
