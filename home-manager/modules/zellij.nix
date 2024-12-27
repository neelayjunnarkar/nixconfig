{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    # enableFishIntegration = true;
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
                format_center ""
                format_right  ""
                format_space  ""

                border_enabled  "false"
                border_char     "─"
                border_format   "#[fg=#6C7086]{char}"
                border_position "top"

                hide_frame_for_single_pane "true"

                mode_normal  "#[fg=green]●︎"
                mode_tmux    "#[fg=red]●︎"

                tab_normal   "#[fg=#bfbdb6] {index} "
                tab_active   "#[fg=#e6e1cf,bold,italic] {index} "
              }
          }
      }
    }
  '';
}
