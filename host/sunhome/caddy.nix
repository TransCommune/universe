{ ... }: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "seafile.nullvoid.space" = {
        extraConfig = ''
          encode gzip
          reverse_proxy 127.0.0.1:9093
        '';
      };
    };
  }
}