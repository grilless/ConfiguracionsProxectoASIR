#!/bin/bash
# Activar o forwarding para que Linux actúe como router nativo
echo 1 > /proc/sys/net/ipv4/ip_forward
# Limpieza iptable
iptables -F
iptables -t nat -F
iptables -X
iptables -t nat -X
#Todo o que non se permita explicitamente máis abaixo, queda bloqueado.
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
# Permite tráfico interno de loopback
iptables -A INPUT -i lo -j ACCEPT
# Regra de estado: permite que o router reciba respostas ás súas propias peticións
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# Permitir que as subredes internas falen co router.
iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# Acceso a internet
iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
# Permitir que as subredes inicien conexións cara ao exterior
iptables -A FORWARD -i ens37 -o ens33 -j ACCEPT
iptables -A FORWARD -i ens38 -o ens33 -j ACCEPT
iptables -A FORWARD -i ens39 -o ens33 -j ACCEPT
iptables -A FORWARD -i ens40 -o ens33 -j ACCEPT
iptables -A FORWARD -i ens40 -o ens37 -j ACCEPT
iptables -A FORWARD -i ens40 -o ens38 -j ACCEPT
iptables -A FORWARD -i ens40 -o ens39 -j ACCEPT
iptables -A FORWARD -i ens38 -o ens37 -j ACCEPT
iptables -A FORWARD -i ens38 -o ens39 -j ACCEPT
iptables -A FORWARD -i ens39 -o ens37 -s 192.168.4.0/24 -d 192.168.2.0/24 -j ACCEPT
iptables -A FORWARD -i ens37 -o ens39 -s 192.168.2.0/24 -d 192.168.4.0/24 -j ACCEPT
# Cando alguén fóra (ens33) busque a IP pública do router, mándase á web da DMZ.
iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 80 -j DNAT --to-destination 192.168.4.10:80
# Permitir estritamente que ese tráfico HTTP cruzado pase polo Firewall
iptables -A FORWARD -i ens33 -o ens39 -p tcp --dport 80 -d 192.168.4.10 -j ACCEPT

mkdir -p /etc/iptables
iptables-save > /etc/iptables/rules.v4

