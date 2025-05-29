{...}: {
  services.postgresql = {
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
