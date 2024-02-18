{ ... }: 
{
  services.nginx = {
    enable = true;
    
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

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
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "past.tree1213@cognitive-antivirus.net";
  };
}