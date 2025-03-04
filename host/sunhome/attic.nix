{pkgs, ...}: {
  services.atticd = {
    enable = true;
    settings = {
      listen = "127.0.0.1:49152";
      allowed-hosts = ["attic.nullvoid.space"];
      api-endpoint = "https://attic.nullvoid.space/";
      path = "/magpie/apps/attic/data";
    }
    environmentFile = "/etc/attic.env"
  }
}