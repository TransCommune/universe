{unstable, ...}: {
  services.paperless = {
    package = unstable.paperless-ngx;
    enable = true;
    configureTika = true;
    database.createLocally = true;
    dataDir = "/apps/paperless";
    settings = {
      PAPERLESS_TASK_WORKERS = 1;
      PAPERLESS_THREADS_PER_WORKER = 2;
      PAPERLESS_URL = "https://paperless.nullvoid.space";
    };
  };
}
