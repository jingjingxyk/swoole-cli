#!/bin/bash

set -exu

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

cd /work/
sh make.sh openssl_3

# test -d lib64 || ln -s /usr/openssl/lib /usr/openssl/lib64

# 重新构建了openssl，依赖openssl的需要重新构建
sh make.sh zip
sh make.sh curl
sh make.sh pgsql
sh make.sh icu_2
sh make.sh cares_2
sh make.sh libffi


