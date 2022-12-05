
#!/bin/bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

test -d tmp && sudo rm -rf tmp
mkdir -p tmp
rsync -avr --delete-before --stats --progress ${__DIR__}/ ${__DIR__}/tmp/ \
--exclude ${__DIR__}/tmp

# docker run --rm --name swoole-cli-build-dev -v ${__DIR__}/tmp:/work -w /work -ti --init  docker.io/jingjingxyk/build-swoole-cli:alpine-edge-20221205T144525Z
image=$(cat build-base-container.txt)
docker run --rm --name swoole-cli-build-dev -v ${__DIR__}/tmp:/work -w /work  docker.io/jingjingxyk/build-swoole-cli:alpine-edge-20221205T144525Z

docker exec -i swoole-cli-build-dev  php prepare.php +inotify +mongodb


