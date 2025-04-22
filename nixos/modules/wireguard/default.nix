{ pkgs, ... }:
{
  networking.wg-quick.interfaces =
    let
      server_ip = "37.19.205.202";
    in
    {
      wg0 = {
        # IP address of this machine in the *tunnel network*
        address = [ "10.2.0.2/32" ];
        dns = [ "10.2.0.1" ];
        autostart = false;

        # To match firewall allowedUDPPorts (without this wg
        # uses random port numbers).
        listenPort = 51820;

        # Path to the private key file.
        privateKeyFile = "/etc/proton/wireguard.key";

        peers = [
          {
            publicKey = "rnrZQSK5IeTCzh60Ghv/TEaUIbD7IprzdoCJjE5E9Sc=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "${server_ip}:51820";
            persistentKeepalive = 25;
          }
        ];

        postUp = ''
          ${pkgs.wireguard-tools}/bin/wg set wg0 fwmark 51820
          ${pkgs.iptables}/bin/iptables -A OUTPUT \
            ! -o wg0 \
            -m mark ! --mark $(${pkgs.wireguard-tools}/bin/wg show wg0 fwmark) \
            -m addrtype ! --dst-type LOCAL \
            -j REJECT
          ${pkgs.iptables}/bin/ip6tables -A OUTPUT \
            ! -o wg0 \
            -m mark ! --mark $(${pkgs.wireguard-tools}/bin/wg show wg0 fwmark) \
            -m addrtype ! --dst-type LOCAL \
            -j REJECT
        '';

        preDown = ''
          ${pkgs.iptables}/bin/iptables -D OUTPUT \
            ! -o wg0 \
            -m mark ! --mark $(${pkgs.wireguard-tools}/bin/wg show wg0 fwmark) \
            -m addrtype ! --dst-type LOCAL \
            -j REJECT
          ${pkgs.iptables}/bin/ip6tables -D OUTPUT \
            ! -o wg0 \
            -m mark ! --mark $(${pkgs.wireguard-tools}/bin/wg show wg0 fwmark) \
            -m addrtype ! --dst-type LOCAL \
            -j REJECT
        '';

      };
    };
}
