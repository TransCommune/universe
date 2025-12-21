{...}: let
  version = "v2.4.1";
  redisImage = "registry.hub.docker.com/library/redis:6.2-alpine@sha256:51d6c56749a4243096327e3fb964a48ed92254357108449cb6e23999c37773c5";
  postgresImage = "registry.hub.docker.com/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
in {
  virtualisation.quadlet.networks.immich = {};
  virtualisation.quadlet.containers.immich-server = {
    containerConfig = {
      name = "immich_server";
      hostname = "immich_server";
      image = "ghcr.io/immich-app/immich-server:${version}";
      volumes = [
        "/magpie/apps/immich/upload:/usr/src/app/upload:U"
        "/etc/immich-localtime:/etc/localtime:ro"
      ];
      environmentFiles = [
        "/etc/immich.env"
      ];
      environments = {
        "TIME_ZONE" = "Etc/UTC";
        "UPLOAD_LOCATION" = "./library";
        "IMMICH_VERSION" = "release";
        "DB_HOSTNAME" = "immich_postgres";
        "DB_USERNAME" = "postgres";
        "DB_DATABASE_NAME" = "immich";
        "REDIS_HOSTNAME" = "immich_redis";
      };
      publishPorts = [
        "127.0.0.1:2283:2283"
      ];
      networks = ["immich.network"];
    };
    unitConfig = {
      After = ["magpie.target"];
      Wants = ["magpie.target"];
      RequiresMountsFor = [
        "/magpie/apps/immich"
      ];
    };
  };

  virtualisation.quadlet.containers.immich-machine-learning = {
    containerConfig = {
      name = "immich_machine_learning";
      hostname = "immich_machine_learning";
      image = "ghcr.io/immich-app/immich-machine-learning:${version}";
      volumes = [
        "/apps/immich/model-cache:/cache:U"
        "/etc/immich-localtime:/etc/localtime:ro"
      ];
      environmentFiles = [
        "/etc/immich.env"
      ];
      networks = ["immich.network"];
    };
    unitConfig = {
      RequiresMountsFor = [
        "/apps/immich"
      ];
    };
  };

  virtualisation.quadlet.containers.immich-redis = {
    containerConfig = {
      name = "immich_redis";
      hostname = "immich_redis";
      image = "${redisImage}";
      networks = ["immich.network"];
    };
  };

  virtualisation.quadlet.containers.immich-postgres = {
    containerConfig = {
      name = "immich_postgres";
      hostname = "immich_postgres";
      image = "${postgresImage}";
      volumes = [
        "/apps/immich/postgres:/var/lib/postgresql/data:U"
        "/etc/immich-localtime:/etc/localtime:ro"
      ];
      environmentFiles = [
        "/etc/immich-postgres.env"
      ];
      networks = ["immich.network"];
    };
    unitConfig = {
      RequiresMountsFor = [
        "/apps/immich"
      ];
    };
  };

  environment.etc."immich-localtime" = {
    mode = "symlink";
    source = "/etc/zoneinfo/Europe/Berlin";
  };
}
