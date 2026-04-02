# 本机安装工具命令表

用于查找和提醒本机已安装工具。脚本与可执行文件根目录：`/home/xiaoguo0426/my-commands`（在 shell 里一般为 `$mycommands`）。

## 表格里怎么换行

在 GFM（GitHub / VS Code / Cursor 预览）中，表格单元格内不能直接回车换行，可在需要断行处写 `<br>` 或 `<br/>`。

## 快捷命令一览

| 命令名           | 描述                                                    |
|---------------|-------------------------------------------------------|
| `lw`          | 进入 laradock workspace 容器（`$mycommands/lw`）            |
| `laradock`    | 自定义 laradock 项目封装（`$mycommands/laradock`）             |
| `ld`          | `laradock` 的别名                                        |
| `lazydocker`  | 终端里快速查看 / 管理 Docker（`$mycommands/lazydocker`）         |
| `lzd`         | `lazydocker` 的别名                                      |
| `lazyssh`     | 终端 GUI 式 SSH 连接（`$mycommands/lazyssh`）                |
| `s`           | `lazyssh` 的别名                                         |
| `swoole`      | Swoole CLI（`$mycommands/swoole-cli`）                  |
| `g`           | 终端 Git UI（`$mycommands/lazygit`）                      |
| `lazyjournal` | 日志 / 日记类工具（`$mycommands/lazyjournal`）                 |
| `json`        | JSON 格式化与校验（`$mycommands/json.sh`，底层为 `jq`；详见下文）      |
| `jsonc`       | `json -c` 的别名（压缩为单行）                                  |
| `btop`        | 资源监控 TUI（`$mycommands/btop/bin/btop`）                 |
| `nvim`        | Neovim（`/home/xiaoguo0426/softwares/nvim/bin/nvim`）   |
| `csv`         | CSV 相关脚本（`$mycommands/tennis`）                        |
| `ls`          | 使用 `lsd` 列目录                                          |
| `ll`          | `lsd -l`                                              |
| `la`          | `lsd -la`                                             |
| `lt`          | `lsd --tree` 树形列出                                     |
| `l`           | `lsd -lA`                                             |
| `sd`          | `systemd-manager-tui` 管理 systemd 单元                   |
| `c`           | 用 `glow` 渲染本说明：`glow $mycommands/custome-commands.md` |
| `proxy`       | 开关本机代理：`proxy --on` / `proxy --off`，无参数时显示用法与当前状态     |
| `y`           | 启动 `yazi`，退出后若切换了目录则 `cd` 到该目录                        |
| `btop`        | `btop` 命令                                             |
| `glow`        | `glow` 命令 用于在终端中渲染markdown文档                          |
| `mkcert`        | `mkcert` 命令 用于生成自签名证书                          |
## `laradock` 子命令说明

在终端中直接使用，例如 `laradock ps`。

| 子命令 | 说明 |
| --- | --- |
| `laradock ps` | 列出 laradock 相关容器状态 |
| `laradock logs [container]` | 查看指定容器日志 |
| `laradock restart [container]` | 重启指定容器 |
| `laradock up [container]` | 启动指定容器 |
| `laradock stop [container]` | 停止指定容器 |
| `laradock exec [container]` | 进入指定容器 shell |

## `json` 命令用法

基于 `jq` 的 JSON 格式化工具：可读缩进、压缩单行、自定义缩进宽度；支持从**文件**、**命令行字符串**或**标准输入**读入。

| 子命令 | 说明 |
| --- | --- |
| `json data.json` | 格式化输出json数据 |
| `json '{"a":1}'` | 格式化输出json数据 |
| `echo '{"a":1}' \| json` | 格式化输出json数据 |
| `json -c data.json` | 压缩输出json数据 |
| `json -c '{"a": 1}'` | 压缩输出json数据 |
| `jsonc` | 等价于 `json -c` |


## `mkcert` 命令用法

用于生成自签名证书，方便在本地开发环境中使用 HTTPS。

| 子命令 | 说明 |
| --- | --- |
| `mkcert -install` | 安装 mkcert 到系统证书存储 |
| `mkcert example.com "*.example.com"` | 生成证书用于 example.com 和 所有子域名 |
| `mkcert -key-file key.pem -cert-file cert.pem example.com` | 使用 -cert-file 和 -key-file 选项可以指定证书和密钥的保存位置和文件名 |
