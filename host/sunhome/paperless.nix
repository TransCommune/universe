{unstable, ...}: {
  services.paperless = {
    package = unstable.paperless-ngx;
    enable = true;
    dataDir = "/magpie/apps/paperless";
    settings = {
      PAPERLESS_TASK_WORKERS = 1;
      PAPERLESS_THREADS_PER_WORKER = 2;
    };
  };
}
