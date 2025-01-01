## msys2 安装

# 打开站点：
#
#  https://mirrors.tuna.tsinghua.edu.cn/msys2/distrib/x86_64/

wget https://mirrors.tuna.tsinghua.edu.cn/msys2/distrib/x86_64/msys2-x86_64-20230318.exe

# msys2 help
# https://mirror.tuna.tsinghua.edu.cn/help/msys2/

# 搜索包
pacman -Ss curl
# 升级
pacman -Syu
# 无须确认安装包
pacman -Sy --noconfirm git curl wget openssl

pacman -Syy --noconfirm curl wget openssl zip unzip xz gcc gcc-g++ cmake make

pacman -Syy --noconfirm openssl-devel libreadline

pacman -Syy --noconfirm lzip
