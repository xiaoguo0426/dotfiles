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

# 恢复 GNOME 扩展配置
if [ -f "$DOTFILES_DIR/gnome-extensions-settings.dconf" ]; then
    dconf load /org/gnome/shell/extensions/ < "$DOTFILES_DIR/gnome-extensions-settings.dconf"
fi

# 安装 GNOME 扩展
install_gnome_extensions() {
    local EXTENSIONS_FILE="$1"
    local GNOME_VERSION=$(gnome-shell --version | grep -oP '\d+' | head -1)
    local EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"
    
    mkdir -p "$EXTENSIONS_DIR"
    
    while IFS= read -r EXTENSION_UUID || [ -n "$EXTENSION_UUID" ]; do
        [ -z "$EXTENSION_UUID" ] && continue
        
        EXTENSION_NAME="${EXTENSION_UUID%@*}"
        EXTENSION_DIR="$EXTENSIONS_DIR/$EXTENSION_UUID"
        
        if [ -d "$EXTENSION_DIR" ]; then
            echo "已安装: $EXTENSION_UUID"
            continue
        fi
        
        echo "正在安装: $EXTENSION_UUID"
        
        EXTENSION_PK=$(curl -s "https://extensions.gnome.org/extension-info/?uuid=$EXTENSION_UUID" | grep -oP '"pk":\s*\K\d+')
        
        if [ -z "$EXTENSION_PK" ]; then
            echo "  无法获取扩展信息: $EXTENSION_UUID"
            continue
        fi
        
        DOWNLOAD_URL="https://extensions.gnome.org/extension-data/${EXTENSION_UUID/-/}.v${EXTENSION_PK}.shell-extension.zip"
        
        TEMP_ZIP=$(mktemp --suffix=.zip)
        if curl -sL "$DOWNLOAD_URL" -o "$TEMP_ZIP" 2>/dev/null && [ -s "$TEMP_ZIP" ]; then
            mkdir -p "$EXTENSION_DIR"
            unzip -q "$TEMP_ZIP" -d "$EXTENSION_DIR"
            echo "  安装成功: $EXTENSION_UUID"
        else
            echo "  下载失败: $EXTENSION_UUID"
        fi
        rm -f "$TEMP_ZIP"
    done < "$EXTENSIONS_FILE"
}

if [ -f "$DOTFILES_DIR/gnome-extensions.txt" ]; then
    echo ""
    echo "正在安装 GNOME 扩展..."
    install_gnome_extensions "$DOTFILES_DIR/gnome-extensions.txt"
fi

echo "Setup completed! Please restart your terminal or run 'source ~/.zshrc' to apply changes."
