{...}: {
  virtualisation.quadlet.containers.unifi = {
    unitConfig = {
      RequiresMountsFor = [
        "/apps/unifi"
      ];
    };

    containerConfig = {
      image = "docker.io/jacobalberty/unifi:v9";
      environments.TZ = "Europe/Amsterdam";
      user = "unifi";
      volumes = [
        "/apps/unifi:/unifi:U"
      ];
      podmanArgs = ["--network=host"];
    };
  };
}
