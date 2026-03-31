#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

sudo apt update

# 安装git
sudo apt install -y git

# 安装docker

# 安装依赖包
sudo apt install ca-certificates curl
# 添加 Docker 官方 GPG 密钥
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# 添加 Docker APT 仓库
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# 安装 Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# 启动 Docker 守护进程
sudo systemctl start docker
# 设置开机自启
sudo systemctl enable docker

# 将当前用户添加到 docker 组
if ! groups $USER | grep -q '\bdocker\b'; then
    sudo usermod -aG docker $USER
fi

docker -v

# 安装 zsh，oh-my-zsh
if ! command -v zsh &> /dev/null; then
    # 安装 zsh
    sudo apt install -y zsh
fi
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sudo apt install -y autojump
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/.p10k.zsh" ~/.p10k.zsh

# 安装vim
sudo apt install -y vim
ln -sf "$DOTFILES_DIR/.vimrc" ~/.vimrc

# 安装nvim
sudo apt install -y neovim
ln -sf ~/gits/dotfiles/nvim ~/.config/nvim

# 安装ghostty
if ! command -v ghostty &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
fi
mkdir -p ~/.config/ghostty
ln -sf "$DOTFILES_DIR/ghostty/config/config" ~/.config/ghostty/config

# 安装lsd
sudo apt install -y lsd
mkdir -p ~/.config/lsd
ln -sf "$DOTFILES_DIR/lsd/config.yaml" ~/.config/lsd/config.yaml

# 安装nvm
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# 安装lazydocker
if ! command -v lazydocker &> /dev/null; then
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# 安装lazyssh
if ! command -v lazyssh &> /dev/null; then
    curl -sL https://github.com/jesseduffield/lazyssh/releases/latest/download/lazyssh_$(uname -s)_$(uname -m).tar.gz | tar xz -C /tmp
    sudo mv /tmp/lazyssh /usr/local/bin/
fi

# 安装lazygit
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf /tmp/lazygit.tar.gz lazygit -C /tmp
    sudo install /tmp/lazygit -D -t /usr/local/bin/
    rm -f /tmp/lazygit.tar.gz /tmp/lazygit
fi

# 安装lazyjournal
if ! command -v lazyjournal &> /dev/null; then
    curl -sL https://github.com/Lifailon/lazyjournal/releases/latest/download/lazyjournal-linux-$(uname -m) -o /tmp/lazyjournal
    sudo install /tmp/lazyjournal -D -t /usr/local/bin/
    rm -f /tmp/lazyjournal
fi

# 安装btop
sudo apt install -y btop

# 安装tenv (Terraform version manager)
# if ! command -v tenv &> /dev/null; then
#     curl -sL https://github.com/tofuutils/tenv/releases/latest/download/tenv_$(uname -s)_$(uname -m).tar.gz | tar xz -C /tmp
#     sudo mv /tmp/tenv /usr/local/bin/
# fi

# 安装jq
sudo apt install -y jq

# 安装yazi
if ! command -v yazi &> /dev/null; then
    curl -sL https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip -o /tmp/yazi.zip
    unzip -o /tmp/yazi.zip -d /tmp/yazi
    sudo mv /tmp/yazi/yazi /usr/local/bin/
    sudo mv /tmp/yazi/ya /usr/local/bin/
    rm -rf /tmp/yazi /tmp/yazi.zip
fi

# 安装systemctl-tui
if ! command -v systemctl-tui &> /dev/null; then
    curl -sL https://github.com/rgwood/systemctl-tui/releases/latest/download/systemctl-tui-linux-x86_64.tar.gz | tar xz -C /tmp
    sudo mv /tmp/systemctl-tui /usr/local/bin/
fi

# 安装glow
if ! command -v glow &> /dev/null; then
    curl -sL https://github.com/charmbracelet/glow/releases/latest/download/glow_linux_x86_64.tar.gz | tar xz -C /tmp
    sudo mv /tmp/glow /usr/local/bin/
fi


# 安装 GNOME 扩展管理工具
sudo apt install -y gnome-shell-extension-manager

# # 恢复 GNOME 扩展配置
# if [ -f "$DOTFILES_DIR/gnome-extensions-settings.dconf" ]; then
#     dconf load /org/gnome/shell/extensions/ < "$DOTFILES_DIR/gnome-extensions-settings.dconf"
# fi

echo "Setup completed! Please restart your terminal or run 'newgrp docker && source ~/.zshrc' to apply changes."
