#!/bin/bash

# 敏感文件管理工具
# 功能：加密、解密、锁定、解锁文件

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 帮助信息
show_help() {
    cat << EOF
敏感文件管理工具

用法: secure-file <命令> <文件路径>

命令:
    lock        锁定文件（防止删除和修改）
    unlock      解锁文件（允许删除和修改）
    encrypt     加密文件（需要输入密码）
    decrypt     解密文件（需要输入密码）
    edit        编辑加密文件（自动解密、编辑、加密）
    view        查看加密文件（只读）
    status      查看文件状态

示例:
    secure-file lock ~/Desktop/passwords.txt
    secure-file encrypt ~/Desktop/passwords.txt
    secure-file edit ~/Desktop/passwords.txt.enc
    secure-file view ~/Desktop/passwords.txt.enc

注意:
    - 加密后的文件会添加 .enc 后缀
    - 锁定文件需要 sudo 权限
    - 建议先加密再锁定
EOF
}

# 检查文件是否存在
check_file_exists() {
    if [ ! -e "$1" ]; then
        echo -e "${RED}错误: 文件不存在: $1${NC}"
        exit 1
    fi
}

# 锁定文件（防止删除和修改）
lock_file() {
    local file="$1"
    check_file_exists "$file"
    
    echo -e "${BLUE}正在锁定文件: $file${NC}"
    
    # 使用 chattr +i 设置不可变属性
    if sudo chattr +i "$file" 2>/dev/null; then
        echo -e "${GREEN}✓ 文件已锁定，无法删除或修改${NC}"
        echo -e "${YELLOW}提示: 使用 'secure-file unlock $file' 解锁${NC}"
    else
        echo -e "${RED}✗ 锁定失败${NC}"
        exit 1
    fi
}

# 解锁文件
unlock_file() {
    local file="$1"
    check_file_exists "$file"
    
    echo -e "${BLUE}正在解锁文件: $file${NC}"
    
    # 移除不可变属性
    if sudo chattr -i "$file" 2>/dev/null; then
        echo -e "${GREEN}✓ 文件已解锁，现在可以删除或修改${NC}"
    else
        echo -e "${RED}✗ 解锁失败${NC}"
        exit 1
    fi
}

# 加密文件
encrypt_file() {
    local file="$1"
    check_file_exists "$file"
    
    local encrypted_file="${file}.enc"
    
    # 检查是否已经加密
    if [[ "$file" == *.enc ]]; then
        echo -e "${YELLOW}警告: 文件已经是加密文件${NC}"
        read -p "是否要重新加密? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
        encrypted_file="$file"
        file="${file%.enc}"
    fi
    
    echo -e "${BLUE}正在加密文件: $file${NC}"
    
    # 使用 GPG 加密（对称加密，需要密码）
    if gpg --symmetric --cipher-algo AES256 --output "$encrypted_file" "$file" 2>/dev/null; then
        echo -e "${GREEN}✓ 文件已加密: $encrypted_file${NC}"
        
        # 询问是否删除原文件
        if [[ "$encrypted_file" != "$file" ]]; then
            read -p "是否删除原文件? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                # 先解锁（如果已锁定）
                sudo chattr -i "$file" 2>/dev/null || true
                rm -f "$file"
                echo -e "${GREEN}✓ 原文件已删除${NC}"
            fi
        fi
        
        echo -e "${YELLOW}提示: 使用 'secure-file decrypt $encrypted_file' 解密${NC}"
    else
        echo -e "${RED}✗ 加密失败${NC}"
        exit 1
    fi
}

# 解密文件
decrypt_file() {
    local file="$1"
    check_file_exists "$file"
    
    # 检查是否是加密文件
    if [[ "$file" != *.enc ]]; then
        echo -e "${YELLOW}警告: 文件可能不是加密文件${NC}"
        read -p "是否继续? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
    
    local decrypted_file="${file%.enc}"
    
    echo -e "${BLUE}正在解密文件: $file${NC}"
    
    # 使用 GPG 解密
    if gpg --decrypt --output "$decrypted_file" "$file" 2>/dev/null; then
        echo -e "${GREEN}✓ 文件已解密: $decrypted_file${NC}"
        echo -e "${YELLOW}提示: 记得在使用后重新加密或删除解密文件${NC}"
    else
        echo -e "${RED}✗ 解密失败（密码错误或文件损坏）${NC}"
        exit 1
    fi
}

# 编辑加密文件
edit_encrypted_file() {
    local file="$1"
    check_file_exists "$file"
    
    if [[ "$file" != *.enc ]]; then
        echo -e "${RED}错误: 不是加密文件${NC}"
        exit 1
    fi
    
    local decrypted_file="${file%.enc}"
    local temp_file="/tmp/$(basename "$decrypted_file").$$"
    
    echo -e "${BLUE}正在解密文件以供编辑...${NC}"
    
    # 解密到临时文件
    if gpg --decrypt --output "$temp_file" "$file" 2>/dev/null; then
        echo -e "${GREEN}✓ 文件已解密到临时位置${NC}"
        
        # 获取默认编辑器
        local editor="${EDITOR:-vim}"
        
        echo -e "${BLUE}正在打开编辑器 ($editor)...${NC}"
        echo -e "${YELLOW}编辑完成后保存退出，文件将自动重新加密${NC}"
        
        # 编辑文件
        $editor "$temp_file"
        
        # 重新加密
        echo -e "${BLUE}正在重新加密文件...${NC}"
        
        # 先解锁原文件（如果已锁定）
        sudo chattr -i "$file" 2>/dev/null || true
        
        if gpg --symmetric --cipher-algo AES256 --output "$file" "$temp_file" 2>/dev/null; then
            echo -e "${GREEN}✓ 文件已重新加密${NC}"
            
            # 删除临时文件
            shred -u "$temp_file" 2>/dev/null || rm -f "$temp_file"
            
            # # 询问是否锁定文件
            # read -p "是否锁定文件防止删除? (Y/n): " -n 1 -r
            # echo
            # if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            #     lock_file "$file"
            # fi
            lock_file "$file"
        else
            echo -e "${RED}✗ 重新加密失败${NC}"
            echo -e "${YELLOW}临时文件保留在: $temp_file${NC}"
            exit 1
        fi
    else
        echo -e "${RED}✗ 解密失败（密码错误或文件损坏）${NC}"
        exit 1
    fi
}

# 查看加密文件
view_encrypted_file() {
    local file="$1"
    check_file_exists "$file"
    
    if [[ "$file" != *.enc ]]; then
        echo -e "${RED}错误: 不是加密文件${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}正在解密文件以供查看...${NC}"
    
    # 解密并直接输出到标准输出
    if gpg --decrypt "$file" 2>/dev/null | ${PAGER:-less}; then
        echo -e "${GREEN}✓ 查看完成${NC}"
    else
        echo -e "${RED}✗ 解密失败（密码错误或文件损坏）${NC}"
        exit 1
    fi
}

# 查看文件状态
show_status() {
    local file="$1"
    check_file_exists "$file"
    
    echo -e "${BLUE}文件状态: $file${NC}"
    echo
    
    # 检查文件属性
    echo -e "${YELLOW}文件属性:${NC}"
    lsattr "$file" 2>/dev/null | grep -q 'i' && echo -e "  锁定状态: ${GREEN}已锁定（不可删除/修改）${NC}" || echo -e "  锁定状态: ${YELLOW}未锁定${NC}"
    
    # 检查是否是加密文件
    if [[ "$file" == *.enc ]]; then
        echo -e "  加密状态: ${GREEN}已加密${NC}"
    else
        echo -e "  加密状态: ${YELLOW}未加密${NC}"
    fi
    
    # 文件权限
    echo -e "${YELLOW}文件权限:${NC}"
    ls -l "$file"
    
    # 文件大小
    echo -e "${YELLOW}文件大小:${NC}"
    du -h "$file"
}

# 主程序
main() {
    if [ $# -lt 2 ]; then
        show_help
        exit 1
    fi
    
    local command="$1"
    local file="$2"
    
    # 检查依赖
    if ! command -v gpg &> /dev/null; then
        echo -e "${RED}错误: 需要安装 GPG (GNU Privacy Guard)${NC}"
        echo -e "${YELLOW}安装命令: sudo apt install gnupg${NC}"
        exit 1
    fi
    
    case "$command" in
        lock)
            lock_file "$file"
            ;;
        unlock)
            unlock_file "$file"
            ;;
        encrypt)
            encrypt_file "$file"
            ;;
        decrypt)
            decrypt_file "$file"
            ;;
        edit)
            edit_encrypted_file "$file"
            ;;
        view)
            view_encrypted_file "$file"
            ;;
        status)
            show_status "$file"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}错误: 未知命令 '$command'${NC}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
