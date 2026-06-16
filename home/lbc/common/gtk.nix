{pkgs, ...}: {
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark"; # or "Adwaita", "Gruvbox-Dark-BW", etc.
      package = pkgs.gnome-themes-extra; # provides Adwaita-dark
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  # Ensure GTK4 apps also get the theme
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
    };
  };
}
