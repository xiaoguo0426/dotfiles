# dotfiles

个人 Ubuntu 开发环境配置文件，一键安装和配置开发工具。

## 快速开始

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
chmod +x setup.sh
./setup.sh
```

安装完成后，重新登录系统或运行：

```bash
newgrp docker && source ~/.zshrc
```

## 项目结构

```
dotfiles/
├── setup.sh                      # 主安装脚本
├── uninstall.sh                  # 卸载脚本
├── .zshrc                        # Zsh 配置
├── .p10k.zsh                     # Powerlevel10k 主题配置
├── .vimrc                        # Vim 配置
├── .oh-my-zsh/                   # Oh-My-Zsh 自定义配置
│   ├── aliases.zsh               # 别名定义
│   ├── functions.zsh             # 自定义函数
│   └── my-commands/              # 自定义命令
│       ├── laradock              # Laradock 管理命令
│       ├── lw                    # 快速进入 workspace
│       ├── json.sh               # JSON 处理工具
│       ├── tennis                # Tennis 工具
│       └── ...                   # 其他实用脚本
├── docker/
│   └── daemon.json               # Docker 守护进程配置
├── ghostty/
│   └── config/config             # Ghostty 终端配置
├── lsd/
│   └── config.yaml               # LSD (现代 ls) 配置
├── nvim/                         # Neovim 配置 (LazyVim)
│   ├── init.lua
│   ├── lua/
│   │   ├── config/
│   │   │   ├── autocmds.lua
│   │   │   ├── keymaps.lua
│   │   │   ├── lazy.lua
│   │   │   └── options.lua
│   │   └── plugins/
│   │       └── example.lua
│   ├── lazy-lock.json
│   └── stylua.toml
├── gnome-extensions.txt          # GNOME 扩展列表
└── gnome-extensions-settings.dconf  # GNOME 扩展配置
```

## 安装内容

### 系统工具

| 工具 | 说明 |
|------|------|
| Git | 版本控制 |
| Docker | 容器运行时 |
| Zsh | Shell |
| Oh-My-Zsh | Zsh 框架 |
| Vim | 文本编辑器 |
| Neovim | 现代文本编辑器 |
| Ghostty | 现代终端 |
| LSD | 现代 ls 替代品 |

### 开发工具

| 工具 | 说明 |
|------|------|
| nvm | Node.js 版本管理器 |
| jq | JSON 处理工具 |

### Lazy 系列工具

| 工具 | 说明 |
|------|------|
| lazydocker | Docker TUI 管理工具 |
| lazygit | Git TUI 管理工具 |
| lazyssh | SSH TUI 管理工具 |
| lazyjournal | Journalctl TUI 查看器 |

### 终端工具

| 工具 | 说明 |
|------|------|
| yazi | 终端文件管理器 |
| btop | 系统资源监控 |
| systemctl-tui | Systemd 服务管理 TUI |
| glow | 终端 Markdown 渲染器 |
| tennis | 终端工具 |

### Zsh 插件

| 插件 | 说明 |
|------|------|
| powerlevel10k | 美化主题 |
| zsh-autosuggestions | 命令自动建议 |
| zsh-syntax-highlighting | 语法高亮 |
| autojump | 快速目录跳转 |

### 自定义命令

| 命令 | 说明 |
|------|------|
| laradock | Laradock 容器管理工具 |
| lw | 快速进入 Laradock workspace |
| json | JSON 格式化工具 |
| tennis | Tennis 工具 |

### GNOME 扩展

通过扩展管理器安装，配置自动恢复：

- user-theme - 用户主题
- clipboard-indicator - 剪贴板管理
- kimpanel - 输入法面板
- tiling-assistant - 窗口平铺
- ubuntu-appindicators - 系统托盘
- 更多见 `gnome-extensions.txt`

## 配置文件链接

安装脚本会创建以下符号链接：

| 源文件 | 目标位置 |
|--------|----------|
| `.zshrc` | `~/.zshrc` |
| `.p10k.zsh` | `~/.p10k.zsh` |
| `.vimrc` | `~/.vimrc` |
| `nvim/` | `~/.config/nvim/` |
| `ghostty/config/config` | `~/.config/ghostty/config` |
| `lsd/config.yaml` | `~/.config/lsd/config.yaml` |
| `docker/daemon.json` | `/etc/docker/daemon.json` |
| `.oh-my-zsh/aliases.zsh` | `~/.oh-my-zsh/custom/aliases.zsh` |
| `.oh-my-zsh/functions.zsh` | `~/.oh-my-zsh/custom/functions.zsh` |
| `.oh-my-zsh/my-commands/` | `~/.oh-my-zsh/custom/my-commands/` |

## 自定义命令使用

### laradock

Laradock 容器管理工具，支持多版本管理：

```bash
# 基本命令
laradock ps                    # 查看容器状态
laradock up nginx              # 启动 nginx 容器
laradock stop nginx            # 停止 nginx 容器
laradock restart nginx         # 重启 nginx 容器
laradock logs nginx            # 查看 nginx 日志
laradock build nginx           # 构建 nginx 容器
laradock exec workspace        # 进入 workspace 容器

# 多版本支持
laradock up nginx --74         # 使用 laradock74 目录
laradock up nginx --81         # 使用 laradock81 目录
laradock up nginx --85         # 使用 laradock85 目录
```

### lw

快速进入 Laradock workspace 容器：

```bash
lw                             # 进入默认 workspace
lw -8                          # 进入 laradock8 workspace
lw -r                          # 重启并进入 workspace
lw -8 -r                       # 重启并进入 laradock8 workspace
```

### json

JSON 格式化工具：

```bash
echo '{"name":"test"}' | json  # 格式化 JSON
```

## 自定义

### 添加新配置

1. 将配置文件放入对应目录
2. 在 `setup.sh` 中添加符号链接命令

### 添加自定义命令

1. 在 `.oh-my-zsh/my-commands/` 目录下创建新脚本
2. 添加执行权限：`chmod +x script-name`
3. 在脚本中使用 `source "$SCRIPT_DIR/common.sh"` 引入公共函数

### 跳过已安装工具

脚本会自动检测以下工具是否已安装：

- Docker
- Zsh
- Ghostty
- nvm
- lazydocker
- lazygit
- lazyssh
- lazyjournal
- yazi
- systemctl-tui
- glow
- btop
- jq
- tennis

## 注意事项

1. **Docker 权限**：安装后需要重新登录系统才能使用 docker 命令
2. **Zsh 默认 Shell**：安装后默认切换到 Zsh
3. **GNOME 扩展**：需要手动通过扩展管理器安装，配置会自动恢复
4. **自定义命令**：安装后需要重启终端或运行 `source ~/.zshrc` 才能使用自定义命令

## 卸载

```bash
./uninstall.sh
```

## License

MIT
