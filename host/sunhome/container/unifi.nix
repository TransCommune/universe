{ ... }: {
  virtualisation.quadlet.containers.unifi = {
    unitConfig = {
      After = [ "magpie.target" ];
      Wants = [ "magpie.target" ];
      RequiresMountsFor = [
        "/magpie/apps/unifi"
      ];
    };

    containerConfig = {
      image = "docker.io/jacobalberty/unifi:v8";
      environments.TZ = "Europe/Amsterdam";
      user = "unifi";
      volumes = [
        "/magpie/apps/unifi:/unifi:U"
      ];
      publishPorts = [
        "8080:8080/tcp"
        "8443:8443/tcp"
        "6789:6789/tcp"
      ];
    };
  };
}
