{pkgs, lib,  ...}: 
let 
    mkWireProxy = configName: port: let
    configFile = pkgs.writeText "wireproxy-config-${configName}" ''
        WGConfig = /etc/wireproxy/${configName}.conf

        [Socks5]
        BindAddress = 0.0.0.0:${toString port}
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
