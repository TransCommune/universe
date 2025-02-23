{...}: {
  virtualisation.quadlet.containers.unifi = {
    unitConfig = {
      After = ["magpie.target"];
      Wants = ["magpie.target"];
      RequiresMountsFor = [
        "/magpie/apps/unifi"
      ];
    };

    containerConfig = {
      image = "docker.io/jacobalberty/unifi:v9";
      environments.TZ = "Europe/Amsterdam";
      user = "unifi";
      volumes = [
        "/magpie/apps/unifi:/unifi:U"
      ];
      podmanArgs = ["--network=host"];
    };
  };
}
