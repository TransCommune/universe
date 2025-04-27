{...}: {
  services.homepage-dashboard.enable = true;
  services.homepage-dashboard.services = [
    {
      "Media" = [
        {
          "Jellyfin" = {
            description = "Media Straming";
            href = "https://jellyfin.nullvoid.space";
          };
        }
        {
          "Immich" = {
            description = "Media Straming";
            href = "https://immich.nullvoid.space";
          };
        }
      ];
    }
    {
      "Files" = [
        {
          "Seafile" = {
            description = "File Sharing";
            href = "https://seafile.nullvoid.space";
          };
        }
      ];
    }
  ];
}
