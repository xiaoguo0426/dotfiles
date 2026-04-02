.PHONY: install uninstall link unlink update status help

DOTFILES_DIR := $(shell pwd)

help:
	@echo "Dotfiles 管理命令"
	@echo ""
	@echo "使用: make <命令>"
	@echo ""
	@echo "命令:"
	@echo "  install    完整安装（运行 setup.sh）"
	@echo "  uninstall  移除所有符号链接"
	@echo "  link       只创建符号链接"
	@echo "  unlink     移除符号链接"
	@echo "  update     更新 dotfiles 仓库"
	@echo "  status     查看符号链接状态"

install:
	@echo "运行安装脚本..."
	chmod +x setup.sh
	./setup.sh

uninstall:
	@echo "移除符号链接..."
	rm -f ~/.zshrc
	rm -f ~/.p10k.zsh
	rm -f ~/.vimrc
	rm -f ~/.config/nvim
	rm -f ~/.config/ghostty/config
	rm -f ~/.config/lsd/config.yaml
	rm -f ~/.oh-my-zsh/custom/aliases.zsh
	rm -f ~/.oh-my-zsh/custom/functions.zsh
	rm -f ~/.oh-my-zsh/custom/my-commands
	rm -f /usr/local/bin/json
	rm -f /usr/local/bin/ubuntu-clean
	rm -f /usr/local/bin/ubuntu-mainline-kernel
	rm -f /usr/local/bin/diff-file
	rm -f /usr/local/bin/reset-navicat
	@echo "卸载完成"

link:
	@echo "创建符号链接..."
	ln -sf $(DOTFILES_DIR)/.zshrc ~/.zshrc
	ln -sf $(DOTFILES_DIR)/.p10k.zsh ~/.p10k.zsh
	ln -sf $(DOTFILES_DIR)/.oh-my-zsh/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
	ln -sf $(DOTFILES_DIR)/.oh-my-zsh/functions.zsh ~/.oh-my-zsh/custom/functions.zsh
	ln -sf $(DOTFILES_DIR)/.oh-my-zsh/my-commands ~/.oh-my-zsh/custom/my-commands
	ln -sf $(DOTFILES_DIR)/.vimrc ~/.vimrc
	ln -sf $(DOTFILES_DIR)/nvim ~/.config/nvim
	mkdir -p ~/.config/ghostty
	ln -sf $(DOTFILES_DIR)/ghostty/config/config ~/.config/ghostty/config
	mkdir -p ~/.config/lsd
	ln -sf $(DOTFILES_DIR)/lsd/config.yaml ~/.config/lsd/config.yaml
	@echo "符号链接创建完成"

unlink:
	@echo "移除符号链接..."
	rm -f ~/.zshrc
	rm -f ~/.p10k.zsh
	rm -f ~/.vimrc
	rm -f ~/.config/nvim
	rm -f ~/.config/ghostty/config
	rm -f ~/.config/lsd/config.yaml
	rm -f ~/.oh-my-zsh/custom/aliases.zsh
	rm -f ~/.oh-my-zsh/custom/functions.zsh
	rm -f ~/.oh-my-zsh/custom/my-commands
	@echo "符号链接已移除"

update:
	@echo "更新 dotfiles..."
	git pull origin main
	@echo "更新完成"

status:
	@echo "符号链接状态:"
	@echo ""
	@ls -la ~/.zshrc 2>/dev/null || echo "~/.zshrc: 不存在"
	@ls -la ~/.p10k.zsh 2>/dev/null || echo "~/.p10k.zsh: 不存在"
	@ls -la ~/.vimrc 2>/dev/null || echo "~/.vimrc: 不存在"
	@ls -la ~/.config/nvim 2>/dev/null || echo "~/.config/nvim: 不存在"
	@ls -la ~/.config/ghostty/config 2>/dev/null || echo "~/.config/ghostty/config: 不存在"
	@ls -la ~/.config/lsd/config.yaml 2>/dev/null || echo "~/.config/lsd/config.yaml: 不存在"
	@ls -la ~/.oh-my-zsh/custom/aliases.zsh 2>/dev/null || echo "~/.oh-my-zsh/custom/aliases.zsh: 不存在"
	@ls -la ~/.oh-my-zsh/custom/functions.zsh 2>/dev/null || echo "~/.oh-my-zsh/custom/functions.zsh: 不存在"
	@ls -la ~/.oh-my-zsh/custom/my-commands 2>/dev/null || echo "~/.oh-my-zsh/custom/my-commands: 不存在"
