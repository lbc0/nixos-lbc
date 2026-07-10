{pkgs, ...}: let
  theme = import ./theme.nix;
in {
  programs.rofi = {
    enable = true;
    theme = pkgs.writeText "rofi-theme.rasi" ''
      * {
          background:     #${theme.bg};
          background-alt: #${theme.bgAlt};
          foreground:     #${theme.fg};
          accent:         #${theme.blue};
          urgent:         #${theme.red};
          font:           "${theme.font} ${toString theme.fontSize}";
      }
      window {
          background-color: @background;
          border: 2px;
          border-color: @accent;
          border-radius: 8px;
          width: 30%;
      }
      inputbar {
          background-color: @background-alt;
          text-color: @foreground;
          padding: 8px;
      }
      element selected {
          background-color: @accent;
          text-color: @background;
      }
    '';
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
    };
  };
}
