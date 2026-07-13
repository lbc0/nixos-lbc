{pkgs, ...}: let
  theme = import ./theme.nix;

  rofiThemeFile = pkgs.writeText "rofi-theme.rasi" ''
      * {
        bg:        #${theme.bg};
        bg-alt:    #${theme.bgAlt};
        fg:        #${theme.fg};
        accent:    #${theme.blue};
        urgent:    #${theme.red};

        background-color: transparent;
        text-color:       @fg;
        font:             "${theme.font} ${toString theme.fontSize}";
    }

    window {
        background-color: @bg;
        border:            2px;
        border-color:      @accent;
        border-radius:     8px;
        width:             30%;
    }

    mainbox {
        background-color: @bg;
        children:          [ "inputbar", "listview" ];
        spacing:           8px;
        padding:           12px;
    }

    inputbar {
        background-color: @bg-alt;
        text-color:        @fg;
        padding:           8px;
        border-radius:     4px;
    }

    listview {
        background-color: @bg;
        lines:             8;
        spacing:           4px;
    }

    element {
        background-color: transparent;
        text-color:        @fg;
        padding:           6px;
    }

    element selected {
        background-color: @accent;
        text-color:        @bg;
    }

    element-text {
        background-color: inherit;
        text-color:        inherit;
    }
  '';
in {
  programs.rofi = {
    enable = true;
    theme = "${rofiThemeFile}";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = "Apps: ";
      display-run = "Run: ";
      display-window = "Windows: ";
    };
  };
}
