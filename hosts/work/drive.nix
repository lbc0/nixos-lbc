{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    davfs2
  ];

  systemd.tmpfiles.rules = [
    "d /mnt/nextcloud 0775 lbc users -"
  ];

  systemd.mounts = [
    {
      enable = true;
      description = "Nextcloud WebDAV mount";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      what = "https://drive.cid-dev.ma/remote.php/dav/files/a.lbouchouari";
      where = "/mnt/nextcloud";
      type = "davfs";
      options = "uid=1000,gid=1000,file_mode=0664,dir_mode=2775";
      mountConfig.TimeoutSec = 15;
    }
  ];

  systemd.automounts = [
    {
      enable = true;
      where = "/mnt/nextcloud";
      automountConfig.TimeoutIdleSec = 60;
    }
  ];

  # SOPS secret for davfs2 credentials
  sops.secrets."nextcloud/webdav" = {
    path = "/etc/davfs2/secrets";
    mode = "0600";
  };
}
