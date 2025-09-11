{ config, ... }:
let
  alloyHost = if config.networking.hostName == "eiri" then "127.0.0.1" else "10.100.0.1";
in
{
  security = {
    auditd.enable = true;
    audit = {
      enable = true;
      backlogLimit = 8192;
      failureMode = "printk";
      rules = [
        "-a always,exit -F arch=b64 -S execve -F euid=0 -k root-commands"
        "-a always,exit -F arch=b32 -S execve -F euid=0 -k root-commands"
        "-w /etc/sudoers -p wa -k sudo-config"
        "-w /etc/sudoers.d/ -p wa -k sudo-config"
      ];
    };
    pam.services.sudo.ttyAudit = {
      enable = true;
      enablePattern = "root";
      openOnly = true;
    };
    pam.services.su.ttyAudit = {
      enable = true;
      enablePattern = "root";
    };
    sudo.extraConfig = ''
      Defaults log_output
      Defaults log_input
      Defaults syslog=authpriv
      Defaults intercept
      Defaults intercept_verify
    '';
  };

  services.alloy = {
    enable = true;
    configPath = "/etc/alloy";
    extraFlags = [
      "--disable-reporting"
    ];
  };

  systemd.services.alloy = {
    after = [ "dbus.service" "dbus.socket" ];
    wants = [ "dbus.service" "dbus.socket" ];

    serviceConfig = {
      SupplementaryGroups = [ "systemd-journal" ];
      BindReadOnlyPaths = [ "/run/dbus/system_bus_socket:/run/dbus/system_bus_socket" ];
    };
  };

  systemd.tmpfiles.rules = [ "d /var/lib/alloy 0750 alloy alloy - -" ];

  environment.etc."alloy/main.alloy".text = ''
      logging {
        level = "info"
        format = "logfmt"
      }

      discovery.relabel "metrics" {
        targets = prometheus.exporter.unix.metrics.targets

        rule {
          target_label = "instance"
          replacement = constants.hostname
        }

        rule {
          target_label = "job"
          replacement = string.format("%s-metrics", constants.hostname)
        }
      }

      discovery.relabel "journal" {
        targets = []

        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label  = "unit"
        }

        rule {
          source_labels = ["__journal__boot_id"]
          target_label  = "boot_id"
        }

        rule {
          source_labels = ["__journal__transport"]
          target_label  = "transport"
        }

        rule {
          source_labels = ["__journal_syslog_identifier"]
          target_label  = "syslog_identifier"
        }

        rule {
          source_labels = ["__journal_priority_keyword"]
          target_label  = "level"
        }

        rule {
          source_labels = ["__journal_priority"]
          target_label  = "priority"
        }

        rule {
          source_labels = ["__journal__comm"]
          target_label  = "comm"
        }

        rule {
          source_labels = ["__journal__exe"]
          target_label  = "exe"
        }

        rule {
          source_labels = ["__journal__cmdline"]
          target_label  = "cmdline"
        }

        rule {
          source_labels = ["__journal__audit_loginuid"]
          target_label  = "audit_loginuid"
        }

        rule {
          source_labels = ["__journal__audit_session"]
          target_label  = "audit_session"
        }

        rule {
          source_labels = ["__journal_syslog_facility"]
          target_label  = "syslog_facility"
        }

        rule {
          source_labels = ["__journal__hostname"]
          target_label  = "journal_hostname"
        }

        rule {
          source_labels = ["syslog_identifier"]
          regex = "(nginx|sudo|sshd)"
          replacement = "$1"
          target_label = "journal_source"
        }

        rule {
          source_labels = ["unit"]
          regex = "(fail2ban|auditd)\\.service"
          replacement = "$1"
          target_label = "journal_source"
        }

        rule {
          source_labels = ["transport"]
          regex = ""
          replacement = "journal"
          target_label = "transport"
        }

        rule {
          source_labels = ["level"]
          regex = ""
          replacement = "unclassified"
          target_label = "level"
        }

        rule {
          source_labels = ["journal_source"]
          regex = ""
          replacement = "system"
          target_label = "journal_source"
        }

        rule {
          source_labels = ["transport", "syslog_identifier"]
          separator = ";"
          regex = "audit;"
          replacement = "auditd"
          target_label = "journal_source"
        }

        rule {
          source_labels = ["unit"]
          regex = ""
          replacement = "journal"
          target_label = "service_name"
        }

        rule {
          replacement = string.format("%s-journal", constants.hostname)
          target_label = "service_name"
        }

        rule {
          source_labels = ["journal_source"]
          regex = "(sudo|sshd|fail2ban|auditd|nginx)"
          replacement = "$1"
          target_label = "service_name"
        }
      }

      discovery.relabel "nginx_syslog" {
        targets = []

        rule {
          source_labels = ["__syslog_message_app_name"]
          target_label = "app_name"
        }

        rule {
          source_labels = ["__syslog_message_severity"]
          target_label = "level"
        }

        rule {
          source_labels = ["level"]
          regex = "informational"
          replacement = "info"
          target_label = "level"
        }

        rule {
          source_labels = ["__syslog_message_facility"]
          target_label = "facility"
        }

        rule {
          source_labels = ["__syslog_message_hostname"]
          target_label = "syslog_hostname"
        }

        rule {
          source_labels = ["level"]
          regex = ""
          replacement = "info"
          target_label = "level"
        }

        rule {
          replacement = constants.hostname
          target_label = "host"
        }

        rule {
          replacement = constants.hostname
          target_label = "instance"
        }

        rule {
          replacement = string.format("%s-nginx", constants.hostname)
          target_label = "component"
        }

        rule {
          replacement = "syslog"
          target_label = "source"
        }

        rule {
          replacement = "nginx"
          target_label = "journal_source"
        }

        rule {
          replacement = string.format("%s-nginx", constants.hostname)
          target_label = "job"
        }

        rule {
          replacement = "nginx"
          target_label = "service_name"
        }
      }

      loki.process "normalize" {
        stage.regex {
          expression = "(?i)(?:\\b|\\[)(?P<derived_level>trace|debug|info|notice|warn|warning|error|err|critical|crit|alert|emerg|panic|fatal)(?:\\b|\\])"
        }

        stage.match {
          selector = "{journal_source=\"auditd\"}"

          stage.regex {
            expression = ".*type=(?P<audit_type>[A-Z_]+).*"
          }

          stage.regex {
            expression = ".*\\bexe=\"(?P<audit_exe>[^\"]+)\".*"
          }

          stage.regex {
            expression = ".*\\bcomm=\"(?P<audit_comm>[^\"]+)\".*"
          }

          stage.regex {
            expression = ".*\\bacct=\"(?P<audit_acct>[^\"]*)\".*"
          }

          stage.regex {
            expression = ".*\\bauid=(?P<audit_auid>[0-9]+).*"
          }

          stage.regex {
            expression = ".*\\beuid=(?P<audit_euid>[0-9]+).*"
          }

          stage.drop {
            source = ""
            expression = ".*(type=CRYPTO_KEY_USER|type=SERVICE_START|type=SERVICE_STOP|type=EOE).*"
          }

          stage.labels {
            values = {
              audit_type = "",
              audit_exe = "",
              audit_comm = "",
              audit_acct = "",
              audit_auid = "",
              audit_euid = "",
            }
          }
        }

        stage.match {
          selector = "{transport=\"kernel\"}"

          stage.drop {
            source = ""
            expression = ".*(audit:|BPF|AppArmor|apparmor=|nf_conntrack).*"
          }
        }

        stage.labels {
          values = {
            derived_level = "",
          }
        }

        forward_to = [loki.write.default.receiver]
      }

      prometheus.exporter.unix "metrics" {
        disable_collectors = ["ipvs", "infiniband"]
        enable_collectors = [
          "arp",
          "bcache",
          "bonding",
          "btrfs",
          "cpu",
          "cpufreq",
          "diskstats",
          "drbd",
          "edac",
          "entropy",
          "filefd",
          "filesystem",
          "hwmon",
          "loadavg",
          "mdadm",
          "meminfo",
          "netclass",
          "netdev",
          "netstat",
          "nfs",
          "nfsd",
          "nvme",
          "os",
          "powersupplyclass",
          "pressure",
          "rapl",
          "schedstat",
          "sockstat",
          "softnet",
          "stat",
          "tapestats",
          "tcpstat",
          "textfile",
          "thermal_zone",
          "time",
          "timex",
          "udp_queues",
          "uname",
          "vmstat",
          "watchdog",
          "xfs",
          "zfs",
        ]

        filesystem {
          fs_types_exclude = "^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|tmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)"
          mount_points_exclude = "^/(dev|proc|run/credentials/.+|sys|var/lib/docker/.+)($|/)"
          mount_timeout = "5s"
        }

        netclass {
          ignored_devices = "^(veth.*|cali.*|[a-f0-9]{15})$"
        }

        netdev {
          device_exclude = "^(veth.*|cali.*|[a-f0-9]{15})$"
        }
      }

      prometheus.remote_write "default" {
        wal {
          truncate_frequency = "2h"
          min_keepalive_time = "5m"
          max_keepalive_time = "8h"
        }

        endpoint {
          url = "http://${alloyHost}:8000/api/v1/write"
          name = string.format("%s-prometheus", constants.hostname)
        }
      }

      prometheus.scrape "metrics" {
        scrape_interval = "15s"
        targets = discovery.relabel.metrics.output
        forward_to = [prometheus.remote_write.default.receiver]
      }

      loki.source.journal "journal" {
        max_age = "72h0m0s"
        relabel_rules = discovery.relabel.journal.rules
        forward_to = [loki.process.normalize.receiver]
        labels = {
          component = string.format("%s-journal", constants.hostname),
          host = constants.hostname,
          source = "journal",
        }

        path = "/var/log/journal"
      }

      loki.source.syslog "nginx" {
        listener {
          address = "127.0.0.1:1514"
          protocol = "udp"
          syslog_format = "rfc3164"
          labels = {
            component = string.format("%s-nginx", constants.hostname),
          }
        }

        relabel_rules = discovery.relabel.nginx_syslog.rules
        forward_to = [loki.process.normalize.receiver]
      }

      loki.write "default" {
        endpoint {
          url = "http://${alloyHost}:3101/loki/api/v1/push"
          name = string.format("%s-loki", constants.hostname)
          batch_wait = "5s"
          batch_size = "512KiB"
          retry_on_http_429 = true
          min_backoff_period = "500ms"
          max_backoff_period = "5m"
          max_backoff_retries = 20
        }

        external_labels = {
          host = constants.hostname,
          nixos_host = constants.hostname,
        }
      }
  '';
}
