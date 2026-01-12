# 快速开始指南

## 🚀 5 分钟快速构建

### 第 1 步：注册 Codemagic（1 分钟）

1. 访问：https://codemagic.io/
2. 点击 "Get Started"
3. 选择 GitHub 登录
4. 选择免费计划

### 第 2 步：准备 Apple ID（2 分钟）

1. 打开：https://appleid.apple.com/
2. 登录你的 Apple ID
3. 启用两步验证
4. 生成应用专用密码：
   - 安全性 → 应用专用密码 → 生成密码
   - 标签：`Codemagic`
   - 复制密码（格式：`xxxx-xxxx-xxxx-xxxx`）

### 第 3 步：获取 Team ID（1 分钟）

1. 打开：https://developer.apple.com/
2. 登录 Apple ID
3. Account → Membership
4. 复制 Team ID（格式：`XXXXXXXXXX`）

### 第 4 步：上传代码（1 分钟）

```bash
cd C:\XGOS\client\phone-ios

# 初始化 Git
git init
git add .
git commit -m "Initial commit"

# 推送到 GitHub
git remote add origin https://github.com/你的用户名/xgosapp-phone-ios.git
git branch -M main
git push -u origin main
```

### 第 5 步：配置 Codemagic（3 分钟）

1. 登录 Codemagic
2. 点击 "Add new app"
3. 选择你的 GitHub 仓库
4. 点击 "Create app"
5. 进入应用设置 → Environment variables
6. 添加以下变量：

| 变量名 | 值 |
|--------|-----|
| `APPLE_ID` | `你的AppleID@example.com` |
| `APPLE_ID_PASSWORD` | `xxxx-xxxx-xxxx-xxxx` |
| `TEAM_ID` | `XXXXXXXXXX` |

### 第 6 步：开始构建（1 分钟）

1. 进入应用页面
2. 点击 "Start new build"
3. 选择 `ios-device-workflow`
4. 点击 "Start build"

### 第 7 步：下载安装（2 分钟）

1. 等待构建完成（约 5-10 分钟）
2. 点击 "Artifacts" 下载 `XGOSAppPhone.ipa`
3. 在 iPhone 上安装 AltStore
4. 打开 AltStore，点击 "+"
5. 选择 IPA 文件
6. 输入 Apple ID 和密码
7. 等待安装完成

## ✅ 完成！

现在你的 iPhone 上已经安装了 XGOSAPP 应用！

## 📱 安装 AltStore

### 方法 1：直接安装（推荐）

1. 在 iPhone Safari 中打开：https://altstore.io/
2. 点击 "Download AltStore"
3. 点击 "Install AltStore"
4. 按照提示安装

### 方法 2：侧载安装

1. 在电脑上下载 AltServer
2. 用 USB 连接 iPhone
3. 安装 AltStore 到 iPhone

## ⚙️ 配置服务器

1. 打开 XGOSAPP 应用
2. 登录你的账号
3. 进入设置
4. 配置服务器 IP：
   - API 服务器：`192.168.1.100:3000`
   - MQTT 服务器：`192.168.1.100:1883`

## 🔄 刷新签名（7 天后）

应用有效期 7 天，7 天后需要重新安装：

1. 删除旧应用
2. 重新安装 IPA 文件

或者使用 AltStore 自动刷新（需要电脑配合）。

## ❓ 遇到问题？

查看详细指南：[ONLINE_BUILD_GUIDE.md](ONLINE_BUILD_GUIDE.md)

## 🎉 享受使用！

现在你可以在 iPhone 上使用 XGOSAPP 了！

- ✅ 实时接收报警
- ✅ 查看视频
- ✅ 监控设备状态
- ✅ 完全免费