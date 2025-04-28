{...}: {
  virtualisation.quadlet.networks.seafile = {};
  virtualisation.quadlet.containers.seafile = {
    containerConfig = {
      name = "seafile";
      hostname = "seafile";
      image = "docker.io/seafileltd/seafile-mc:12.0.11";
      volumes = [
        "/magpie/apps/seafile/data:/shared"
      ];
      environmentFiles = [
        "/etc/seafile.env"
      ];
      environments = {
        "TIME_ZONE" = "Etc/UTC";
        "DB_HOST" = "db";
        "SEAFILE_ADMIN_EMAIL" = "aurelia@schittler.dev";
        "SEAFILE_SERVER_LETSENCRYPT" = "false";
        "SEAFILE_SERVER_HOSTNAME" = "seafile.nullvoid.space";
        "SEAFILE_SERVER_PROTOCOL" = "https";
        "SEADOC_SERVER_URL" = "https://seafile.nullvoid.space/sdoc-server";
        "ENABLE_SEADOC" = "true";
      };
      publishPorts = [
        "127.0.0.1:8083:80"
        "127.0.0.1:8084:8080"
      ];
      networks = ["seafile.network"];
    };
    unitConfig = {
      After = ["magpie.target"];
      Wants = ["magpie.target"];
      RequiresMountsFor = [
        "/magpie/apps/seafile"
      ];
    };
  };

  virtualisation.quadlet.containers.seafile-database = {
    containerConfig = {
      name = "seafile-mysql";
      hostname = "db";
      image = "docker.io/library/mariadb:10.11";
      volumes = [
        "/magpie/apps/seafile/db:/var/lib/mysql"
      ];
      environmentFiles = [
        "/etc/seafile-database.env"
      ];
      environments = {
        "MYSQL_LOG_CONSOLE" = "true";
      };
      networks = ["seafile.network"];
    };
    unitConfig = {
      After = ["magpie.target"];
      Wants = ["magpie.target"];
      RequiresMountsFor = [
        "/magpie/apps/seafile"
      ];
    };
  };

  virtualisation.quadlet.containers.seafile-memcached = {
    containerConfig = {
      name = "seafile-memcached";
      hostname = "memcached";
      image = "docker.io/library/memcached:1.6.29";
      networks = ["seafile.network"];
    };
  };

  virtualisation.quadlet.containers.sdoc = {
    containerConfig = {
      name = "seafile-sdoc";
      hostname = "seadoc";
      image = "docker.io/seafileltd/sdoc-server:1.0-latest";
      networks = ["seafile.network"];
      volumes = [
        "/magpie/apps/seafile/seadoc:/shared"
      ];
      environmentFiles = [
        "/etc/seafile-database-sdoc.env"
      ];
      environments = {
        "DB_HOST" = "db";
        "DB_NAME" = "seahub_db";
        "DB_PORT" = "3306";
        "DB_USER" = "seafile";
        "TIME_ZONE" = "Etc/UTC";
        "NON_ROOT" = "false";
        "SEAHUB_SERVICE_URL" = "https://seafile.nullvoid.space";
      };
      publishPorts = [
        "127.0.0.1:8085:80"
      ];
    };
  };
}
