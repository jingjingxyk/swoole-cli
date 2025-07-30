#!/usr/bin/env bash

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}modprobe geneve

# ip link add geneve0 type geneve id 100 remote 192.168.1.1
# 指定服务端口
# ip link add geneve0 type geneve id 200 remote 192.168.1.1 dstport 6081

ip link show geneve0

ip link set geneve0 up
ip link show geneve0
ip addr add 10.13.1.1/24 dev geneve0
ip addr add fd00:XXXX:XXXX::/64 dev geneve0
ip addr show geneve0

tcpdump -i any -nnn udp port 6081
