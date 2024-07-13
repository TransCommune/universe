{pkgs, ...}: {
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

    commonHttpConfig = ''
      log_format cacheStatus '$host $server_name $server_port $remote_addr $upstream_cache_status $remote_user [$time_local] " $request " '
                       '$status $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';
    '';

    appendHttpConfig = ''
      proxy_cache_path /magpie/apps/nginxcache/steam levels=2:2 keys_zone=steam:256m max_size=4000g use_temp_path=off loader_files=1000 loader_sleep=50ms loader_threshold=300ms inactive=3650d;
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
          proxy_cache_key "$request_uri";
          expires max;
          add_header X-Cache-Status $upstream_cache_status;
          access_log /var/log/nginx/access.steamcache.log cacheStatus;
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "past.tree1213@cognitive-antivirus.net";
  };
}
