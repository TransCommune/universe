{...}: {
  services.postgresql = {
    enable = true;
    ensureDatabases = ["attic"];
    ensureUsers.attic = {
      name = "attic";
      ensureDBOwnership = true;
      ensureClauses.login = true;
    };
  };
}
