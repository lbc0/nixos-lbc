{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Nordic-cursors";
      package = pkgs.nordic;
      size = 24;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Nordic";
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
    };
  };
}
