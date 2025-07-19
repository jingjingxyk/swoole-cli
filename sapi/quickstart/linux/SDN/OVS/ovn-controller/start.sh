#!/usr/bin/env bash

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}
export PATH=$PATH:/usr/local/share/openvswitch/scripts
export PATH=$PATH:/usr/local/share/ovn/scripts
set -exu

PROC_NUM=$(ps -ef | grep 'ovn-controller unix:/usr/local/var/run/openvswitch/db.sock' | grep -v grep | wc -l)
if test $PROC_NUM -gt 0; then
  echo 'ovn-controller is running '
  exit 0
fi

sh reset.sh

ipv6=$(ip -6 address show | grep inet6 | awk '{print $2}' | cut -d'/' -f1 | sed -n '2p')
ipv4=$(ip -4 address show | grep inet | grep -v 127.0.0 | awk '{print $2}' | cut -d'/' -f1 | sed -n '1p')

domain="ovn-central.example.com"
# IP=$(nslookup "$domain" 223.5.5.5 | awk '/^Address: / {print $2}')
IP=$(dig +short @223.5.5.5 "$domain")
# IP=$(host -t A "$domain" | awk '/ has address / {print $4}')

OVN_CENTRAL_IP="192.168.3.251"
OVN_CENTRAL_IP="${IP}"

HOSTNAME="ovn-node-1"
EXTERNAL_IP="$ipv4,$ipv6"
LOCAL_IP="$ipv4,$ipv6"
# ENCAP_TYPE="geneve"
ENCAP_TYPE="geneve,vxlan"
# mac in udp
# geneve default port number 6081
# vxlan  default port number 4789

test -f /usr/local/etc/openvswitch/conf.db && rm -rf /usr/local/etc/openvswitch/conf.db
test -f /usr/local/etc/ovn/conf.db && rm -rf /usr/local/etc/ovn/conf.db

ID_FILE=system-id.conf
test -s $ID_FILE || cat /proc/sys/kernel/random/uuid >$ID_FILE

CHASSIS_NAME=$(cat $ID_FILE)
ovs-ctl start --system-id=${CHASSIS_NAME}

ovs-vsctl set Open_vSwitch . \
  external_ids:system-id="${CHASSIS_NAME}" \
  external_ids:hostname="${HOSTNAME}" \
  external_ids:ovn-encap-ip="${EXTERNAL_IP}" \
  external_ids:ovn-set-local-ip="${LOCAL_IP}" \
  external_ids:ovn-encap-type="${ENCAP_TYPE}" \
  external_ids:ovn-remote="tcp:${OVN_CENTRAL_IP}:6642"

# mtu_request=1442
# ovs-vsctl set Open_vSwitch . mtu_request=1442

# external_ids:ovn-nb="tcp:$CENTRAL_IP:6641"

# ovs-vsctl set open . external_ids:ovn-remote-probe-interval=<TIME IN MS>
# ovs-vsctl set open . external_ids:ovn-remote-probe-interval=30000

ovn-ctl start_controller

ovs-vsctl --columns external_ids list open_vswitch

ovs-vsctl get open . external-ids

# ovs-vsctl get Open_vSwitch mtu_request

sleep 5
ovs-vsctl list-ports br-int
# ovs-vsctl set br-int mtu_request=1442

# ovs-vsctl set open . external-ids:system-id={新的chassis ID}
# ovs-vsctl set open . external-ids:hostname={新的主机名}

ovs-ctl status

ss -lnup | grep 6081

# ovs-vsctl list Interface br-int | grep mtu
