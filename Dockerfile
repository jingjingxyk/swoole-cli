FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# setup source repo, install dependencies
RUN test ! -f /etc/apt/source.list.save && cp  /etc/apt/sources.list /etc/apt/sources.list.save

RUN sed -i "s@deb.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
RUN sed -i "s@security.debian.org@mirrors.ustc.edu.cn@g" /etc/apt/sources.list

RUN sed -i "s@security.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list
RUN sed -i "s@archive.ubuntu.com@mirrors.ustc.edu.cn@g" /etc/apt/sources.list


RUN apt update -y && apt install -y curl sudo tini libssl-dev ca-certificates
RUN apt install -y  autoconf automake  libclang-dev clang lld libtool cmake python3-pip python3 python3-dev
RUN apt install -y  libcrypto++-dev libzip-dev zip xz-utils liblzma-dev lz4 liblz4-dev

RUN apt install -y libreadline-dev lzip libbz2-dev libgmp-dev libticonv-dev

RUN apt install -y  libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc ccache


RUN apt install -y php-dev php-cli php-pear php-curl &&  \
pecl channel-update https://pecl.php.net/channel.xml && pear update-channels


ENV CC=clang
ENV CXX=clang++
ENV LD=ld.lld
#RUN mv /usr/bin/ld /usr/bin/ld.old && ln -s /usr/bin/ld.lld /usr/bin/ld
WORKDIR /work

RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
RUN cp -f /etc/apt/sources.list.save /etc/apt/sources.list
