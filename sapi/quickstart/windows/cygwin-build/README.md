## cygwin workdir

```shell

  DISK_DRIVE=$( df -h / | sed -n '2p' | awk '{ print $1 }' )$(pwd)
  echo $DISK_DRIVE
  WIND_DIR=$(echo $DISK_DRIVE | sed 's/\//\\/g')

```

## 自动安装 cygwin 和  cygwin 依赖项

```bash

# 自动安装 cygwin 和  cygwin 依赖项
.\sapi\quickstart\windows\cygwin-build\download-cygwin.bat
.\sapi\quickstart\windows\cygwin-build\install-cygwin.bat


```

### cygwin mirror

    https://cygwin.com/mirrors.html
