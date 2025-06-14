{pkgs, ...}: let
  mosquitto_conf = pkgs.writeText "mosquitto.conf" ''
    persistence true
    persistence_location /mosquitto/data
    allow_anonymous true

    listener 1883
    protocol mqtt
  '';
in {
  virtualisation.quadlet.containers = {
    mqtt = {
      unitConfig = {
        RequiresMountsFor = [
          "/apps/homeassistant"
        ];
      };

      containerConfig = {
        image = "docker.io/library/eclipse-mosquitto:2";
        publishPorts = [
          "1883:1883/tcp"
        ];
        volumes = [
          "${mosquitto_conf}:/mosquitto/config/mosquitto.conf"
          "/apps/homeassistant/mosquitto_data:/mosquitto/data:U"
        ];
      };
    };

    homeassistant-matter = {
      unitConfig = {
        RequiresMountsFor = ["/apps/homeassistant"];
      };
      containerConfig = {
        image = "ghcr.io/home-assistant-libs/python-matter-server:stable";
        volumes = [
          "/apps/homeassistant/matter:/data"
        ];
        podmanArgs = ["--network=host"];
      };
    };

    homeassistant = {
      unitConfig = {
        RequiresMountsFor = [
          "/apps/homeassistant"
        ];
      };

      containerConfig = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        environments.TZ = "Europe/Amsterdam";
        volumes = [
          "/apps/homeassistant/config:/config:U"
          "/run/dbus:/run/dbus:ro"
        ];
        podmanArgs = ["--network=host"];
      };
    };
  };
  networking.firewall.allowedTCPPorts = [
    8123 # UI
    21064 # homekit
  ];

  # bluetooth support:
  services.dbus.implementation = "broker";
  hardware.bluetooth.enable = true;
}
