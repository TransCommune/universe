{ ... }: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "seafile.nullvoid.space" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8083
        '';
      };
    };
  };
}