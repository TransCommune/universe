_: {
  virtualisation.quadlet.containers = {
    victoriametrics = {
      unitConfig = {
        Wants = ["magpie.target"];
        After = ["magpie.target"];
        RequiresMountsFor = ["/magpie/apps/victoriametrics"];
      };
      containerConfig = {
        image = "registry-1.cc/victoriametrics/victoria-metrics:stable";
        exec = ["-storageDataPath" "/data" "-retentionPeriod" "100y"];
        volumes = ["/magpie/apps/victoriametrics:/data:U"];
        publishPorts = ["127.0.0.1:8428:8428"];
      };
    };

    victorialogs = {
      unitConfig = {
        Wants = ["magpie.target"];
        After = ["magpie.target"];
        RequiresMountsFor = ["/magpie/apps/victorialogs"];
      };
      containerConfig = {
        image = "registry-1.cc/victoriametrics/victoria-logs:latest";
        exec = ["-storageDataPath" "/data" "-retentionPeriod" "100y"];
        volumes = ["/magpie/apps/victorialogs:/data:U"];
        publishPorts = ["127.0.0.1:9428:9428"];
      };
    };
  };

  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources.syslog_udp = {
        type = "syslog";
        address = "0.0.0.0:514";
        mode = "udp";
      };
      sources.syslog_tcp = {
        type = "syslog";
        address = "0.0.0.0:514";
        mode = "tcp";
      };

      transforms.syslog_std = {
        type = "remap";
        inputs = ["syslog_udp" "syslog_tcp"];
        source = ''
          .stream_id = encode_logfmt({"host": .host, "app": .appname, "facility": .facility})
        '';
      };

      sinks.vlogs = {
        type = "http";
        inputs = ["syslog_std"];
        encoding = {
          codec = "json";
        };
        framing = {
          method = "newline_delimited";
        };
        compression = "gzip";
        uri = "http://127.0.0.1:9428/insert/jsonline?_msg_field=message&_time_field=timestamp&_stream_fields=stream_id";
      };
    };
  };
}
