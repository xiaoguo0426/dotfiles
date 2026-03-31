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
│   │   └── plugins/
│   └── lazy-lock.json
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

### Zsh 插件

| 插件 | 说明 |
|------|------|
| powerlevel10k | 美化主题 |
| zsh-autosuggestions | 命令自动建议 |
| zsh-syntax-highlighting | 语法高亮 |
| autojump | 快速目录跳转 |

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

## 自定义

### 添加新配置

1. 将配置文件放入对应目录
2. 在 `setup.sh` 中添加符号链接命令

### 跳过已安装工具

脚本会自动检测以下工具是否已安装：

- Zsh
- Ghostty

## 注意事项

1. **Docker 权限**：安装后需要重新登录系统才能使用 docker 命令
2. **Zsh 默认 Shell**：安装后默认切换到 Zsh
3. **GNOME 扩展**：需要手动通过扩展管理器安装，配置会自动恢复

## 卸载

```bash
./uninstall.sh
```

## License

MIT
