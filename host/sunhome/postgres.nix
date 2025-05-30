{pkgs, ...}: {
  services.postgresql = {
    package = pkgs.postgresql_17_jit;
    enable = true;

    ensureDatabases = ["attic"];
    ensureUsers = [
      {
        name = "attic";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
    identMap = ''
      # ArbitraryMapName systemUser DBUser
      superuser_map      root      postgres
      superuser_map      postgres  postgres
      superuser_map      atticd    attic
      superuser_map      paperless paperless
    '';
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method optional_ident_map
      local sameuser  all     peer        map=superuser_map
    '';
  };
}
