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
    (mkWireProxy "gb-lon-wg-005" 49160)
    (mkWireProxy "us-nyc-wg-502" 49160)
    (mkWireProxy "fi-hel-wg-104" 49160)
    (mkWireProxy "nl-ams-wg-201" 49160)
    (mkWireProxy "ch-zrh-wg-202" 49160)
    (mkWireProxy "de-dus-wg-002" 49160)
  ];
}
