{pkgs, ...}: {
  services.nginx = {
    enable = true;
    package = pkgs.nginxStable.override {
      withSlice = true;
    };

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      log_format cacheStatus '$host $server_name $server_port $remote_addr $upstream_cache_status $remote_user [$time_local] " $request " '
                       '$status $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';
    '';

    appendHttpConfig = ''
      aio threads;
      proxy_max_temp_file_size 0;
    '';

    eventsConfig = ''
       accept_mutex off;
       worker_connections 2048;
      multi_accept on;
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
      locations."/seafdav" = {
        proxyPass = "http://127.0.0.1:8084/seafdav";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
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

    virtualHosts."jellyfin.nullvoid.space" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 8G;
        '';
      };
    };

    virtualHosts."attic.nullvoid.space" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:49152";
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
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "past.tree1213@cognitive-antivirus.net";
  };
}
