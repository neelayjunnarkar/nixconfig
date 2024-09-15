{lib, ...}: {
  dconf.settings = {
    # Pin applications to desktop bar.
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.wezfurlong.wezterm.desktop"
        "code.desktop"
        "org.gnome.Nautilus.desktop"
      ];
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
      # Alt-tab for switching windows, not applications
      cycle-windows = ["<Alt>Tab"];
      cycle-windows-backward = ["<Shift><Alt>Tab"];
      switch-applications = [];
      switch-applications-backward = [];
      # Screenshot
      show-screenshot-ui = ["<Shift><Super>s"];
    };
    # Number of workspaces
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 5;
    };
    # Enable drag windows to side/top to semi-/maximize.
    "org/gnome/mutter" = {
      edge-tiling = true;
    };
    # Swap control and caps lock.
    "org/gnome/desktop/input-sources" = {
       # xkb-options = ["ctrl:swapcaps"];
       xkb-options = ["ctrl:nocaps"];
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
      sources =  [
        (lib.hm.gvariant.mkTuple ["xkb" "us"])
        (lib.hm.gvariant.mkTuple ["xkb" "us+colemak_dh_ortho"])
        (lib.hm.gvariant.mkTuple ["xkb" "in+marathi"])
      ];
      # TODO: What is mru-sources?
      mru-sources = [(lib.hm.gvariant.mkTuple ["xkb" "us"])];
    };
    # Disable mouse acceleration
    "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.6;
      accel-profile = "flat";
    };
  };
}
