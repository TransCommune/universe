{ ... }: 
{
  services.nginx = {
    enable = true;
    
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
      proxy_cache_path /magpie/apps/nginxcache levels=1:2 keys_zone=steam:256m max_size=2000g inactive=365d use_temp_path=off;
      
      # Cache only success status codes; in particular we don't want to cache 404s.
      # See https://serverfault.com/a/690258/128321
      map $status $cache_header {
        200     "public";
        302     "public";
        default "no-cache";
      }
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
          deny all;
          allow 192.168.0.0/16;
          resolver 1.1.1.1;
          proxy_cache steam;
          proxy_cache_valid  200 302  60d;
          expires max;
          add_header Cache-Control $cache_header always;
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "past.tree1213@cognitive-antivirus.net";
  };
}
