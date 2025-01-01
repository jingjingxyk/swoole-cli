#!/usr/bin/env bash

set -x
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

__PROJECT__=$(
  cd ${__DIR__}/../../../../
  pwd
)
cd ${__PROJECT__}
mkdir -p ${__PROJECT__}/var/kubernetes/
cd ${__PROJECT__}/var/kubernetes/

while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    NO_PROXY="127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16"
    NO_PROXY="${NO_PROXY},127.0.0.1,localhost"
    NO_PROXY="${NO_PROXY},.aliyuncs.com,.aliyun.com"
    NO_PROXY="${NO_PROXY},.tsinghua.edu.cn,.ustc.edu.cn"
    NO_PROXY="${NO_PROXY},.tencent.com"
    NO_PROXY="${NO_PROXY},.sourceforge.net"
    NO_PROXY="${NO_PROXY},.npmmirror.com"
    export NO_PROXY="${NO_PROXY}"
    ;;

  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done

# shellcheck disable=SC2034
OS=$(uname -s)
# shellcheck disable=SC2034
ARCH=$(uname -m)


mkdir -p calico
cd calico

# CNI calico
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises
# https://github.com/projectcalico/calico/tags
VERSION="3.27.5"
curl -Lo calico-v${VERSION}.yaml https://raw.githubusercontent.com/projectcalico/calico/v${VERSION}/manifests/calico.yaml

kubectl create -f calico-v${VERSION}.yaml

curl -fSL https://github.com/projectcalico/calico/releases/download/v${VERSION}/calicoctl-linux-amd64 -o calicoctl
chmod +x ./calicoctl
mv ./calicoctl /usr/local/bin/

# more info
# https://docs.tigera.io/calico/latest/operations/calicoctl/configure/overview

export DATASTORE_TYPE=kubernetes
export KUBECONFIG=~/.kube/config
calicoctl get nodes
calicoctl get workloadendpoints
