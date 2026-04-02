# 添加 proxy 命令
proxy() {
    if [[ "$1" == "--on" ]]; then
        export https_proxy=http://127.0.0.1:7890
        export http_proxy=http://127.0.0.1:7890
        export all_proxy=socks5://127.0.0.1:7890
        echo "代理已开启"
        echo "https_proxy=$https_proxy"
        echo "http_proxy=$http_proxy"
        echo "all_proxy=$all_proxy"
    elif [[ "$1" == "--off" ]]; then
        unset https_proxy
        unset http_proxy
        unset all_proxy
        echo "代理已关闭"
    else
        echo "用法:"
        echo "  proxy --on    开启代理"
        echo "  proxy --off   关闭代理"
        echo ""
        echo "当前代理状态:"
        echo "  http_proxy=${http_proxy:-未设置}"
        echo "  https_proxy=${https_proxy:-未设置}"
        echo "  all_proxy=${all_proxy:-未设置}"
    fi
}

# for yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# GLM
glm() {
    if [[ -z "$GLM_KEY" ]]; then
        echo "错误: GLM_KEY 未设置"
        echo "请在 ~/.bashrc 中添加: export GLM_KEY='your-api-key'"
        return 1
    fi
    ANTHROPIC_AUTH_TOKEN="$GLM_KEY" \
    ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic" \
    ANTHROPIC_MODEL="glm-5" \
    claude "$@"
}
