# GitHub Actions 构建指南

## 🚀 使用 GitHub Actions 构建 iOS 应用

GitHub Actions 是最简单、最可靠的在线构建方案，完全免费！

### 第 1 步：注册 GitHub 账号（1 分钟）

1. 访问：https://github.com/
2. 点击 "Sign up"
3. 填写信息并注册

### 第 2 步：创建 GitHub 仓库（2 分钟）

1. 登录 GitHub
2. 点击右上角的 "+" 按钮
3. 选择 "New repository"
4. 填写仓库信息：
   - Repository name: `xgosapp-phone-ios`
   - Description: `XGOSAPP iOS 手机端`
   - Public/Private: 选择 "Private"（私有）或 "Public"（公开）
   - 勾选 "Add a README file": **不要勾选**
5. 点击 "Create repository"

### 第 3 步：推送代码到 GitHub（3 分钟）

在 `C:\XGOS\client\phone-ios` 文件夹中打开 PowerShell，执行：

```bash
# 删除旧的远程仓库（如果存在）
git remote remove origin

# 添加 GitHub 远程仓库（替换为你的用户名）
git remote add origin https://github.com/你的用户名/xgosapp-phone-ios.git

# 推送到 GitHub
git push -u origin main
```

### 第 4 步：运行 GitHub Actions（自动触发）

代码推送到 GitHub 后，GitHub Actions 会自动运行！

1. 访问你的 GitHub 仓库
2. 点击 "Actions" 标签
3. 你会看到工作流正在运行
4. 等待构建完成（约 10-15 分钟）

### 第 5 步：下载 IPA 文件

1. 构建完成后，点击构建任务
2. 滚动到底部，找到 "Artifacts" 部分
3. 点击 "XGOSAppPhone-IPA" 下载
4. 解压下载的 zip 文件
5. 获得 `XGOSAppPhone.ipa` 文件

### 第 6 步：安装到 iPhone

#### 使用 AltStore（推荐）

1. 在 iPhone 上安装 AltStore：https://altstore.io/
2. 打开 AltStore，点击 "+"
3. 选择 IPA 文件
4. 输入你的 Apple ID 和密码
5. 等待安装完成

#### 使用 Sideloadly（Windows）

1. 下载 Sideloadly：https://sideloadly.io/
2. 用 USB 连接 iPhone 到电脑
3. 打开 Sideloadly
4. 选择 IPA 文件
5. 输入你的 Apple ID 和密码
6. 点击 "Install"
7. 等待安装完成

## ✅ 优势

- ✅ 完全免费（个人开发者）
- ✅ 自动触发（推送代码即构建）
- ✅ 界面友好，操作简单
- ✅ 文档完善，社区活跃
- ✅ 构建速度快
- ✅ 支持缓存，后续构建更快

## 🔄 手动触发构建

如果需要手动触发构建：

1. 访问 GitHub 仓库
2. 点击 "Actions" 标签
3. 选择 "iOS Build" 工作流
4. 点击 "Run workflow" 按钮
5. 选择分支：`main`
6. 点击 "Run workflow"

## 📊 查看构建日志

1. 点击构建任务
2. 可以查看每个步骤的详细日志
3. 如果失败，可以找到错误原因

## 🎉 完成！

现在你可以：
- ✅ 使用 GitHub Actions 自动构建 iOS 应用
- ✅ 完全免费
- ✅ 无需 Mac 电脑
- ✅ 操作简单

祝你使用愉快！🚀