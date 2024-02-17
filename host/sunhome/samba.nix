{ ... }: {
  systemd.targets.samba = {
    after = [ "magpie.target" ];
    requires = [ "magpie.target" ];
  };

  services.samba = {
    enable = true;
    openFirewall = true;

    extraConfig = ''
      server string = sunhome
      workgroup = TRANSCOMMUNE

      guest account = nobody
      map to guest = bad user

      use sendfile = yes
      min receivefile size = 16384

      aio read size = 16384
      aio write size = 16384

      vfs objects = catia fruit streams_xattr

      fruit:nfs_aces = no
      fruit:resource = xattr
      fruit:metadata = stream
      fruit:encoding = native
    '';

    shares = {
      media = {
        path = "/magpie/media";
        browseable = true;
        writeable = true;
        "force user" = "nobody";
        "force group" = "nobody";
        "valid users" = "aurelia sapphiccode";
        "create mask" = "0660";
        "directory mask" = "0770";
        "force create mode" = "0660";
        "force directory mode" = "0770";
      };
      media_ro = {
        path = "/magpie/media";
        browseable = true;
        "read only" = true;
        "force user" = "nobody";
        "force group" = "nobody";
        "guest ok" = true;
        "guest only" = true;
      };

      aurelia = {
        path = "/magpie/aurelia/scratch";
        browseable = true;
        writable = true;
        "valid users" = "aurelia";
        "force group" = "users";
        "force create mode" = "0660";
        "force directory mode" = "0770";
      };
      aurelia_timemachine = {
        path = "/magpie/aurelia/tm-personal";
        browseable = true;
        writable = true;
        "valid users" = "aurelia";
        "force group" = "users";
        "force create mode" = "0660";
        "force directory mode" = "0770";

        "fruit:time machine" = true;
        "fruit:time machine max size" = "1T";
      };
      aurelia_macrium = {
        path = "/magpie/aurelia/macrium";
        browseable = true;
        writable = true;
        "valid users" = "aurelia";
        "force group" = "users";
        "force create mode" = "0660";
        "force directory mode" = "0770";
      };

      phoenix = {
        path = "/magpie/phoenix/personal";
        browseable = true;
        writable = true;
        "valid users" = "sapphiccode";
        "force group" = "users";
      };
    };
  };
}
