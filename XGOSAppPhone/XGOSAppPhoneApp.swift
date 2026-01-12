//
//  XGOSAppPhoneApp.swift
//  XGOSAppPhone
//
//  XGOSAPP 车机哨兵系统 - iOS 手机端
//

import SwiftUI

@main
struct XGOSAppPhoneApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var mqttService = MQTTService.shared
    
    init() {
        // 配置应用
        setupApp()
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                MainTabView()
                    .environmentObject(authViewModel)
                    .environmentObject(mqttService)
                    .onAppear {
                        // 启动 MQTT 服务
                        if let userInfo = authViewModel.userInfo {
                            mqttService.connect(
                                username: userInfo.username,
                                password: "",
                                userId: userInfo.userId
                            )
                        }
                    }
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
    
    private func setupApp() {
        // 配置通知
        NotificationService.shared.requestAuthorization()
        
        // 配置 MQTT 服务
        MQTTService.shared.setup()
    }
}