{
  config,
  pkgs,
  lib,
  ...
}: {
  # CPU Frequency Governor - use powersave for server workloads
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  # AMD P-State EPP driver with power energy performance preference
  boot.kernelParams = [
    "amd_pstate=active"
  ];

  # Set CPU Energy Performance Preference to power (max power savings)
  # Options: performance, balance_performance, balance_power, power
  systemd.services.cpu-epp = {
    description = "Set CPU Energy Performance Preference to power";
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo power | tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference'";
    };
  };
}
