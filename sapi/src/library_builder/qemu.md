## qemu for macos

https://medium.com/code-uncomplicated/virtual-machines-on-macos-with-qemu-intel-based-351b28758617

```bash

brew install qemu

```

qemu-kvm + libvirt + webvirtmanager
qemu+kvm 做虚拟化, libvirt 做 qemu 编排管理
装 Proxmox 开 KVM 虚拟机


```shell
# reference
# https://github.com/tonistiigi/binfmt/releases

docker run --privileged --rm tonistiigi/binfmt:qemu-v10.0.4-59 --uninstall qemu-*
docker run --privileged --rm tonistiigi/binfmt:qemu-v10.0.4-59 --install all

```
