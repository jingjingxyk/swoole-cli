
set -exu

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)

__PROJECT__=$(
  cd ${__DIR__}/../
  pwd
)

cd ${__PROJECT__}

test -d pool/ext && rm -rf pool/ext ;
test -d pool/ext && rm -rf pool/ext ;
test -d thirdparty && rm -rf thirdparty/* ;
