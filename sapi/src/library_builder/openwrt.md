## download openwrt x86

    https://downloads.openwrt.org/releases/

    https://downloads.openwrt.org/releases/23.05.4/targets/x86/64/

## OpenWrt on VirtualBox

    https://openwrt.org/docs/guide-user/virtualization/virtualbox-vm

## virtualbox img 文件转换为 vdi

> https://openwrt.org/docs/guide-user/virtualization/virtualbox-vm#convert_openwrtimg_to_vbox_drive

```shell

# img 文件转换为 vdi

VBoxManage convertfromraw  --format VDI ~/Downloads/openwrt/openwrt-23.05.4-x86-64-generic-ext4-combined.img ~/Downloads/openwrt/openwrt-23.05.4-x86-64-generic-ext4-combined.vdi

# 修改磁盘大小
VBoxManage modifyhd --resize 8096 ~/Downloads/openwrt/openwrt-23.05.4-x86-64-generic-ext4-combined.vdi

```

```shell

qemu-img resize -f raw ./openwrt.img 5G

```

把云服务器系统 dd 成 openwrt ，当云路由器用

VirtualBox 上的 OpenWrt 操作指南
https://openwrt.org/docs/guide-user/virtualization/virtualbox-vm#troubleshooting

https://openwrt.org/docs/guide-user/installation/openwrt_x86

https://archive.openwrt.org/releases/

openwrt Virtualization
https://openwrt.org/docs/guide-user/virtualization/start

VirtualBox 上的 OpenWrt 网络配置
https://openwrt.org/docs/guide-user/virtualization/virtualbox-vm

## download openwrt

    https://mirrors.ustc.edu.cn/help/openwrt.html
    https://mirrors.ustc.edu.cn/openwrt/

## openwrt 初始化

    test -f /etc/opkg/distfeeds.conf.back || cp /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf.back
    sed -i 's/downloads.openwrt.org/mirrors.ustc.edu.cn\/openwrt/g' /etc/opkg/distfeeds.conf
    # 更新索引
    opkg update
    # 安装中文语言包
    opkg install luci-i18n-base-zh-cn

    # 包安装命令
    # https://openwrt.org/packages/start
    # opkg list | grep luci-theme-
    # opkg list | grep wireguard
    opkg install luci-theme-material
    opkg install curl bash git xz unzip
    opkg remove luci-theme-openwrt
    opkg install wireguard-tools
    # 多wan
    opkg install mwan3 luci-app-mwan3

## openwrt 磁盘扩容

    opkg install cfdisk fdisk e2fsprogs
    opkg install lsblk fdisk losetup blkid f2fs-tools tree
    df -Th
    lsblk -f
    fdisk -l

    # 分区扩容 (e2fsprogs 包含resize2fs）
    opkg update
    opkg install cfdisk fdisk e2fsprogs resize2fs tune2fs
    cfdisk
    umount /

    resize2fs /dev/sda2 2G
    e2fsck -f /dev/sda2

    tune2fs -O^resize_inode /dev/sda2
    mount -o remount,rw /

    # mount -o remount,ro /    # 命令将根文件系统重新挂载为只读模式。

## openwrt 配置网络

    vi /etc/config/network

## macos 设置路由 ,virtualbox 仅主机网络

    sudo route add -net 192.168.56.0/24 192.168.56.1
    sudo route delete 192.168.56.0/24
    netstat -rn

## openwrt 能远程访问，需要开启防火墙配置

    INTERFACE=eth3
    PORT=22
    iptables -I INPUT -i $INTERFACE -p tcp --dport $PORT -j ACCEPT
    iptables -I INPUT -i eth3 -p tcp --dport 80 -j ACCEPT

## 路由器组网协议

    OSPF （常用路由器之间组网）
    ISIS (运营商使用）

## wireguard 辅助工具

    默认端口： 51820
    udp2raw
    phantun
    官方建议将 MTU 的值设为 1428

## 透明网关的使用 例子

    方法一：
    路由器 192.168.20.1 加 MASQUERADE：
    iptables -t nat -A POSTROUTING -s 192.168.20.0/24 -d 7.0.0.0/8 -j MASQUERADE

    方法二：
    每个客户端机器都加静态路由：
    ip route add 7.0.0.0/8 via 192.168.20.5 (linux)
    route add 7.0.0.0 mask 255.0.0.0 192.168.20.5 (windows)

    方式三：将客户端机器的网关配置成透明网关 ip

## 路由器可结合iptables或dnsmasq设置透明代理
