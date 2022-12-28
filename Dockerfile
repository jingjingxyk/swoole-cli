FROM alpine:edge

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN test -f /etc/apk/repositories.save || cp /etc/apk/repositories /etc/apk/repositories.save
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update && apk upgrade
RUN apk add --no-cache alpine-sdk xz autoconf automake linux-headers clang-dev clang lld libtool  cmake  tini
RUN apk add --no-cache flex bison re2c pkgconf ca-certificates gnutls-dev

RUN apk add --no-cache icu icu-dev icu-libs icu-data-full icu-static
RUN apk add --no-cache ncurses-dev ncurses-libs ncurses-static
RUN apk add --no-cache readline readline-dev readline-static
# 为了zip 静态库能顺利安装
RUN apk add --no-cache bzip2 bzip2-dev bzip2-static
RUN apk add --no-cache zstd zstd-dev zstd-libs
RUN apk add --no-cache xz xz-dev xz-libs


# chown -R 1000:1000 /work 允许容器外用户修改文件

# 解决容器内用户是root，容器容器外用户非root,预处理时屏蔽警告
# RUN  git config --global --add safe.directory '*'


ENV CC=clang
ENV CXX=clang++
ENV LD=ld.lld
#RUN mv /usr/bin/ld /usr/bin/ld.old && ln -s /usr/bin/ld.lld /usr/bin/ld
WORKDIR /work

RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
RUN cp -f /etc/apk/repositories.save /etc/apk/repositories
