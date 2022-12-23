FROM alpine:edge

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN test -f /etc/apk/repositories.save || cp /etc/apk/repositories /etc/apk/repositories.save
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update && apk upgrade
RUN apk add --no-cache alpine-sdk xz autoconf automake linux-headers clang-dev clang lld libtool  cmake  tini
RUN apk add --no-cache flex bison re2c pkgconf ca-certificates gnutls-dev

ENV CC=clang
ENV CXX=clang++
ENV LD=ld.lld
#RUN mv /usr/bin/ld /usr/bin/ld.old && ln -s /usr/bin/ld.lld /usr/bin/ld
WORKDIR /work

RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
RUN cp -f /etc/apk/repositories.save /etc/apk/repositories
