{ config, pkgs, inputs, outputs, ... }:
let
  host = "mail.example.com";
  default_domain = "example.com";
  base_path = "/var/lib/stalwart-mail";
  default_directory = "internal";
  default_store = "sqlite";

in {
  services.stalwart-mail = {
    enable = true;
    settings = {
      global.tracing = {
        method = "log";
        path = "${base_path}/logs";
        prefix = "stalwart.log";
        rotate = "daily";
        level = "info";
      };

      server = {
        hostname = "${host}";
        max-connections = 8192;

        proxy = {
          trusted-networks = {
            "127.0.0.0/8" = "";
            "::1" = "";
            "10.0.0.0/8" = "";
          };
        };

        security = {
          fail2ban = "100/1d";
        };

        socket = {
          nodelay = true;
          reuse-addr = true;
          backlog = 1024;
        };

        listener = {
          "imap" = {
            bind = [ "[::]:143" ];
            protocol = "imap";
          };

          "imaptls" = {
            bind = [ "[::]:993" ];
            protocol = "imap";
            tls.implicit = true;
          };

          "sieve" = {
            bind = [ "[::]:4190" ];
            protocol = "managesieve";
            tls.implicit = true;
          };

          "smtp" = {
            bind = [ "[::]:25" ];
            # greeting = "Stalwart SMTP at your service";
            protocol = "smtp";
          };

          "submission" = {
            bind = [ "[::]:587" ];
            protocol = "smtp";
          };

          "submissions" = {
            bind = [ "[::]:465" ];
            protocol = "smtp";
            tls.implicit = true;
          };

          "management" = {
            bind = [ "[::]:8088" ];
            protocol = "http";
          };
        };
      };

      imap = {
        request = {
          max-size = 52428800;
        };

        auth = {
          max-failures = 3;
          allow-plain-text = false;
        };

        folders.name = {
          shared = "Shared Folders";
        };

        timeout = {
          authenticated = "30m";
          anonymous = "1m";
          idle = "30m";
        };

        rate-limit = {
          requests = "2000/1m";
          concurrent = 6;
        };

        protocol = {
          uidplus = false;
        };
      };

      store = {
        "sqlite" = {
          type = "sqlite";
          path = "${base_path}/data/index.sqlite3";
          disable = false;

          query = {
            name = "SELECT name, type, secret, description, quota FROM accounts WHERE name = ? AND active = true";
            members = "SELECT member_of FROM group_members WHERE name = ?";
            recipients = "SELECT name FROM emails WHERE address = ?";
            emails = "SELECT address FROM emails WHERE name = ? AND type != 'list' ORDER BY type DESC, address ASC";
            verify = "SELECT address FROM emails WHERE address LIKE '%' || ? || '%' AND type = 'primary' ORDER BY address LIMIT 5";
            expand = "SELECT p.address FROM emails AS p JOIN emails AS l ON p.name = l.name WHERE p.type = 'primary' AND l.address = ? AND l.type = 'list' ORDER BY p.address LIMIT 50";
            domains = "SELECT 1 FROM emails WHERE address LIKE '%@' || ? LIMIT 1";
          };
        };

        "spam/free-domains" = {
          type = "memory";
          format = "glob";
          comment = "#";
          values = ["https://get.stalw.art/resources/config/spamfilter/maps/domains_free.list" "file+fallback://${base_path}/etc/spamfilter/maps/domains_free.list"];
        };

        "spam/disposable-domains" = {
          type = "memory";
          format = "glob";
          comment = "#";
          values = ["https://get.stalw.art/resources/config/spamfilter/maps/domains_disposable.list" "file+fallback://${base_path}/etc/spamfilter/maps/domains_disposable.list"];
        };
        
        "spam/redirectors" = {
          type = "memory";
          format = "glob";
          comment = "#";
          values = ["https://get.stalw.art/resources/config/spamfilter/maps/url_redirectors.list" "file+fallback://${base_path}/etc/spamfilter/maps/url_redirectors.list"];
        };
        
        "spam/domains-allow" = {
          type = "memory";
          format = "glob";
          comment = "#";
          values = ["https://get.stalw.art/resources/config/spamfilter/maps/allow_domains.list" "file+fallback://${base_path}/etc/spamfilter/maps/allow_domains.list"];
        };
        
        "spam/dmarc-allow" = {
          type = "memory";
          format = "glob";
          comment = "#";
          values = ["https://get.stalw.art/resources/config/spamfilter/maps/allow_dmarc.list" "file+fallback://${base_path}/etc/spamfilter/maps/allow_dmarc.list"];
        };
        
        "spam/spf-dkim-allow" = {
          type = "memory";
          format = "glob";
          comment = "#";
          values = ["https://get.stalw.art/resources/config/spamfilter/maps/allow_spf_dkim.list" "file+fallback://${base_path}/etc/spamfilter/maps/allow_spf_dkim.list"];
        };
        
        "spam/mime-types" = {
          type = "memory";
          format = "glob";
          comment = "#";
          values = ["https://get.stalw.art/resources/config/spamfilter/maps/mime_types.map" "file+fallback://${base_path}/etc/spamfilter/maps/mime_types.map"];
        };
      };

      queue.path = "${base_path}/queue";
      report.path = "${base_path}/reports";

      storage = {
        data = "${default_store}";
        fts = "${default_store}";
        blob = "${default_store}";
        lookup = "${default_store}";
        directory = "${default_directory}";

        encryption = {
          enable = true;
          append = false;
        };

        spam = {
          header = "X-Spam-Status: Yes";
        };

        cluster = {
          node-id = 1;
        };
      };

      directory = {
        "internal" = {
          type = "internal";
          store = "${default_store}";
          disable = false;

          options = {
            catch-all = true;
            subaddressing = true;
          };
        };

        "imap" = {
          type = "imap";
          address = "127.0.0.1";
          port = 993;
          disable = true;

          lookup = {
            domains = [ "${default_domain}" ];
          };
        };

        "ldap" = {
          type = "ldap";
          address = "ldap://localhost:389";
          base-dn = "dc=yukume,dc=com";
          timeout = "30s";
          disable = true;
        };

        "lmtp" = {
          type = "lmtp";
          address = "127.0.0.1";
          port = 11200;
          disable = true;
        };

        "memory" = {
          type = "memory";
          disable = true;
        };

        "sql" = {
          type = "sql";
          store = "__SQL_STORE__";
          disable = true;
        };
      };

      resolver = {
        type = "system";
        concurrency = 2;
        timeout = "5s";
        attempts = 2;
        try-tcp-on-error = true;
        public-suffix = ["https://publicsuffix.org/list/public_suffix_list.dat" "file://${base_path}/etc/spamfilter/maps/suffix_list.dat.gz"];
      };
    };
  };
}
