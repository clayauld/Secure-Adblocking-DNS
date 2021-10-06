#!/bin/bash

set -e

# Set route_localnet = 1 on all interfaces so that ssl can use "localhost" as
# destination
sysctl -w net.ipv4.conf.default.route_localnet=1
sysctl -w net.ipv4.conf.all.route_localnet=1

# DROP martian packets as they would have been if route_localnet was zero
# Note: packets not leaving the server aren't affected by this, thus sslh/stunnel will
# still work
iptables -t raw -A PREROUTING ! -i lo -d 127.0.0.0/8 -j DROP
iptables -t mangle -A POSTROUTING ! -o lo -s 127.0.0.0/8 -j DROP

# Mark all connections made by ssl for special treatment (here stunnel connects to 127.0.0.1)
iptables -t nat -A OUTPUT -d 127.0.0.1 -p tcp --tcp-flags FIN,SYN,RST,ACK SYN -j CONNMARK --set-xmark 0x01/0x0f

# Outgoing packets that should go to sslh/stunnel/nginx instead have to be rerouted, so mark
# them accordingly (copying over the connection mark)
iptables -t mangle -A OUTPUT ! -o lo -p tcp -m connmark --mark 0x01/0x0f -j CONNMARK --restore-mark --mask 0x0f

# Configure routing for those marked packets
ip rule add fwmark 0x1 lookup 100
ip route add local 0.0.0.0/0 dev lo table 100
