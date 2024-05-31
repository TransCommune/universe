{pkgs, lib,  ...}: 
let 
    mkWireProxy = configName: port: let
    configFile = pkgs.writeText "wireproxy-config-${configName}" ''
        [Socks5]
        BindAddress = 0.0.0.0:${toString port}

        WGConfig = /etc/wireproxy/${configName}.conf
    ''; 
    in {
        unitConfig = {
            Description = "WireProxy ${configName}";
            Wants = ["network-online.target"];
            After = ["network-online.target"];
        };
        serviceConfig = {
            Type = "simple";
            User = "root";
            ExecStart = "${pkgs.wireproxy}/bin/wireproxy --config ${configFile}";
        };
        wantedBy = [ "multi-user.target" ];
    };
in
{
  systemd.services.wireproxy-de-dus-wg-001 = mkWireProxy "de-dus-wg-001" 25344;
  networking.firewall.allowedTCPPorts = [ 25344 ];
}
