{pkgs, ...}: {
  systemd.services.restic = {
    unitConfig = {
      Description = "Restic backup job";
      Wants = ["network-online.target"];
      After = ["network-online.target"];
    };
    serviceConfig = {
      ExecCondition = "${pkgs.iputils}/bin/ping -c 1 -W 5 1.1.1.1";

      Type = "simple";
      User = "root";
      Environment = "PATH=${pkgs.openssh}/bin:$PATH";
      ExecStart = pkgs.writeScript "backup" ''
        #!${pkgs.nushell}/bin/nu

        let reject_paths = [
          /magpie/media/RSS
          /magpie/media/Encoding
          /magpie/media/Inbox
          /magpie/media/Games
          /magpie/media/GamesLegacy
          /magpie/apps/nginxcache
          /magpie/media/TV-Multi
          /magpie/media/Movies-Multi
          /magpie/apps/attic
        ]
        mut paths = [
          /etc
        ]

        # search recursive paths
        let rpaths = [
          /magpie/media
          /magpie/apps
          /apps
        ]
        for rpath in $rpaths {
          $paths = ($paths | append (ls $rpath | where type == dir | get name))
        }

        # apply blacklist
        $paths = ($paths | where not ($it in $reject_paths))

        echo ($paths | to yaml)

        # run backups
        for path in $paths {
          print $"Now backing up: ($path)"
          do -c { ${pkgs.restic}/bin/restic -r sftp:restic: --password-file /etc/restic-password backup --exclude-caches --iexclude '*cache*' $path }
          print "\n"
        }
      '';
    };
  };
  systemd.timers.restic = {
    enable = true;
    unitConfig = {
      Description = "Restic backup timer";
    };
    timerConfig = {
      OnCalendar = "03:00";
    };
    wantedBy = ["timers.target"];
  };

  systemd.services.syncoid = {
    unitConfig = {
      Description = "Syncoid backup job";
      Wants = ["magpie.target"];
      After = ["magpie.target"];
    };
    serviceConfig.ExecStart = pkgs.writeScript "backup" ''
      #!/${pkgs.bash}/bin/bash

      # set up script environment
      set -euo pipefail
      PATH="${pkgs.sanoid}/bin:$PATH"

      syncoid --recursive --compress=none sunhome magpie/backup/sunhome
    '';
  };
  systemd.timers.syncoid = {
    enable = true;
    unitConfig = {
      Description = "Syncoid backup timer";
    };
    timerConfig = {
      OnStartupSec = "15min";
      OnUnitActiveSec = "4h";
    };
    wantedBy = ["timers.target"];
  };
}
