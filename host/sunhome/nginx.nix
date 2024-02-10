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
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "past.tree1213@cognitive-antivirus.net";
  };
}