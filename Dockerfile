FROM alpine:edge

# setup source repo, install dependencies
#RUN echo -ne 'https://mirrors.ustc.edu.cn/alpine/edge/main\nhttps://mirrors.ustc.edu.cn/alpine/edge/community\n' > /etc/apk/repositories && \
RUN test -f /etc/apk/repositories.save || cp /etc/apk/repositories /etc/apk/repositories.save
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
apk update && apk upgrade && \
apk add --no-cache vim alpine-sdk xz autoconf automake linux-headers clang-dev clang lld libtool cmake && \
apk add --no-cache  ca-certificates openssl openssl-dev libpq-dev bison xz-dev  libzip-dev && \
apk add --no-cache php81-dev php81-cli php81-pear php81-curl php81-openssl &&  \
pecl channel-update https://pecl.php.net/channel.xml

ENV CC=clang
ENV CXX=clang++
ENV LD=ld.lld
#RUN mv /usr/bin/ld /usr/bin/ld.old && ln -s /usr/bin/ld.lld /usr/bin/ld
WORKDIR /work

RUN rm -rf /var/cache/apk/* /tmp
