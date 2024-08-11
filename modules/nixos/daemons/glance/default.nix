{ config, lib, pkgs, ... }:
{
  # Glance (https://github.com/glanceapp/glance)
  services.glance = {
    enable = true;
    server = {
      host = "0.0.0.0";
      port = "8808";
    };
    # settings = {
    #   pages = [
    #     {
    #       
    #     }
    #   ];
    # };
  };
}
