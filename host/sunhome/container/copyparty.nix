{config, lib, ...}: {
  environment.etc = {
    "copyparty.d/mounts.cfg" = {
      text = ''
        [global]
          e2ds  # index files on startup and upload
          e2ts  # scan files for media tags on startup and upload

        [/media]
          /mnt/media
          accs:
            r: *
      '';
      mode = "0644";
    };
  };

  virtualisation.quadlet.containers.copyparty = {
    containerConfig = {
      name = "copyparty";
      image = "ghcr.io/9001/copyparty-ac:latest";
      volumes = [
        "/etc/copyparty.d:/cfg:U"
        "/magpie/media:/mnt/media"
      ];
      publishPorts = [
        "3923:3923/tcp"
      ];
      user = toString config.users.users.nas.uid;
      group = toString config.users.groups.nas.gid;
    };
    unitConfig = {
      After = ["magpie.target"];
      Wants = ["magpie.target"];
      RequiresMountsFor = [
        "/magpie/media"
      ];
    };
  };
}
