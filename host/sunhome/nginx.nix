{ pkgs, ... }: 
{
  systemd.services.nginx.serviceConfig.ReadWritePaths = "/magpie/apps/nginxcache";

  services.nginx = {
    enable = true;
    package = pkgs.nginxStable.override {
      withSlice = true;
    };

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
      proxy_cache_path /magpie/apps/nginxcache/steam levels=2:2 keys_zone=steam:256m max_size=4000g use_temp_path=off loader_files=1000 loader_sleep=50ms loader_threshold=300ms inactive=3650d;
      aio threads;
      proxy_max_temp_file_size 0;
    '';

    eventsConfig = ''
      accept_mutex off;
      worker_connections 1024;
    '';

    appendConfig = ''
      worker_processes auto;
    '';

    virtualHosts."seafile.nullvoid.space" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8083";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 256M;
        '';
      };
    };

    virtualHosts."immich.nullvoid.space" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:2283";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 8G;
        '';
      };
    };

    virtualHosts."89.1.7.228" = {
      rejectSSL = true;
      default = true;
      locations."/" = {
        return = "404";
      };
    };

    virtualHosts."*.steamcontent.com" = {
      rejectSSL = true;
      locations."/" = {
        proxyPass = "http://$host$request_uri";
        extraConfig = ''
          allow 192.168.0.0/16;
          deny all;
          resolver 1.1.1.1 ipv6=off valid=120s;
          proxy_cache steam;
          proxy_cache_key "$request_uri$slice_range";
          slice 1m;
          expires max;
          proxy_cache_valid 301 302 0;
          proxy_cache_lock on;
          proxy_cache_lock_age 2m;
          proxy_cache_lock_timeout 1h;
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "past.tree1213@cognitive-antivirus.net";
  };
}
