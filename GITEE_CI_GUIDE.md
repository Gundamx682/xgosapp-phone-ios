# Gitee CI 快速构建指南

## 🚀 5 分钟快速构建 iOS 应用

### 第 1 步：注册 Gitee 账号（1 分钟）

1. 访问：https://gitee.com/
2. 点击 "注册"
3. 填写信息并注册

### 第 2 步：准备 Apple ID（2 分钟）

1. 访问：https://appleid.apple.com/
2. 登录你的 Apple ID
3. 启用两步验证
4. 生成应用专用密码：
   - 安全性 → 应用专用密码 → 生成密码
   - 标签：`GiteeCI`
   - 复制密码（格式：`xxxx-xxxx-xxxx-xxxx`）

### 第 3 步：获取 Team ID（1 分钟）

1. 访问：https://developer.apple.com/
2. 登录 Apple ID
3. Account → Membership
4. 复制 Team ID（格式：`XXXXXXXXXX`）

### 第 4 步：上传代码到 Gitee（2 分钟）

在 `C:\XGOS\client\phone-ios` 文件夹中右键，选择"在终端中打开"，然后执行：

```bash
# 初始化 Git
git init
git add .
git commit -m "Initial commit"

# 添加远程仓库（替换为你的 Gitee 仓库地址）
git remote add origin https://gitee.com/你的用户名/xgosapp-phone-ios.git

# 推送到 Gitee
git branch -M main
git push -u origin main
```

### 第 5 步：配置 Gitee CI（3 分钟）

1. 进入 Gitee 仓库页面
2. 点击 "流水线" → "新建流水线"
3. 选择 "自定义模板"
4. 复制 `.gitee-ci.yml` 的内容
5. 粘贴到编辑器中
6. 修改环境变量：

```yaml
variables:
  APPLE_ID: "your-apple-id@example.com"        # 改为你的 Apple ID
  APPLE_ID_PASSWORD: "xxxx-xxxx-xxxx-xxxx"     # 改为你的应用专用密码
  TEAM_ID: "XXXXXXXXXX"                         # 改为你的 Team ID
```

7. 点击 "创建"

### 第 6 步：开始构建（1 分钟）

1. 点击 "运行流水线"
2. 选择分支：`main`
3. 点击 "运行"
4. 等待构建完成（约 10-15 分钟）

### 第 7 步：下载安装（2 分钟）

1. 构建完成后，点击 "产物" 标签
2. 下载 `XGOSAppPhone.ipa` 文件
3. 在 iPhone 上安装 AltStore：https://altstore.io/
4. 打开 AltStore，点击 "+"，选择 IPA 文件
5. 输入 Apple ID 和密码
6. 等待安装完成

## ✅ 完成！

现在你的 iPhone 上已经安装了 XGOSAPP 应用！

## 📱 配置服务器

1. 打开 XGOSAPP 应用
2. 登录你的账号
3. 进入设置
4. 配置服务器 IP：
   - API 服务器：`192.168.1.100:3000`
   - MQTT 服务器：`192.168.1.100:1883`

## 🔄 刷新签名（7 天后）

应用有效期 7 天，7 天后需要重新安装：

1. 删除旧应用
2. 重新运行 Gitee CI 构建
3. 下载新的 IPA 文件
4. 重新安装

## ❓ 常见问题

### Q: 构建失败怎么办？

A: 检查以下几点：
1. Apple ID 和密码是否正确
2. Team ID 是否正确
3. 网络连接是否正常
4. 代码是否可以正常编译

### Q: 免费额度够用吗？

A: Gitee CI 每月 200 分钟，足够个人使用。

### Q: 可以在多台设备上安装吗？

A: 可以，但每台设备都需要单独安装。

### Q: 应用会被下架吗？

A: 不会，自签名应用不会上传到 App Store。

## 🎉 享受使用！

现在你可以在 iPhone 上使用 XGOSAPP 了！

- ✅ 实时接收报警
- ✅ 查看视频
- ✅ 监控设备状态
- ✅ 完全免费
- ✅ 国内访问速度快