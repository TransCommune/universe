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
  };
}
