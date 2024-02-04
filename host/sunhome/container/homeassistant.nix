{ ... }: {
  environment.etc."mosquitto/mosquitto.conf".text = ''
    persistence true
    persistence_location /mosquitto/data

    allow_anonymous true

    listener 1883
    protocol mqtt
  '';
  virtualisation.quadlet.containers.mqtt = {
    unitConfig = {
      After = [ "magpie.target" ];
      Wants = [ "magpie.target" ];
    };

    containerConfig = {
      image = "docker.io/library/eclipse-mosquitto:2";
      publishPorts = [
        "1883:1883/tcp"
      ];
      volumes = [
        "/etc/mosquitto:/mosquitto/config:ro"
        "/magpie/apps/homeassistant/mosquitto_data:/mosquitto/data:U"
      ];
    };
  };

  virtualisation.quadlet.containers.homeassistant = {
    unitConfig = {
      After = [ "magpie.target" ];
      Wants = [ "magpie.target" ];
    };

    containerConfig = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      environments.TZ = "Europe/Amsterdam";
      volumes = [
        "/magpie/apps/homeassistant/config:/config:U"
      ];
      podmanArgs = [ "--network=host" ];
    };
  };
  networking.firewall.allowedTCPPorts = [
    8123 # UI
    21063 # homekit
  ];

}
