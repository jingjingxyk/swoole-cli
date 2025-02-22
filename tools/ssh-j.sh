# ssh 通过 跳板机 连接 目标服务器


ip='demo.jingjingxyk.com'
keyfile=/home/jingjingxyk/beijing-2022-05-27.pem

{
  #其中 -C 为压缩数据，-q 安静模式，-T 禁止远程分配终端，-n 关闭标准输入，-N 不执行远程命令。此外视需要还可以增加 -f 参数，把 ssh 放到后台运行。
  ssh \
    -J root@jump.jingjingxyk.com:22 \
    -o StrictHostKeyChecking=no \
    -o ExitOnForwardFailure=yes \
    -o TCPKeepAlive=yes \
    -o ServerAliveInterval=15 \
    -o ServerAliveCountMax=3 \
    -i $keyfile \
    root@$ip
} || {
  echo $?

}

#    curl --proxycommand 'ssh pi@raspberrypi.local -W 10.1.1.75 80'
#    ssh -o ProxyCommand="ssh -W %h:%p <jump server>" <remote target>


# 添加一个循环
# until ssh -R 23334:localhost:22 -t B-username@B-IPAddress top ; do true ; done

# (while true; do
#  socat TCP4-LISTEN:5901 TCP4:192.168.1.2:5900
# done) &

# 参考 SSH 命令的三种代理功能（-L/-R/-D）
# https://zhuanlan.zhihu.com/p/57630633
