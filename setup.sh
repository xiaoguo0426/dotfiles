#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

sudo apt update

# 安装git
sudo apt install -y git

# 安装docker

# 安装依赖包
if ! command -v docker &> /dev/null; then
  echo "正在安装 docker..."
  sudo apt install -y ca-certificates curl
  # 添加 Docker 官方 GPG 密钥
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  # 添加 Docker APT 仓库
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  # 安装 Docker Engine
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  # 判断 /etc/docker/daemon.json 是否存在
  if [ ! -f /etc/docker/daemon.json ]; then
      sudo mkdir -p /etc/docker
      sudo ln -sf "$DOTFILES_DIR/daemon.json" /etc/docker/daemon.json
  fi
  # 启动 Docker 守护进程
  sudo systemctl start docker
  # 设置开机自启
  sudo systemctl enable docker
  # 将当前用户添加到 docker 组
  if ! groups $USER | grep -q '\bdocker\b'; then
      sudo usermod -aG docker $USER
  fi
fi
docker -v

# 安装 zsh，oh-my-zsh

if ! command -v zsh &> /dev/null; then
    echo "正在安装 zsh..."
    # 安装 zsh
    sudo apt install -y zsh
fi
sudo chsh -s $(which zsh)
# 判断oh-my-zsh 是否已存在
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "正在安装 oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
# 判断p10k 是否已存在, 已存在则跳过安装
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "正在安装 powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "powerlevel10k 已安装，跳过安装步骤"
fi
# 判断zsh-autosuggestions 是否已存在
ZSH_AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_AUTOSUGGESTIONS_DIR" ]; then
    echo "正在安装 zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS_DIR"
else
    echo "zsh-autosuggestions 已安装，跳过安装步骤"
fi
# 判断zsh-syntax-highlighting 是否已存在, 已存在则跳过安装
ZSH_SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]; then
    echo "正在安装 zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
else
    echo "zsh-syntax-highlighting 已安装，跳过安装步骤"   
fi
if ! command -v autojump &> /dev/null; then
    sudo apt install -y autojump
fi

rm -rf ~/.zshrc
rm -rf ~/.p10k.zsh
rm -rf ~/.oh-my-zsh/custom/aliases.zsh
rm -rf ~/.oh-my-zsh/custom/functions.zsh
rm -rf ~/.oh-my-zsh/custom/my-commands

ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/.p10k.zsh" ~/.p10k.zsh
ln -sf "$DOTFILES_DIR/.oh-my-zsh/aliases.zsh" ~/.oh-my-zsh/custom/aliases.zsh
ln -sf "$DOTFILES_DIR/.oh-my-zsh/functions.zsh" ~/.oh-my-zsh/custom/functions.zsh
ln -sf "$DOTFILES_DIR/.oh-my-zsh/my-commands" ~/.oh-my-zsh/custom/my-commands

# 安装vim
echo "正在安装 vim..."
sudo apt install -y vim
ln -sf "$DOTFILES_DIR/.vimrc" ~/.vimrc

# 安装nvim
echo "正在安装 nvim..."
if ! command -v nvim &> /dev/null; then
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install -y python3-dev python3-pip
    sudo apt-get install -y neovim
fi
ln -sf ~/gits/dotfiles/nvim ~/.config/nvim
nvim -v

# 安装ghostty
echo "正在安装 ghostty..."
if ! command -v ghostty &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
fi
mkdir -p ~/.config/ghostty
ln -sf "$DOTFILES_DIR/ghostty/config/config" ~/.config/ghostty/config

# 安装lsd
echo "正在安装 lsd..."
if ! command -v lsd &> /dev/null; then
    sudo apt install -y lsd
fi
mkdir -p ~/.config/lsd
ln -sf "$DOTFILES_DIR/lsd/config.yaml" ~/.config/lsd/config.yaml

# 安装nvm
echo "正在安装 nvm..."
# nvm 是一个 shell 函数，不是可执行文件，所以检查 ~/.nvm 目录是否存在
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    # 安装后需要重新加载 shell 配置
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    echo "nvm 已安装，跳过安装步骤"
fi

# 安装 Claude Code
echo "正在安装 Claude Code..."
# 确保 nvm 已加载
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# 检查 node 是否已安装
if ! command -v node &> /dev/null; then
    echo "正在安装 Node.js..."
    nvm install --lts
fi
# 检查 claude 是否已安装
if ! command -v claude &> /dev/null; then
    npm install -g @anthropic-ai/claude-code
else
    echo "Claude Code 已安装，跳过安装步骤"
fi

# 安装lazydocker
echo "正在安装 lazydocker..."
if ! command -v lazydocker &> /dev/null; then
        # 先尝试直接下载二进制文件
    if curl -sL https://github.com/jesseduffield/lazydocker/releases/download/v0.25.0/lazydocker_0.25.0_Linux_x86_64.tar.gz -o /tmp/lazydocker.tar.gz 2>/dev/null; then
        tar -xzf /tmp/lazydocker.tar.gz -C /tmp
        sudo mv /tmp/lazydocker /usr/local/bin/ 2>/dev/null
        rm -f /tmp/lazydocker.tar.gz
    else
        echo "警告: lazydocker 安装失败，请手动安装"
    fi
fi

echo "正在安装 lazyssh..."
# 安装lazyssh (使用更可靠的方法)
if ! command -v lazyssh &> /dev/null; then
    # 先尝试直接下载二进制文件
    if curl -sL https://github.com/Adembc/lazyssh/releases/download/v0.3.0/lazyssh_Linux_x86_64.tar.gz -o /tmp/lazyssh.tar.gz 2>/dev/null; then
        tar -xzf /tmp/lazyssh.tar.gz -C /tmp
        sudo mv /tmp/lazyssh /usr/local/bin/ 2>/dev/null
        rm -f /tmp/lazyssh.tar.gz
    else
        echo "警告: lazyssh 安装失败，请手动安装"
    fi
fi

# 安装lazygit
if ! command -v lazygit &> /dev/null; then
    echo "正在安装 lazygit..."

    if curl -sL https://github.com/jesseduffield/lazygit/releases/download/v0.60.0/lazygit_0.60.0_linux_x86_64.tar.gz -o /tmp/lazygit.tar.gz 2>/dev/null; then
        tar -xzf /tmp/lazygit.tar.gz -C /tmp
        sudo mv /tmp/lazygit /usr/local/bin/ 2>/dev/null || sudo mv /tmp/lazygit_* /usr/local/bin/lazygit 2>/dev/null
        rm -f /tmp/lazygit.tar.gz
    else
        echo "警告: lazygit 安装失败，请手动安装"
    fi

fi

# 安装lazyjournal
if ! command -v lazyjournal &> /dev/null; then
    echo "正在安装 lazyjournal..."
    # 根据架构选择正确的下载链接
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
        ARCH="amd64"
    fi
    if curl -sL "https://github.com/Lifailon/lazyjournal/releases/latest/download/lazyjournal-linux-${ARCH}" -o /tmp/lazyjournal 2>/dev/null; then
        sudo install /tmp/lazyjournal -D -t /usr/local/bin/
        sudo chmod +x /usr/local/bin/lazyjournal
        rm -f /tmp/lazyjournal
    else
        echo "警告: lazyjournal 安装失败，请手动安装"
    fi
fi

# 安装tennis
if ! command -v tennis &> /dev/null; then
    echo "正在安装 tennis..."

    if curl -sL https://github.com/gurgeous/tennis/releases/download/v0.3.0/tennis_0.3.0_linux_amd64.tar.gz -o /tmp/tennis.tar.gz 2>/dev/null; then
        tar -xzf /tmp/tennis.tar.gz -C /tmp
        sudo mv /tmp/tennis_0.3.0_linux_amd64/tennis /usr/local/bin/ 2>/dev/null
        rm -f /tmp/tennis.tar.gz
    else
        echo "警告: tennis 安装失败，请手动安装"
    fi
fi

# 安装jq
if ! command -v jq &> /dev/null; then
    echo "正在安装 jq..."
    sudo apt install -y jq
fi

# 安装yazi (需要先安装unzip)
if ! command -v yazi &> /dev/null; then
    echo "正在安装 yazi..."

    sudo apt install -y unzip ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
    
    if curl -sL https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip -o /tmp/yazi.zip 2>/dev/null; then
        mkdir -p /tmp/yazi_extract
        unzip -o /tmp/yazi.zip -d /tmp/yazi_extract
        # 查找解压后的文件
        if [ -f "/tmp/yazi_extract/yazi" ]; then
            sudo mv /tmp/yazi_extract/yazi /usr/local/bin/
            sudo chmod +x /usr/local/bin/yazi
        fi
        if [ -f "/tmp/yazi_extract/ya" ]; then
            sudo mv /tmp/yazi_extract/ya /usr/local/bin/
            sudo chmod +x /usr/local/bin/ya
        fi
        rm -rf /tmp/yazi_extract /tmp/yazi.zip
    else
        echo "警告: yazi 安装失败，请手动安装"
    fi
fi

# 安装systemctl-tui
if ! command -v systemctl-tui &> /dev/null; then
    echo "正在安装 systemctl-tui..."
    if curl -sL https://github.com/rgwood/systemctl-tui/releases/download/v0.5.2/systemctl-tui-x86_64-unknown-linux-musl.tar.gz -o /tmp/systemctl-tui.tar.gz 2>/dev/null; then
        tar -xzf /tmp/systemctl-tui.tar.gz -C /tmp
        # 查找解压后的文件
        if [ -f "/tmp/systemctl-tui" ]; then
            sudo mv /tmp/systemctl-tui /usr/local/bin/
        elif [ -f "/tmp/systemctl-tui-linux-x86_64" ]; then
            sudo mv /tmp/systemctl-tui-linux-x86_64 /usr/local/bin/systemctl-tui
        fi
        sudo chmod +x /usr/local/bin/systemctl-tui 2>/dev/null
        rm -f /tmp/systemctl-tui.tar.gz
    else
        echo "警告: systemctl-tui 安装失败，请手动安装"
    fi
fi

# 安装glow
if ! command -v glow &> /dev/null; then
    echo "正在安装 glow..."
    if curl -sL https://github.com/charmbracelet/glow/releases/latest/download/glow_linux_x86_64.tar.gz -o /tmp/glow.tar.gz 2>/dev/null; then
        tar -xzf /tmp/glow.tar.gz -C /tmp
        # 查找解压后的文件
        if [ -f "/tmp/glow" ]; then
            sudo mv /tmp/glow /usr/local/bin/
        else
            # 尝试查找其他可能的文件名
            find /tmp -maxdepth 1 -name "glow*" -type f -exec sudo mv {} /usr/local/bin/glow \; 2>/dev/null
        fi
        sudo chmod +x /usr/local/bin/glow 2>/dev/null
        rm -f /tmp/glow.tar.gz
    else
        echo "警告: glow 安装失败，请手动安装"
    fi
fi

# 安装btop
if ! command -v btop &> /dev/null; then
    echo "正在安装 btop..."
    if curl -sL https://github.com/aristocratos/btop/releases/download/v1.4.6/btop-x86_64-unknown-linux-musl.tbz -o /tmp/btop.tar.bz2 2>/dev/null; then
        tar -xjf /tmp/btop.tar.bz2 -C /tmp
        # 查找解压后的文件
        if [ -f "/tmp/btop" ]; then
            sudo mv /tmp/btop /usr/local/bin/
        fi
        sudo chmod +x /usr/local/bin/btop 2>/dev/null
        rm -f /tmp/btop.tar.bz2
    else
        echo "警告: btop 安装失败，请手动安装"
    fi
fi

# 安装 GNOME 扩展管理工具
sudo apt install -y gnome-shell-extension-manager

# # 恢复 GNOME 扩展配置
# if [ -f "$DOTFILES_DIR/gnome-extensions-settings.dconf" ]; then
#     dconf load /org/gnome/shell/extensions/ < "$DOTFILES_DIR/gnome-extensions-settings.dconf"
# fi

# 将自定义命令链接到 /usr/local/bin/，这样 sudo 也能使用
echo "正在配置自定义命令..."
sudo ln -sf "$DOTFILES_DIR/.oh-my-zsh/my-commands/json.sh" /usr/local/bin/json
sudo ln -sf "$DOTFILES_DIR/.oh-my-zsh/my-commands/ubuntu-clean.sh" /usr/local/bin/ubuntu-clean
sudo ln -sf "$DOTFILES_DIR/.oh-my-zsh/my-commands/ubuntu-mainline-kernel.sh" /usr/local/bin/ubuntu-mainline-kernel
sudo ln -sf "$DOTFILES_DIR/.oh-my-zsh/my-commands/diff_file.sh" /usr/local/bin/diff-file
sudo ln -sf "$DOTFILES_DIR/.oh-my-zsh/my-commands/reset-trial-navicat.sh" /usr/local/bin/reset-navicat
sudo ln -sf "$DOTFILES_DIR/.oh-my-zsh/my-commands/secure-file.sh" /usr/local/bin/secure-file

echo "Setup completed! Please restart your terminal or run 'newgrp docker && source ~/.zshrc' to apply changes."
