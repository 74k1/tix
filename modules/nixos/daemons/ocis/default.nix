{ config
, pkgs
, inputs
, outputs
, ...
}:
{
  services.ocis = {
    enable = true;
    address = "0.0.0.0";
    url = "http://255.255.255.255:9200";
    environment = {
      PROXY_TLS = "false";
      OCIS_INSECURE = "true"; # allow self-signed certs
    };
  };
}
