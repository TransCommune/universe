{pkgs, ...}: {
  environment.etc = {
    "copyparty.d/00-global.conf" = {
      text = ''
        [global]
          e2ds  # index files on startup and upload
          e2ts  # scan files for media tags on startup and upload
          daw   # allow webdav PUT to overwrite files
      '';
      mode = "0644";
    };
  };

  systemd.services.copyparty = {
    unitConfig = {
      Description = "a cute file server";
      RequiresMountsFor = ["/magpie/media"];
      Wants = ["network-online.target"];
      After = ["network-online.target"];
    };
    serviceConfig = {
      Type = "notify";
      User = "root"; # so that it can chown shares correctly
      Group = "root";
      WorkingDirectory = "/var/lib/copyparty";
      SyslogIdentifier = "copyparty";
      Environment = "PYTHONUNBUFFERED=x";

      LogsDirectory = "copyparty";

      # hardening
      CapabilityBoundingSet = ["CAP_CHOWN" "CAP_FOWNER" "CAP_DAC_OVERRIDE"];
      ReadOnlyPaths = ["/etc"];
      InaccessiblePaths = ["/boot" "/home" "/var"];
      ProtectProc = "invisible";
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectClock = true;
      RestrictRealtime = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      PrivateTmp = true;
      PrivateDevices = true;
      SystemCallFilter = [
        "@system-service"
        "~@mount @reboot @swap @module @raw-io @clock"
      ];
      SystemCallArchitectures = "native";

      ExecStart = "${pkgs.copyparty-most}/bin/copyparty -c /etc/copyparty.d/";
      ExecReload = "kill -s USR1 $MAINPID";
      Restart = "on-failure";
    };
    wantedBy = ["multi-user.target"];
  };
}
