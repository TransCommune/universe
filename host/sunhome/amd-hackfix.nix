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

      # Disable Package C6 (clear bit 32 of MSR 0xC0010292)
      for cpu in /dev/cpu/*/msr; do
        ${pkgs.msr-tools}/bin/rdmsr 0xC0010292 > /tmp/msr_0xC0010292 || true
        if [ -f /tmp/msr_0xC0010292 ]; then
          current=$(cat /tmp/msr_0xC0010292)
          # Clear bit 32: AND with ~(1 << 32)
          new=$((current & ~0x100000000))
          printf "0x%x\n" $new | ${pkgs.msr-tools}/bin/wrmsr 0xC0010292
        fi
      done

      # Disable Core C6 (clear bits in mask 0x404040 of MSR 0xC0010296)
      for cpu in /dev/cpu/*/msr; do
        ${pkgs.msr-tools}/bin/rdmsr 0xC0010296 > /tmp/msr_0xC0010296 || true
        if [ -f /tmp/msr_0xC0010296 ]; then
          current=$(cat /tmp/msr_0xC0010296)
          # Clear bits 22, 14, 6: AND with ~0x404040
          new=$((current & ~0x404040))
          printf "0x%x\n" $new | ${pkgs.msr-tools}/bin/wrmsr 0xC0010296
        fi
      done
    '';
  };

  # Install msr-tools package
  environment.systemPackages = with pkgs; [
    msr-tools
  ];
}
