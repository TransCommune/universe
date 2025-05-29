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
      database.url = "postgresql:///attic?host=/run/postgresql";
    };
    environmentFile = "/etc/attic.env";
  };

  nix.settings = {
    substituters = ["https://attic.nullvoid.space/sunhome"];
    trusted-public-keys = ["sunhome:3aBZKTmYovMvwc7Q/l6sVBY4dEKf8qdkOJjCGoGLD1k="];
  };
}
