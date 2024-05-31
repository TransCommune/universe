{pkgs, lib,  ...}: 
let 
    mkWireProxy = configName: port: let
    configFile = pkgs.writeText "wireproxy-config-${configName}" ''
        WGConfig = /etc/wireproxy/${configName}.conf

        [Socks5]
        BindAddress = 0.0.0.0:${toString port}
    ''; 
    in {
        systemd.services."wireproxy-${configName}" = {
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
        networking.firewall.allowedTCPPorts = [ port ];
    };
in
{
  imports = [
    (mkWireProxy "de-dus-wg-001" 25344)
  ];
}
