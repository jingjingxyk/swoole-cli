## docker compose 配置

    entrypoint: 容器启动时执行的主命令。
    command: 传递给 entrypoint 的参数，或者在没有自定义 entrypoint 时，作为容器的主命令执行。

## 容器 command 配置 nginx -g "daemon off;" 用途

    强制 Nginx 在前台运行，保持与终端的关联，直接输出日志到控制台，且进程不会转入后台

## docker compose healthcheck example

```yaml
    healthcheck:
      test: [ "CMD-SHELL", "curl -f http://domain:8080 || exit 1" ]
      interval: 1m30s
      timeout: 10s
      retries: 5
      start_period: 10s

```
