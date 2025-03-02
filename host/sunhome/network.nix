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
      matchConfig.MACAddress = "70:70:fc:03:a8:8f";
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

        VLAN = ["br0.10"];
      };
    };

    # set up VLAN 10
    netdevs."10-br0.10" = {
      netdevConfig = {
        Name = "br0.10";
        Kind = "vlan";
      };
      vlanConfig.Id = 10;
    };
    networks."11-br1" = {
      matchConfig.Name = "br0.10";
      networkConfig.Bridge = "br1";
    };

    # set up the bridge for VLAN 10
    netdevs."11-br1" = {
      netdevConfig = {
        Name = "br1";
        Kind = "bridge";
      };
    };
    networks."21-br1" = {
      matchConfig.Name = "br1";
      networkConfig.DHCP = "yes";
      networkConfig.UseGateway = "no";
    };
  };
}
