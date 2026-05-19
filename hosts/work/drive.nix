{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      davfs2
    ];

    etc."davfs2/davfs2.conf" = {
      text = ''
        # davfs2 configuration
      '';
      mode = "0644";
    };
  };

  users = {
    groups.davfs2 = {};

    users.davfs2 = {
      isSystemUser = true;
      group = "davfs2";
    };
  };

  systemd = {
    tmpfiles.rules = [
      "d /mnt/nextcloud 0775 lbc users -"
    ];

    mounts = [
      {
        enable = true;
        description = "Nextcloud WebDAV mount";
        after = ["network-online.target"];
        wants = ["network-online.target"];
        what = "https://drive.cid-dev.ma/remote.php/dav/files/a.lbouchouari";
        where = "/mnt/drive";
        type = "davfs";
        options = "uid=lbc,gid=users,file_mode=0664,dir_mode=2775";
        mountConfig.TimeoutSec = 15;
      }
    ];

    automounts = [
      {
        enable = true;
        where = "/mnt/drive";
        wantedBy = ["multi-user.target"];
        automountConfig.TimeoutIdleSec = 60;
      }
    ];
  };

  # SOPS secret for davfs2 credentials
  sops.secrets."drive/webdav" = {
    path = "/etc/davfs2/secrets";
    mode = "0600";
  };
}
