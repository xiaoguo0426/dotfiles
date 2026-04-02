# 敏感文件管理工具使用指南

## 问题背景

在 Ubuntu 桌面环境中，我们经常需要在桌面上存储一些敏感信息（如账号密码、API密钥等）。但是：

1. **误删风险**：容易不小心删除重要文件
2. **安全风险**：文件内容可能被他人查看
3. **隐私保护**：需要加密存储敏感信息

## 解决方案

`secure-file` 工具提供了完整的解决方案：

### 功能特性

1. **文件防删除保护**
   - 使用 `chattr +i` 设置不可变属性
   - 即使 root 用户也无法删除或修改
   - 需要 `sudo` 权限才能解锁

2. **文件加密**
   - 使用 GPG AES-256 对称加密
   - 加密后文件添加 `.enc` 后缀
   - 每次访问都需要输入密码

3. **便捷编辑**
   - 自动解密到临时文件
   - 编辑完成后自动重新加密
   - 临时文件使用 `shred` 安全删除

## 安装

### 方法1：通过 setup.sh 安装（推荐）

```bash
cd ~/gits/dotfiles
./setup.sh
```

### 方法2：手动安装

```bash
# 创建符号链接
sudo ln -sf ~/gits/dotfiles/.oh-my-zsh/my-commands/secure-file.sh /usr/local/bin/secure-file

# 确保脚本有执行权限
chmod +x ~/gits/dotfiles/.oh-my-zsh/my-commands/secure-file.sh
```

## 使用方法

### 完整工作流程示例

#### 1. 创建敏感文件

```bash
# 在桌面创建文件
cd ~/Desktop
echo "公司账号信息：
- 邮箱: user@company.com
- 密码: MySecretPassword123
- API Key: sk-abc123xyz" > passwords.txt
```

#### 2. 加密文件

```bash
# 加密文件
secure-file encrypt ~/Desktop/passwords.txt

# 系统会提示：
# 正在加密文件: /home/you/Desktop/passwords.txt
# 请输入密码: [输入加密密码]
# 请再次输入密码: [确认密码]
# ✓ 文件已加密: /home/you/Desktop/passwords.txt.enc
# 是否删除原文件? (y/N): y
# ✓ 原文件已删除
```

#### 3. 锁定文件（防止误删）

```bash
# 锁定加密文件
secure-file lock ~/Desktop/passwords.txt.enc

# 系统会提示：
# 正在锁定文件: /home/you/Desktop/passwords.txt.enc
# [sudo] password for you: [输入系统密码]
# ✓ 文件已锁定，无法删除或修改
```

#### 4. 查看文件状态

```bash
# 查看文件状态
secure-file status ~/Desktop/passwords.txt.enc

# 输出：
# 文件状态: /home/you/Desktop/passwords.txt.enc
# 
# 文件属性:
#   锁定状态: 已锁定（不可删除/修改）
#   加密状态: 已加密
# 
# 文件权限:
# -rw-r--r-- 1 you you 123 Jan 1 12:00 /home/you/Desktop/passwords.txt.enc
```

#### 5. 查看加密文件

```bash
# 查看加密文件（只读）
secure-file view ~/Desktop/passwords.txt.enc

# 系统会提示：
# 正在解密文件以供查看...
# 请输入密码: [输入加密密码]
# [显示文件内容]
# ✓ 查看完成
```

#### 6. 编辑加密文件

```bash
# 编辑加密文件
secure-file edit ~/Desktop/passwords.txt.enc

# 系统会提示：
# 正在解密文件以供编辑...
# 请输入密码: [输入加密密码]
# ✓ 文件已解密到临时位置
# 正在打开编辑器 (nano)...
# 编辑完成后保存退出，文件将自动重新加密
# [编辑器打开，编辑文件]
# 正在重新加密文件...
# 请输入密码: [输入加密密码]
# 请再次输入密码: [确认密码]
# ✓ 文件已重新加密
# 是否锁定文件防止删除? (Y/n): y
# ✓ 文件已锁定，无法删除或修改
```

#### 7. 解锁文件（需要删除或修改时）

```bash
# 解锁文件
secure-file unlock ~/Desktop/passwords.txt.enc

# 系统会提示：
# 正在解锁文件: /home/you/Desktop/passwords.txt.enc
# [sudo] password for you: [输入系统密码]
# ✓ 文件已解锁，现在可以删除或修改
```

#### 8. 解密文件（永久解密）

```bash
# 解密文件
secure-file decrypt ~/Desktop/passwords.txt.enc

# 系统会提示：
# 正在解密文件: /home/you/Desktop/passwords.txt.enc
# 请输入密码: [输入加密密码]
# ✓ 文件已解密: /home/you/Desktop/passwords.txt
# 提示: 记得在使用后重新加密或删除解密文件
```

## 命令详解

### lock - 锁定文件

```bash
secure-file lock <文件路径>
```

**功能**：设置文件的不可变属性，防止删除和修改

**权限**：需要 `sudo` 权限

**效果**：
- 文件无法被删除
- 文件无法被修改
- 文件无法被重命名
- 即使 root 用户也无法删除（需要先解锁）

### unlock - 解锁文件

```bash
secure-file unlock <文件路径>
```

**功能**：移除文件的不可变属性，允许删除和修改

**权限**：需要 `sudo` 权限

### encrypt - 加密文件

```bash
secure-file encrypt <文件路径>
```

**功能**：使用 GPG AES-256 加密文件

**效果**：
- 生成 `.enc` 后缀的加密文件
- 原文件可选择保留或删除
- 每次访问需要输入密码

### decrypt - 解密文件

```bash
secure-file decrypt <文件路径.enc>
```

**功能**：解密 `.enc` 文件

**效果**：
- 生成解密后的文件（去除 `.enc` 后缀）
- 加密文件仍然保留

### edit - 编辑加密文件

```bash
secure-file edit <文件路径.enc>
```

**功能**：自动解密、编辑、重新加密

**流程**：
1. 解密到临时文件（`/tmp/` 目录）
2. 使用默认编辑器（`$EDITOR` 或 `nano`）打开
3. 编辑完成后自动重新加密
4. 使用 `shred` 安全删除临时文件

### view - 查看加密文件

```bash
secure-file view <文件路径.enc>
```

**功能**：只读方式查看加密文件

**效果**：
- 解密并直接输出到分页器（`less` 或 `$PAGER`）
- 不会生成解密文件
- 退出后无法再次查看（需要重新输入密码）

### status - 查看文件状态

```bash
secure-file status <文件路径>
```


## 高级用法

### 1. 批量加密文件

```bash
# 加密目录中的所有 .txt 文件
for file in ~/Desktop/*.txt; do
    secure-file encrypt "$file"
done
```

### 2. 自动锁定脚本

```bash
# 创建自动锁定脚本
cat > ~/bin/auto-lock-secure << 'EOF'
#!/bin/bash
# 自动锁定所有加密文件
find ~/Desktop -name "*.enc" -exec secure-file lock {} \;
EOF

chmod +x ~/bin/auto-lock-secure

# 添加到定时任务（每天晚上10点执行）
(crontab -l 2>/dev/null; echo "0 22 * * * ~/bin/auto-lock-secure") | crontab -
```

### 3. 集成到文件管理器

创建右键菜单快捷方式：

```bash
# 创建桌面文件
cat > ~/.local/share/file-manager/actions/secure-file.desktop << 'EOF'
[Desktop Entry]
Type=Action
Name=Encrypt File
Name[zh_CN]=加密文件
Icon=locked
Profiles=profile-zero;

[X-Action-Profile profile-zero]
MimeTypes=all/allfiles;
Exec=secure-file encrypt %f
EOF
```

## 故障排除

### 问题1：忘记密码

**解决方案**：
- GPG 使用强加密，无法破解
- 如果忘记密码，文件将无法恢复
- **建议**：定期备份加密文件到安全位置，并记录密码

### 问题2：文件无法删除

**原因**：文件被锁定

**解决方案**：
```bash
# 先解锁文件
secure-file unlock <文件路径>

# 然后删除
rm <文件路径>
```

### 问题3：权限不足

**原因**：需要 `sudo` 权限

**解决方案**：
```bash
# 确保当前用户有 sudo 权限
sudo -v

# 然后再执行命令
secure-file lock <文件路径>
```

### 问题4：GPG 未安装

**解决方案**：
```bash
# 安装 GPG
sudo apt install gnupg
```

## 常见问题

### Q1：加密文件可以在其他电脑上使用吗？

**A**：可以。只需要安装 GPG 并复制 `secure-file` 脚本即可。加密文件是跨平台兼容的。

### Q2：可以加密文件夹吗？

**A**：不能直接加密文件夹。建议先压缩文件夹，然后加密压缩文件：

```bash
# 压缩文件夹
tar -czf secrets.tar.gz ~/Documents/secrets/

# 加密压缩文件
secure-file encrypt secrets.tar.gz
```

### Q3：加密后文件大小会变化吗？

**A**：会略微增大（约增加几个字节到几KB，取决于原文件大小）。

### Q4：可以修改密码吗？

**A**：不能直接修改密码。需要解密后重新加密：

```bash
# 解密文件
secure-file decrypt file.txt.enc

# 重新加密（使用新密码）
secure-file encrypt file.txt
```

### Q5：加密文件会被云同步吗？

**A**：会的。加密文件可以安全地同步到云存储（如 Dropbox、Google Drive），因为文件已经加密。

## 相关资源

- [GPG 文档](https://www.gnupg.org/documentation/)
- [Linux 文件权限](https://wiki.archlinux.org/title/File_permissions_and_attributes)
- [Ubuntu 安全指南](https://ubuntu.com/security)

## 更新日志

### v1.0.0 (2024-01-01)
- 初始版本
- 支持加密、解密、锁定、解锁功能
- 支持编辑和查看加密文件
- 添加文件状态查看功能
