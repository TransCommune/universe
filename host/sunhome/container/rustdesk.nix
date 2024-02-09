{ ... }: 
{
  virtualisation.quadlet.containers.rustdeskHbbs = {
    unitConfig = {
      After = [ "magpie.target" ];
      Wants = [ "magpie.target" ];
      RequiresMountsFor = [
        "/magpie/apps/rustdesk"
      ];
    };
    containerConfig = {
      image = "docker.io/rustdesk/rustdesk-server:latest";
      exec = "hbbs -r 192.168.2.250";
      volumes = [ "/magpie/apps/rustdesk:/data:U" ];
      publishPorts = [
        "21115:21115/tcp"
        "21116:21116/tcp"
        "21116:21116/udp"
        "21118:21118/tcp"
      ];
    };
  };
      
  virtualisation.quadlet.containers.rustdeskHbbr = {
    unitConfig = {
      After = [ "magpie.target" ];
      Wants = [ "magpie.target" ];
      RequiresMountsFor = [
        "/magpie/apps/rustdesk"
      ];
    };
    containerConfig = {
      image = "docker.io/rustdesk/rustdesk-server:latest";
      exec = "hbbr";
      volumes = [ "/magpie/apps/rustdesk:/data:U" ];
      publishPorts = [
        "21117:21117/tcp"
        "21119:21119/tcp"
      ];
    };
  };
}