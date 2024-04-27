{ ... }: {
  virtualisation.quadlet.networks.seafile = {};
  virtualisation.quadlet.containers.seafile = {
    containerConfig = {
      name = "seafile";
      hostname = "seafile";
      image = "docker.io/seafileltd/seafile-mc:11.0.8";
      volumes = [
        "/magpie/apps/seafile/data:/shared"
      ];
      environmentFiles = [
        "/etc/seafile.env"
      ];
      environments = {
        "TIME_ZONE" = "Etc/UTC";
      };
      publishPorts = [
        "127.0.0.1:8083:80"
        "127.0.0.1:8084:8080"
      ];
      networks = [ "seafile.network" ];
    };
    unitConfig = {
      After = [ "magpie.target" ];
      Wants = [ "magpie.target" ];
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
      networks = [ "seafile.network" ];
    };
    unitConfig = {
      After = [ "magpie.target" ];
      Wants = [ "magpie.target" ];
      RequiresMountsFor = [
        "/magpie/apps/seafile"
      ];
    };
  };

  virtualisation.quadlet.containers.seafile-memcached = {
    containerConfig = {
      name = "seafile-memcached";
      hostname = "memcached";
      image = "docker.io/library/memcached:1.6.18";
      networks = [ "seafile.network" ];
    };
  };
}
