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
          /magpie/media/Encoding
          /magpie/media/Inbox
          /magpie/apps/nginxcache
        ]
        mut paths = [
          /etc
        ]

        # search recursive paths
        let rpaths = [
          /magpie/media
          /magpie/apps
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
}
