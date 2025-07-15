```shell


tcpdump -i eth0 -nn 'icmp6 && (ip6[40] == 135 || ip6[40] == 136)'  # IPv6 NS/NA 消息
tcpdump -i eth0 -nn 'arp'

ip netns exec vm1 arp

# 抓包确认邻居交互
ip netns exec vm1 tcpdump -i vm1 -nn 'arp'
ip netns exec vm1 tcpdump -i vm1 -nn 'icmp4 && (ip4[40] == 135 || ip4[40] == 136)'

ip netns exec vm1 sysctl -a | grep 'net.ipv4.neigh.*reachable_time'
ip netns exec vm1 sysctl -a | grep 'net.ipv6.neigh.*reachable_time'

ip -s neigh flush all  # 清除所有邻居条目，系统会自动重建

ip netns exec vm1 ip -s neigh flush all


```

```shell
tcpdump -i any -nn port 6081
tcpdump -i any -nnn udp  port 6081


tcpdump -vne -i  genev_sys_6081
tcpdump -vne -i eth0
tcpdump -vne -i eth0 src host  192.168.3.26

```

## netstat 逐渐被弃用，推荐使用 ss 和 ip 命令

```shell
# 查看所有 TCP 端口占用
lsof -i TCP
lsof -i UDP

# 查看所有监听端口
lsof -i -sTCP:LISTEN

# 查看特定用户（如 root）的所有网络连接
lsof -i -u root

# 查看特定用户的网络活动：
lsof -i -u root

lsof -i -c nginx

ss -tunlp

```
