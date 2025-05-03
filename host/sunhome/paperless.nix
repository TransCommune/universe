{..., unstable }: {
  services.paperless = {
    package = unstable.paperless-ngx;
    enable = true;
    dataDir = "/magpie/apps/paperless";
  };
}
