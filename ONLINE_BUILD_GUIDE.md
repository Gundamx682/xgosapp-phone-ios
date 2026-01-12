# iOS 应用在线构建指南

本指南将帮助你使用 Codemagic 在线构建 iOS 应用，无需 Mac 电脑。

## 📋 准备工作

### 1. 注册 Codemagic 账号

1. 访问 https://codemagic.io/
2. 点击 "Get Started"
3. 使用 GitHub、GitLab 或 Bitbucket 账号登录
4. 选择免费计划（每月 500 分钟构建时间）

### 2. 准备 Apple ID

1. 访问 https://appleid.apple.com/
2. 创建或登录你的 Apple ID
3. 启用两步验证
4. 生成应用专用密码：
   - 访问 https://appleid.apple.com/
   - 登录后，选择"安全性"
   - 在"应用专用密码"部分，点击"生成密码"
   - 输入标签（如"Codemagic"）
   - 复制生成的密码（格式：xxxx-xxxx-xxxx-xxxx）

### 3. 获取 Team ID

1. 访问 https://developer.apple.com/
2. 登录你的 Apple ID
3. 进入 "Account" -> "Membership"
4. 复制 "Team ID"（格式：XXXXXXXXXX）

## 🔧 配置步骤

### 步骤 1: 上传代码到 Git 仓库

1. 将代码推送到 GitHub、GitLab 或 Bitbucket
2. 确保仓库是公开的或已授权给 Codemagic

```bash
# 初始化 Git 仓库（如果还没有）
cd C:\XGOS\client\phone-ios
git init
git add .
git commit -m "Initial commit"

# 推送到 GitHub
git remote add origin https://github.com/your-username/xgosapp-phone-ios.git
git branch -M main
git push -u origin main
```

### 步骤 2: 在 Codemagic 中添加应用

1. 登录 Codemagic
2. 点击 "Add new app"
3. 选择你的 Git 仓库
4. 选择 `phone-ios` 目录
5. 点击 "Create app"

### 步骤 3: 配置环境变量

1. 进入应用设置
2. 点击 "Environment variables"
3. 添加以下变量：

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `APPLE_ID` | `your-apple-id@example.com` | 你的 Apple ID 邮箱 |
| `APPLE_ID_PASSWORD` | `xxxx-xxxx-xxxx-xxxx` | 应用专用密码 |
| `TEAM_ID` | `XXXXXXXXXX` | 你的 Team ID |

### 步骤 4: 配置工作流

1. 进入应用设置
2. 点击 "Workflows"
3. 选择 `ios-device-workflow`
4. 修改以下配置：

```yaml
environment:
  vars:
    APPLE_ID: "your-apple-id@example.com"
    APPLE_ID_PASSWORD: "xxxx-xxxx-xxxx-xxxx"
    TEAM_ID: "XXXXXXXXXX"
```

### 步骤 5: 修改 ExportOptions.plist

打开 `ExportOptions.plist` 文件，将 `YOUR_TEAM_ID` 替换为你的 Team ID：

```xml
<key>teamID</key>
<string>XXXXXXXXXX</string>
```

## 🚀 开始构建

### 方法 1: 手动构建

1. 进入 Codemagic 应用页面
2. 点击 "Start new build"
3. 选择 `ios-device-workflow`
4. 点击 "Start build"

### 方法 2: 自动构建

每次推送代码到 `main` 分支时，会自动触发构建。

## 📥 下载和安装

### 下载 IPA 文件

1. 构建完成后，进入构建页面
2. 点击 "Artifacts" 标签
3. 下载 `XGOSAppPhone.ipa` 文件

### 安装到 iPhone

#### 方法 1: 使用 AltStore（推荐）

1. 在 iPhone 上安装 AltStore
   - 访问 https://altstore.io/
   - 下载 AltStore
   - 在 iPhone 设置中信任 AltStore

2. 安装应用
   - 将 IPA 文件传输到 iPhone（通过 AirDrop、iCloud 等）
   - 在 iPhone 上打开 AltStore
   - 点击 "+" 按钮
   - 选择 IPA 文件
   - 输入你的 Apple ID 和密码
   - 等待安装完成

#### 方法 2: 使用 Cydia Impactor

1. 下载 Cydia Impactor
   - 访问 https://cydiaimpactor.com/
   - 下载 Windows 版本

2. 安装应用
   - 用 USB 连接 iPhone 到电脑
   - 打开 Cydia Impactor
   - 拖拽 IPA 文件到 Cydia Impactor
   - 输入你的 Apple ID 和密码
   - 等待安装完成

#### 方法 3: 使用 Sideloadly

1. 下载 Sideloadly
   - 访问 https://sideloadly.io/
   - 下载 Windows 版本

2. 安装应用
   - 用 USB 连接 iPhone 到电脑
   - 打开 Sideloadly
   - 选择 IPA 文件
   - 输入你的 Apple ID 和密码
   - 点击 "Install"
   - 等待安装完成

## ⚠️ 重要提示

### 应用有效期

- **自签名应用**: 有效期 7 天
- **7 天后**: 需要重新安装
- **解决方法**: 使用 AltStore 可以自动刷新（需要电脑配合）

### 应用无法打开

如果应用无法打开，尝试以下方法：

1. **重新安装**: 删除应用后重新安装
2. **检查日期**: 确保设备日期正确
3. **信任证书**: 设置 -> 通用 -> VPN与设备管理 -> 信任证书

### 构建失败

如果构建失败，检查：

1. **环境变量**: 确认所有变量配置正确
2. **Team ID**: 确认 Team ID 正确
3. **Apple ID**: 确认 Apple ID 和应用专用密码正确
4. **代码**: 确保代码可以正常编译

## 🔄 自动刷新签名（可选）

如果你有电脑，可以使用 AltServer 自动刷新签名：

1. 在电脑上安装 AltServer
   - 访问 https://altstore.io/
   - 下载 AltServer（Windows/Mac）

2. 配置 AltServer
   - 打开 AltServer
   - 输入你的 Apple ID 和密码
   - 用 USB 连接 iPhone 到电脑

3. 自动刷新
   - AltStore 会自动刷新应用签名
   - 每 7 天自动刷新一次

## 📞 常见问题

### Q: 构建需要多长时间？

A: 通常需要 5-10 分钟，取决于网络速度和项目大小。

### Q: 免费计划够用吗？

A: 免费计划每月 500 分钟，足够个人使用。

### Q: 可以发布到 App Store 吗？

A: 不可以，自签名应用只能用于个人测试。发布需要付费开发者账号（$99/年）。

### Q: 可以在多台设备上安装吗？

A: 可以，但每台设备都需要单独安装。

### Q: 应用会被下架吗？

A: 不会，自签名应用不会上传到 App Store。

## 📚 相关资源

- [Codemagic 官方文档](https://docs.codemagic.io/)
- [AltStore 官网](https://altstore.io/)
- [Apple Developer](https://developer.apple.com/)
- [iOS 应用签名指南](https://developer.apple.com/support/code-signing/)

## 🎉 完成！

现在你可以：

1. ✅ 在线构建 iOS 应用
2. ✅ 自签名安装到 iPhone
3. ✅ 无需 Mac 电脑
4. ✅ 完全免费（个人使用）

祝你使用愉快！🚀