# XGOSAPP Phone (iOS 版)

车机哨兵系统 iOS 手机端 - 与 Android 手机端功能完全一致

## 技术栈

- **语言**: Swift 5.9+
- **UI 框架**: SwiftUI (iOS 16+)
- **架构**: MVVM + Clean Architecture
- **网络请求**: URLSession + Combine
- **MQTT 客户端**: CocoaMQTTClient
- **视频播放**: AVPlayer + AVPlayerViewController
- **本地存储**: UserDefaults
- **通知推送**: UNUserNotificationCenter

## 项目结构

```
XGOSAppPhone/
├── XGOSAppPhoneApp.swift          # App 入口
├── Info.plist                      # 应用配置
├── Models/                         # 数据模型
│   ├── User.swift
│   ├── Alert.swift
│   ├── Video.swift
│   ├── MQTTMessage.swift
│   └── APIResponse.swift
├── ViewModels/                     # 视图模型
│   ├── AuthViewModel.swift
│   ├── HomeViewModel.swift
│   ├── VideoListViewModel.swift
│   └── SettingsViewModel.swift
├── Views/                          # 视图
│   ├── Auth/
│   │   ├── LoginView.swift
│   │   └── RegisterView.swift
│   ├── Home/
│   │   ├── MainTabView.swift
│   │   ├── HomeView.swift
│   │   ├── AlertListView.swift
│   │   └── VideoListView.swift
│   ├── VideoPlayer/
│   │   └── VideoPlayerView.swift
│   └── Settings/
│       └── SettingsView.swift
├── Services/                       # 服务层
│   ├── NetworkService.swift        # HTTP 请求
│   ├── MQTTService.swift           # MQTT 连接
│   ├── NotificationService.swift   # 通知服务
│   └── StorageService.swift        # 本地存储
└── Utilities/                      # 工具类
    ├── Constants.swift
    ├── Extensions.swift
    └── Logger.swift
```

## 核心功能

### 1. 用户认证
- ✅ 用户注册
- ✅ 用户登录
- ✅ JWT Token 管理
- ✅ 自动登录（Token 本地存储）

### 2. 主界面
- ✅ 报警列表（实时更新）
- ✅ 视频列表（从服务器获取）
- ✅ 设备状态监控
- ✅ 底部导航栏

### 3. 实时报警接收
- ✅ MQTT 连接管理
- ✅ 订阅报警主题: `user/{userId}/alert/notification`
- ✅ 订阅视频通知: `user/{userId}/video/available`
- ✅ 本地推送通知
- ✅ 后台 MQTT 服务

### 4. 视频播放
- ✅ 视频列表展示
- ✅ 视频播放器（全屏）
- ✅ 支持格式: H.264, H.265, MP4
- ✅ 沉浸式播放体验
- ✅ 自动隐藏控制栏（3秒）

### 5. 设置界面
- ✅ 服务器 IP 配置
- ✅ MQTT 连接状态
- ✅ 用户信息
- ✅ 退出登录

## 开发环境要求

- **Xcode**: 15.0+
- **iOS**: 16.0+
- **Swift**: 5.9+
- **CocoaPods**: 1.11+

## 安装依赖

```bash
cd XGOSAppPhone
pod install
```

## 依赖库

```ruby
pod 'CocoaMQTT', '~> 2.0'
```

## 构建项目

### Debug 版本
```bash
# 打开 Xcode
open XGOSAppPhone.xcworkspace

# 或使用命令行
xcodebuild -workspace XGOSAppPhone.xcworkspace \
           -scheme XGOSAppPhone \
           -configuration Debug \
           build
```

### Release 版本
```bash
xcodebuild -workspace XGOSAppPhone.xcworkspace \
           -scheme XGOSAppPhone \
           -configuration Release \
           archive \
           -archivePath build/XGOSAppPhone.xcarchive
```

## 配置

### 服务器配置

在应用设置中配置服务器 IP：

- **API 服务器**: 默认 `192.168.1.100:3000`
- **MQTT 服务器**: 默认 `192.168.1.100:1883`

### 通知权限

应用首次启动时会请求通知权限，请允许以接收实时报警通知。

## 功能对比

| 功能 | Android 端 | iOS 端 |
|------|-----------|--------|
| 用户认证 | ✅ | ✅ |
| 实时报警 | ✅ | ✅ |
| 视频播放 | ✅ | ✅ |
| MQTT 连接 | ✅ | ✅ |
| 推送通知 | ✅ | ✅ |
| 全屏播放 | ✅ | ✅ |
| 自动隐藏控制栏 | ✅ | ✅ |
| 服务器配置 | ✅ | ✅ |
| 用户信息 | ✅ | ✅ |
| 退出登录 | ✅ | ✅ |

## 技术亮点

- **SwiftUI**: 使用最新的声明式 UI 框架
- **MVVM 架构**: 清晰的代码结构，易于维护
- **Combine**: 响应式编程，处理异步数据流
- **CocoaMQTT**: 稳定的 MQTT 客户端
- **AVPlayer**: 原生视频播放，性能优异
- **UNUserNotificationCenter**: 系统级通知推送

## 开发指南

### 代码规范
- 使用 Swift 5.9 特性
- 遵循 SwiftUI 最佳实践
- 使用 MVVM 模式
- 编写清晰的注释

### 调试
- 使用 Xcode 控制台查看日志
- 使用 Instruments 分析性能
- 使用 Network Link Conditioner 测试网络

## 已知问题

1. **后台 MQTT 连接**: iOS 系统限制，需要配置 Background Modes
2. **视频格式**: 部分视频格式可能不支持，建议使用 H.264/MP4
3. **网络权限**: 需要在 Info.plist 中配置 NSAppTransportSecurity

## 后续优化

- [ ] 添加 iPad 适配
- [ ] 优化视频播放性能
- [ ] 添加离线缓存
- [ ] 支持更多视频格式
- [ ] 添加深色模式
- [ ] 添加 Widget 支持

## 许可证

MIT

## 支持

如有问题，请提交 Issue 或联系开发团队。

---

**版本**: 1.0.0
**更新日期**: 2026-01-12
**作者**: XGOSAPP Team