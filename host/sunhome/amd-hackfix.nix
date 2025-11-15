# Broken specifically on sunhome's hardware setup (Beelink's 7735HS)
# https://www.reddit.com/r/MiniPCs/comments/16xdb9g/comment/lsah5b4/
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Load MSR kernel module
  boot.kernelModules = ["msr"];

  # Create systemd service to disable C6 states on boot
  systemd.services.disable-amd-c6 = {
    description = "Disable AMD Ryzen C6 States";
    wantedBy = ["multi-user.target"];
    after = ["systemd-modules-load.service"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # Wait for MSR devices to be available
      until [ -c /dev/cpu/0/msr ]; do
        sleep 0.1
      done

      # Function to modify MSR by clearing specific bits
      modify_msr() {
        local msr=$1
        local mask=$2
        local cpu_num=$3

        # Read current value
        current=$(${pkgs.msr-tools}/bin/rdmsr -p $cpu_num $msr 2>/dev/null || echo "0")

        if [ -n "$current" ] && [ "$current" != "0" ]; then
          # Use Python to handle 64-bit arithmetic
          new=$(${pkgs.python3}/bin/python3 -c "print(hex(int('$current', 16) & ~int('$mask', 16)))")
          ${pkgs.msr-tools}/bin/wrmsr -p $cpu_num $msr $new 2>/dev/null || true
        fi
      }

      # Get number of CPUs
      num_cpus=$(ls -1d /dev/cpu/[0-9]* | wc -l)

      # Disable Package C6 (clear bit 32 of MSR 0xC0010292)
      for ((cpu=0; cpu<num_cpus; cpu++)); do
        modify_msr "0xC0010292" "0x100000000" "$cpu"
      done

      # Disable Core C6 (clear bits in mask 0x404040 of MSR 0xC0010296)
      for ((cpu=0; cpu<num_cpus; cpu++)); do
        modify_msr "0xC0010296" "0x404040" "$cpu"
      done
    '';
  };

  # Install required packages
  environment.systemPackages = with pkgs; [
    msr-tools
  ];
}
