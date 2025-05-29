{...}: {
  services.atticd = {
    enable = true;
    settings = {
      listen = "127.0.0.1:49152";
      allowed-hosts = ["attic.nullvoid.space"];
      api-endpoint = "https://attic.nullvoid.space/";
      storage = {
        type = "local";
        path = "/apps/attic/data";
      };
      database.url = "postgresql:///attic?host=/run/postgresql&user=attic";
    };
    environmentFile = "/etc/attic.env";
  };

  nix.settings = {
    substituters = ["https://attic.nullvoid.space/default"];
    trusted-public-keys = ["default:LZHLvF1j4Aees2xS1uEAN7ZJ/IacERC/77qkSV1G8fw="];
  };
}
