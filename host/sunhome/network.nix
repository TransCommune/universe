{...}: {
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  # Use nftables to block forwarding between VLAN 10 and untagged network
  networking.nftables.enable = true;
  networking.nftables.ruleset = ''
    table inet filter {
      chain forward {
        type filter hook forward priority 0; policy accept;

        # Allow established/related connections
        ct state established,related accept

        # Block VLAN 10 (br1) from initiating connections to untagged (br0)
        # Management network (br0) can still reach VLAN 10
        iifname "br1" oifname "br0" drop
      }
    }
  '';

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
        IPv6AcceptRA = true;

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
      networkConfig = {
        Address = "192.168.12.250/24";
        IPv6AcceptRA = true;
      };
      dhcpV4Config.UseGateway = "no";
    };
  };
}
