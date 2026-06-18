{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "rose-pine";
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
    };
  };
}
