#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

sudo apt update

# 安装git
sudo apt install -y git

# 安装docker并完成配置
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo mkdir -p /etc/docker
sudo ln -sf "$DOTFILES_DIR/docker/daemon.json" /etc/docker/daemon.json
sudo systemctl restart docker
docker -v
sudo usermod -aG docker $USER

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
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/.oh-my-zsh" ~/.oh-my-zsh
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

# 安装 GNOME 扩展管理工具
sudo apt install -y gnome-shell-extension-manager

# # 恢复 GNOME 扩展配置
# if [ -f "$DOTFILES_DIR/gnome-extensions-settings.dconf" ]; then
#     dconf load /org/gnome/shell/extensions/ < "$DOTFILES_DIR/gnome-extensions-settings.dconf"
# fi

echo "Setup completed! Please restart your terminal or run 'source ~/.zshrc' to apply changes."
