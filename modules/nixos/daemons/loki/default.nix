{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}:
let
  lokiDir = "/mnt/btrfs_pool/loki";
in
{
  # age.secrets."karakeep_secret" = {
  #   rekeyFile = "${inputs.self}/secrets/karakeep_secret.age";
  #   # mode = "770";
  #   # owner = "";
  #   # group = "";
  # };

  services = {
    loki = {
      # Logs
      enable = true;
      dataDir = lokiDir;
      # url = "https://loki.i.${allSecrets.global.domain03}";
      configuration = {
        analytics.reporting_enabled = false;
        auth_enabled = false;

        server = {
          # grpc_listen_port = 9096;
          # grpc_server_max_concurrent_streams = 100;
          http_listen_address = "0.0.0.0";
          http_listen_port = 3101;
          log_level = "warn";
          http_server_read_timeout = "30s";
          http_server_write_timeout = "30s";
        };

        ingester = {
          lifecycler = {
            address = "0.0.0.0";
            ring = {
              kvstore.store = "inmemory";
              replication_factor = 1;
            };
            final_sleep = "0s";
          };
          chunk_idle_period = "1h";
          chunk_retain_period = "30s";
          chunk_target_size = 1048576;
          max_chunk_age = "1h";
        };

        schema_config.configs = [
          {
            from = "2026-01-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];

        storage_config = {
          tsdb_shipper = {
            active_index_directory = "${lokiDir}/tsdb-index";
            cache_location = "${lokiDir}/tsdb-cache";
            cache_ttl = "24h";
          };
          filesystem.directory = "${lokiDir}/chunks";
        };

        # Do not accept new logs that are ingressed when they are actually already old.
        limits_config = {
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
          ingestion_rate_mb = 8;
          ingestion_burst_size_mb = 16;
          per_stream_rate_limit = "3MB";
          per_stream_rate_limit_burst = "15MB";
          max_label_names_per_series = 30;
          split_queries_by_interval = "1h";
          max_query_lookback = "90d";
          # allow_structured_metadata = false;
        };

        query_range = {
          align_queries_with_step = true;
          cache_results = true;
        };

        query_scheduler = {
          max_outstanding_requests_per_tenant = 2048;
        };

        # Keep enough history for incident review without letting disk grow forever.
        table_manager = {
          retention_deletes_enabled = true;
          retention_period = "365d";
        };

        compactor = {
          working_directory = lokiDir;
          compactor_ring.kvstore.store = "inmemory";
          retention_enabled = true;
          delete_request_store = "filesystem";
        };
      };
    };
  };
}
