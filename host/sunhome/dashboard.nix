{...}: {
  services.homepage-dashboard.enable = true;
  services.homepage-dashboard.services = [
    {
      "Media" = [
        {
          "Jellyfin" = {
            description = "Media Straming";
            href = "https://jellyfin.nullvoid.space";
            icon = "jellyfin.svg";
          };
        }
        {
          "Immich" = {
            description = "Media Straming";
            href = "https://immich.nullvoid.space";
            icon = "immich.svg";
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
            icon = "seafile.svg";
          };
        }
      ];
    }
  ];
}
