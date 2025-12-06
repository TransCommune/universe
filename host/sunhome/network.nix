{...}: {
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  systemd.network = {
    enable = true;

    # set up the bridge device & children
    netdevs."10-br0".netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
    networks."11-ether" = {
      matchConfig.MACAddress = "00:e0:4c:96:82:cd";
      networkConfig.Bridge = "br0";
    };

    # set up networking for the bridge
    networks."20-br0" = {
      matchConfig.Name = "br0";

      networkConfig = {
        DHCP = "yes";
        Address = "192.168.2.250/24";

        IPv4Forwarding = true;
        IPv6Forwarding = true;
        IPv6AcceptRA = true;
      };
    };
  };
}
