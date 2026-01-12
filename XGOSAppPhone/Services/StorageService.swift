//
//  StorageService.swift
//  XGOSAppPhone
//
//  本地存储服务
//

import Foundation

class StorageService {
    
    static let shared = StorageService()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Token 管理
    
    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: Constants.StorageKeys.token)
        logInfo("Token saved", tag: "StorageService")
    }
    
    func getToken() -> String? {
        return userDefaults.string(forKey: Constants.StorageKeys.token)
    }
    
    func removeToken() {
        userDefaults.removeObject(forKey: Constants.StorageKeys.token)
        logInfo("Token removed", tag: "StorageService")
    }
    
    // MARK: - 用户信息管理
    
    func saveUserInfo(_ user: User) {
        userDefaults.set(user.userId, forKey: Constants.StorageKeys.userId)
        userDefaults.set(user.username, forKey: Constants.StorageKeys.username)
        userDefaults.set(user.deviceId, forKey: Constants.StorageKeys.deviceId)
        userDefaults.set(user.mqttUsername, forKey: Constants.StorageKeys.mqttUsername)
        logInfo("User info saved: \(user.username)", tag: "StorageService")
    }
    
    func getUserInfo() -> User? {
        guard let userId = userDefaults.string(forKey: Constants.StorageKeys.userId),
              let username = userDefaults.string(forKey: Constants.StorageKeys.username) else {
            return nil
        }
        
        return User(
            userId: userId,
            username: username,
            email: nil,
            deviceId: userDefaults.string(forKey: Constants.StorageKeys.deviceId),
            mqttUsername: userDefaults.string(forKey: Constants.StorageKeys.mqttUsername),
            token: getToken()
        )
    }
    
    func removeUserInfo() {
        userDefaults.removeObject(forKey: Constants.StorageKeys.userId)
        userDefaults.removeObject(forKey: Constants.StorageKeys.username)
        userDefaults.removeObject(forKey: Constants.StorageKeys.deviceId)
        userDefaults.removeObject(forKey: Constants.StorageKeys.mqttUsername)
        logInfo("User info removed", tag: "StorageService")
    }
    
    // MARK: - 服务器配置管理
    
    func saveServerAPIIP(_ ip: String) {
        userDefaults.set(ip, forKey: Constants.StorageKeys.serverAPIIP)
        logInfo("Server API IP saved: \(ip)", tag: "StorageService")
    }
    
    func getServerAPIIP() -> String {
        return userDefaults.string(forKey: Constants.StorageKeys.serverAPIIP) ?? Constants.Server.defaultAPIIP
    }
    
    func saveServerMQTTIP(_ ip: String) {
        userDefaults.set(ip, forKey: Constants.StorageKeys.serverMQTTIP)
        logInfo("Server MQTT IP saved: \(ip)", tag: "StorageService")
    }
    
    func getServerMQTTIP() -> String {
        return userDefaults.string(forKey: Constants.StorageKeys.serverMQTTIP) ?? Constants.Server.defaultMQTTIP
    }
    
    // MARK: - 清除所有数据
    
    func clearAllData() {
        removeToken()
        removeUserInfo()
        logInfo("All data cleared", tag: "StorageService")
    }
    
    // MARK: - 检查登录状态
    
    func isLoggedIn() -> Bool {
        return getToken() != nil && getUserInfo() != nil
    }
}