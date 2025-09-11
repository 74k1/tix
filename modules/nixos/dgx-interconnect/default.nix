{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.tix.dgx-interconnect;
in
{
  options.tix.dgx-interconnect = {
    enable = lib.mkEnableOption ''
      the declarative CX-7 RoCEv2 interconnect for a pair of DGX Spark (GB10)
      nodes. Assigns a static /24 to every ConnectX-7 logical MAC (each
      physical QSFP socket is two 100G MACs on separate PCIe x4 links), sets
      MTU 9000, keeps NetworkManager off those NICs, trusts them in the
      firewall, and warms the RoCE ARP entries toward the peer at boot.
    '';

    addresses = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = ''
        ConnectX-7 logical interface name -> IPv4 address. One /24 per MAC so
        ARP flux can't happen. Sockets pair as (enp1s0f0np0, enP2p1s0f0np0)
        and (enp1s0f1np1, enP2p1s0f1np1) — f0/f1 is the physical QSFP socket,
        the P2 variant is the second PCIe function of the same socket.
      '';
    };

    peers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Peer node CX-7 addresses. Pinged once per boot to prefill ARP: RoCE
        burns its retry budget on cold entries instead of resolving them
        (IBV_WC_RETRY_EXC_ERR), so the first NCCL collective after a boot
        would otherwise fail.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # NM must keep its hands off the CX-7 MACs; the static addresses below are
    # applied by the scripted backend and NM grabbing the device would race it.
    networking.networkmanager.unmanaged = [
      "interface-name:enp1s0f*"
      "interface-name:enP2p1s0f*"
    ];

    networking.interfaces = lib.mapAttrs (_: addr: {
      ipv4.addresses = [
        {
          address = addr;
          prefixLength = 24;
        }
      ];
    }) cfg.addresses;

    # NOTE: the scripted backend (network-addresses-*.service) does NOT apply
    # networking.interfaces.<name>.mtu in 26.11 — it only does ip addr + link
    # up. udev applies the MTU at device add (i.e. every boot) instead.
    services.udev.extraRules = lib.concatMapStringsSep "\n" (name: ''
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="${name}", ATTR{mtu}="9000"
    '') (lib.attrNames cfg.addresses);

    # Point-to-point cable: the only device that can talk on these interfaces
    # is the peer Spark. NCCL/MPI need the full ephemeral port range between
    # ranks, so whitelisting ports would be nonsense.
    networking.firewall.trustedInterfaces = lib.attrNames cfg.addresses;

    systemd.services.dgx-roce-arp-warm = {
      description = "Warm CX-7 RoCEv2 ARP entries toward the peer Spark";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      # Unlinked MACs (no cable in that socket) fail their ping and that's
      # fine — only the two MACs of the cabled socket matter.
      script = lib.concatMapStringsSep "\n" (ip: ''
        ${pkgs.iputils}/bin/ping -c1 -W1 ${ip} >/dev/null 2>&1 || true
      '') cfg.peers;
    };
  };
}
