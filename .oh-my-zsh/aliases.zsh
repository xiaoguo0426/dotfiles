
CUSTOM_COMMAND_DIR="$ZSH_CUSTOM/my-commands"

alias laradock="$CUSTOM_COMMAND_DIR/laradock"
alias lw="$CUSTOM_COMMAND_DIR/lw"
alias ld="laradock"
alias lzd="lazydocker"
alias s="lazyssh"
alias g="lazygit"

alias jsonc="json -c"

# 终端中查看csv文件
alias csv="tennis"

alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -la'
alias lt='lsd --tree'
alias l='lsd -lA'

alias sd='systemd-manager-tui'
alias c="glow $CUSTOM_COMMAND_DIR/markdown/custom-commands.md"
alias vc="glow $CUSTOM_COMMAND_DIR/markdown/vim.md"
alias cv="tac $CUSTOM_COMMAND_DIR/markdown/vim.md | glow"
alias zc="glow $CUSTOM_COMMAND_DIR/markdown/zsh.md"
alias cz="tac $CUSTOM_COMMAND_DIR/markdown/zsh.md | glow"
alias uc="glow $CUSTOM_COMMAND_DIR/markdown/ubuntu.md"
alias cu="tac $CUSTOM_COMMAND_DIR/markdown/ubuntu.md | glow"
alias yc="glow $CUSTOM_COMMAND_DIR/markdown/yazi.md"
alias cy="tac $CUSTOM_COMMAND_DIR/markdown/yazi.md | glow"

alias sf="secure-file"
alias sfv="secure-file view"
alias sfe="secure-file edit"