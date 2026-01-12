//
//  SettingsViewModel.swift
//  XGOSAppPhone
//
//  设置视图模型
//

import Foundation

@MainActor
class SettingsViewModel: ObservableObject {
    
    // 用户信息
    @Published var userInfo: User?
    
    // 服务器配置
    @Published var serverAPIIP: String = Constants.Server.defaultAPIIP
    @Published var serverMQTTIP: String = Constants.Server.defaultMQTTIP
    
    // MQTT 连接状态
    @Published var mqttConnectionState: MQTTConnectionState = .disconnected
    
    // 应用信息
    let appVersion = Bundle.appVersion
    let buildNumber = Bundle.buildNumber
    
    private let storageService = StorageService.shared
    private let mqttService = MQTTService.shared
    
    init() {
        loadSettings()
        setupMQTTListener()
    }
    
    // MARK: - 加载设置
    
    func loadSettings() {
        // 加载用户信息
        userInfo = storageService.getUserInfo()
        
        // 加载服务器配置
        serverAPIIP = storageService.getServerAPIIP()
        serverMQTTIP = storageService.getServerMQTTIP()
        
        // 加载 MQTT 连接状态
        mqttConnectionState = mqttService.connectionState
        
        logInfo("Settings loaded", tag: "SettingsViewModel")
    }
    
    // MARK: - MQTT 监听
    
    private func setupMQTTListener() {
        mqttService.$connectionState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.mqttConnectionState = state
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - 保存服务器配置
    
    func saveServerConfiguration() {
        storageService.saveServerAPIIP(serverAPIIP)
        storageService.saveServerMQTTIP(serverMQTTIP)
        
        logInfo("Server configuration saved", tag: "SettingsViewModel")
        
        // 重新连接 MQTT
        if let userInfo = userInfo {
            mqttService.connect(username: userInfo.username, password: "", userId: userInfo.userId)
        }
    }
    
    // MARK: - 测试服务器连接
    
    func testServerConnection() async -> Bool {
        do {
            let response = try await NetworkService.shared.getServerInfo()
            return response.success
        } catch {
            logError("Server connection test failed: \(error.localizedDescription)", tag: "SettingsViewModel")
            return false
        }
    }
    
    // MARK: - 获取服务器 IP
    
    func getServerApiIp() -> String {
        return storageService.getServerAPIIP()
    }
}