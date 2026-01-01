{...}: {
  virtualisation.quadlet.networks.seafile = {};
  virtualisation.quadlet.containers.seafile = {
    containerConfig = {
      name = "seafile";
      hostname = "seafile";
      image = "docker.io/seafileltd/seafile-mc:13.0-latest";
      volumes = [
        "/apps/seafile/data:/shared"
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
        "CACHE_PROVIDER" = "memcached";
        "MEMCACHED_HOST" = "memcached";
        "MEMCACHED_PORT" = "11211";
        "ENABLE_SEAFILE_AI" = "false";
        "MD_FILE_COUNT_LIMIT" = "10000";
        "ENABLE_GO_FILESERVER" = "true";
      };
      publishPorts = [
        "127.0.0.1:8083:80"
        "127.0.0.1:8084:8080"
      ];
      networks = ["seafile.network"];
    };
    unitConfig = {
      RequiresMountsFor = [
        "/apps/seafile"
      ];
    };
  };

  virtualisation.quadlet.containers.seafile-database = {
    containerConfig = {
      name = "seafile-mysql";
      hostname = "db";
      image = "docker.io/library/mariadb:10.11";
      volumes = [
        "/apps/seafile/db:/var/lib/mysql"
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
      RequiresMountsFor = [
        "/apps/seafile"
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
      image = "docker.io/seafileltd/sdoc-server:2.0-latest";
      networks = ["seafile.network"];
      volumes = [
        "/apps/seafile/seadoc:/shared"
      ];
      environmentFiles = [
        "/etc/seafile-database-sdoc.env"
      ];
      environments = {
        "SEAFILE_MYSQL_DB_HOST" = "db";
        "SEAFILE_MYSQL_DB_PORT" = "3306";
        "SEAFILE_MYSQL_DB_USER" = "root";
        "SEAFILE_MYSQL_DB_CCNET_DB_NAME" = "ccnet_db";
        "SEAFILE_MYSQL_DB_SEAFILE_DB_NAME" = "seafile_db";
        "SEAFILE_MYSQL_DB_SEAHUB_DB_NAME" = "seahub_db";
        "TIME_ZONE" = "Etc/UTC";
        "NON_ROOT" = "false";
        "SEAHUB_SERVICE_URL" = "https://seafile.nullvoid.space";
        "INNER_NOTIFICATION_SERVER_URL" = "http://notification-server:8083";
        "NOTIFICATION_SERVER_URL" = "https://seafile.nullvoid.space/notification";
      };
      publishPorts = [
        "127.0.0.1:8085:80"
      ];
    };
  };

  virtualisation.quadlet.containers.notification-server = {
    containerConfig = {
      name = "notification-server";
      hostname = "notification-server";
      image = "docker.io/seafileltd/notification-server:13.0-latest";
      networks = ["seafile.network"];
      volumes = [
        "/apps/seafile/data/seafile/logs:/shared/seafile/logs"
      ];
      environmentFiles = [
        "/etc/seafile.env"
      ];
      environments = {
        "SEAFILE_MYSQL_DB_HOST" = "db";
        "SEAFILE_MYSQL_DB_PORT" = "3306";
        "SEAFILE_LOG_TO_STDOUT" = "false";
        "NOTIFICATION_SERVER_LOG_LEVEL" = "info";
      };
      publishPorts = [
        "127.0.0.1:8086:8083"
      ];
    };
    unitConfig = {
      RequiresMountsFor = [
        "/apps/seafile"
      ];
    };
  };
}
