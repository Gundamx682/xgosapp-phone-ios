# 无签名构建指南

## 🚀 更简单的方法

不需要配置 Apple ID 和 Team ID，直接构建未签名的应用，然后用 AltStore 或 Sideloadly 签名。

## 📋 步骤

### 1. 使用无签名配置

在 Gitee CI 中使用 `.gitee-ci-no-sign.yml` 配置文件。

### 2. 开始构建

1. 进入 Gitee 仓库页面
2. 点击 "流水线" → "新建流水线"
3. 选择 "自定义模板"
4. 复制 `.gitee-ci-no-sign.yml` 的内容
5. 粘贴到编辑器中
6. 点击 "创建"
7. 点击 "运行流水线"
8. 等待构建完成（约 10-15 分钟）

### 3. 下载 IPA 文件

1. 构建完成后，点击 "产物" 标签
2. 下载 `XGOSAppPhone.ipa` 文件

### 4. 使用工具签名

#### 方法 1：AltStore（推荐）

1. 在 iPhone 上安装 AltStore：https://altstore.io/
2. 打开 AltStore，点击 "+"
3. 选择 IPA 文件
4. 输入你的 Apple ID 和密码
5. 等待安装完成

#### 方法 2：Sideloadly（Windows）

1. 下载 Sideloadly：https://sideloadly.io/
2. 用 USB 连接 iPhone 到电脑
3. 打开 Sideloadly
4. 选择 IPA 文件
5. 输入你的 Apple ID 和密码
6. 点击 "Install"
7. 等待安装完成

#### 方法 3：Cydia Impactor（Windows）

1. 下载 Cydia Impactor：https://cydiaimpactor.com/
2. 用 USB 连接 iPhone 到电脑
3. 打开 Cydia Impactor
4. 拖拽 IPA 文件到 Cydia Impactor
5. 输入你的 Apple ID 和密码
6. 等待安装完成

## ✅ 优势

- ✅ 不需要配置 Apple ID 和 Team ID
- ✅ 不需要生成应用专用密码
- ✅ 构建更简单、更快速
- ✅ 灵活性更高，可以随时更换签名工具

## ⚠️ 注意事项

- **应用有效期**: 7 天（需要重新签名）
- **签名工具**: 需要使用 AltStore、Sideloadly 或 Cydia Impactor
- **Apple ID**: 只在签名时需要，不需要在 CI 中配置

## 🔄 刷新签名

应用有效期 7 天，7 天后需要重新签名：

### 使用 AltStore

1. 删除旧应用
2. 重新安装 IPA 文件
3. 或者使用 AltServer 自动刷新（需要电脑）

### 使用 Sideloadly

1. 删除旧应用
2. 重新签名安装

## 🎉 完成！

现在你可以：
- ✅ 简化构建流程
- ✅ 不需要配置复杂的签名信息
- ✅ 灵活选择签名工具
- ✅ 完全免费

祝你使用愉快！🚀