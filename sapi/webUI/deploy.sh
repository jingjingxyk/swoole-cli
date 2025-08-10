#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=${__DIR__}

cd ${__PROJECT__}

if [ -f runtime/node/bin/node ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-nodejs-runtime.sh?raw=ture | bash -s -- --mirror china
fi

if [ -f runtime/php/php ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-php-runtime.sh?raw=ture | bash -s -- --mirror china
fi

export PATH="${__PROJECT__}/runtime/node/bin/:${__PROJECT__}/runtime/php/:$PATH"

npm install pnpm --registry=https://registry.npmmirror.com

bash sync-frontend-library.sh
