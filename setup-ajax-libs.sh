#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}
shopt -s expand_aliases
cd ${__PROJECT__}

while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},::1/128,fe80::/10,fd00::/8,ff00::/8"
    NO_PROXY="${NO_PROXY},localhost"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com,.tencent.com"
    NO_PROXY="${NO_PROXY},.myqcloud.com,.swoole.com"
    export NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn,.npmmirror.com"
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

if [[ ! -f ${__PROJECT__}/runtime/node/bin/node ]]; then
  if [[ "$MIRROR" == "china" ]]; then
    curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-nodejs-runtime.sh?raw=ture | bash -s -- --mirror china
  else
    curl -fSL https://github.com/jingjingxyk/swoole-cli/blob/new_dev/setup-nodejs-runtime.sh?raw=ture | bash
  fi
fi
export PATH="${__PROJECT__}/runtime/node/bin/:$PATH"

mkdir -p ${__PROJECT__}/runtime/ajax/libs/

test -d ${__PROJECT__}/var/ajax/libs/ && rm -rf ${__PROJECT__}/var/ajax/libs/

mkdir -p ${__PROJECT__}/var/ajax/libs/
cd ${__PROJECT__}/var/ajax/libs/


test -d reveal.js/.git || git clone -b 4.3.1   https://github.com/hakimel/reveal.js.git --depth=1  --progress
test -d Modernizr/.git ||  git clone -b v3.12.0  https://github.com/Modernizr/Modernizr.git  --depth=1  --progress
# test -d samples/.git ||  git clone https://github.com/webrtc/samples.git  --depth=1  --progress
test -d frontend-utils/.git ||  git clone -b main https://github.com/jingjingxyk/frontend-utils.git  --depth=1 --progress
test -f adapter-latest.js || wget -O adapter-latest.js	https://webrtc.github.io/adapter/adapter-latest.js
test -d highlight.js/.git || git clone -b 11.6.0	https://github.com/highlightjs/highlight.js.git --depth=1  --progress
# test -d three.js/.git || git clone -b 11.6.0	https://github.com/mrdoob/three.js.git --depth=1  --progress

test -d marked/.git || git clone -b v4.1.0	https://github.com/markedjs/marked.git --depth=1  --progress
test -d svelte-jsoneditor/.git || git clone -b main https://github.com/josdejong/svelte-jsoneditor.git --depth=1 --progress
#test -d SIP.js/.git || git clone -b main https://github.com/onsip/SIP.js.git --depth=1 --progress
test -d SIP.js/.git || git clone -b 0.21.2 https://github.com/onsip/SIP.js.git --depth=1 --progress

curl -Lo opencv.js https://docs.opencv.org/5.x/opencv.js

unset http_proxy
unset https_proxy

cd ${__PROJECT__}/var/ajax/libs/
cd  reveal.js/
#npm install
#npm run build
mkdir -p ${__PROJECT__}/runtime/ajax/libs/reveal.js/4.3.1
cp -rf  dist/* ${__PROJECT__}/runtime/ajax/libs/reveal.js/4.3.1/
cp -rf  plugin ${__PROJECT__}/runtime/ajax/libs/reveal.js/4.3.1/


cd ${__PROJECT__}/var/ajax/libs/
mkdir -p ${__PROJECT__}/runtime/ajax/libs/jingjingxyk/frontend-utils/
cp -f frontend-utils/utils.js ${__PROJECT__}/runtime/ajax/libs/jingjingxyk/frontend-utils/utils.js


cd ${__PROJECT__}/var/ajax/libs/
mkdir -p ${__PROJECT__}/runtime/ajax/libs/webrtc/adapter
cp -rf adapter-latest.js ${__PROJECT__}/runtime/ajax/libs/webrtc/adapter


cd ${__PROJECT__}/var/ajax/libs/
cd marked
npm install
npm run build

mkdir -p ${__PROJECT__}/runtime/ajax/libs/marked/v4.1.0
cp -rf marked.min.js  ${__PROJECT__}/runtime/ajax/libs/marked/v4.1.0
cp -rf lib/*  ${__PROJECT__}/runtime/ajax/libs/marked/v4.1.0


cd ${__PROJECT__}/var/ajax/libs/
mkdir -p ${__PROJECT__}/runtime/ajax/libs/opencv/5.x/
cp -f opencv.js ${__PROJECT__}/runtime/ajax/libs/opencv/5.x/

cd ${__PROJECT__}/var/ajax/libs/
mkdir -p ${__PROJECT__}/runtime/ajax/libs/sip.js/0.21.2
cd SIP.js
npm install
npm run build
npm run build-bundles
cp -rf lib ${__PROJECT__}/runtime/ajax/libs/sip.js/0.21.2
cp -rf dist/* ${__PROJECT__}/runtime/ajax/libs/sip.js/0.21.2

cd ${__PROJECT__}/var/ajax/libs/
cd Modernizr/
npm install
./bin/modernizr --help
./bin/modernizr -c lib/config-all.json --uglify -d modernizr.min.js
mkdir -p ${__PROJECT__}/runtime/ajax/libs/modernizr/3.12.0/
cp modernizr.min.js ${__PROJECT__}/runtime/ajax/libs/modernizr/3.12.0/

exit 0
cd ${__PROJECT__}/var/ajax/libs/
cd highlight.js
npm install
npm run build-cdn

mkdir -p ${__PROJECT__}/runtime/ajax/libs/highlight.js/11.6.0
cp -rf build/* ${__PROJECT__}/runtime/ajax/libs/highlight.js/11.6.0


cd ${__PROJECT__}

