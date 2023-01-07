#!/bin/bash

set -exu

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

cd /work/
sh make.sh openssl_1
sh make.sh zip
sh make.sh curl

