FROM alpine:edge

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN test -f /etc/apk/repositories.save || cp /etc/apk/repositories /etc/apk/repositories.save
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update && apk upgrade
RUN apk add --no-cache alpine-sdk xz autoconf automake linux-headers clang-dev clang lld libtool  cmake  tini
RUN apk add --no-cache flex bison re2c pkgconf ca-certificates gnutls-dev

RUN apk add --no-cache icu icu-dev icu-libs icu-data-full icu-static
RUN apk add --no-cache ncurses-dev ncurses-libs ncurses-static
RUN apk add --no-cache readline readline-dev readline-static
RUN apk add --no-cache libidn2 libidn2-dev  libidn2-static
RUN apk add --no-cache nghttp2-dev nghttp2-libs nghttp2-static

ENV CC=clang
ENV CXX=clang++
ENV LD=ld.lld
#RUN mv /usr/bin/ld /usr/bin/ld.old && ln -s /usr/bin/ld.lld /usr/bin/ld
WORKDIR /work

RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
RUN cp -f /etc/apk/repositories.save /etc/apk/repositories
