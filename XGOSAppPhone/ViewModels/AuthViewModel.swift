//
//  AuthViewModel.swift
//  XGOSAppPhone
//
//  认证视图模型
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userInfo: User?
    
    private let networkService = NetworkService.shared
    private let storageService = StorageService.shared
    
    init() {
        checkLoginStatus()
    }
    
    // MARK: - 检查登录状态
    
    func checkLoginStatus() {
        isLoggedIn = storageService.isLoggedIn()
        if isLoggedIn {
            userInfo = storageService.getUserInfo()
        }
    }
    
    // MARK: - 登录
    
    func login(username: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await networkService.login(username: username, password: password)
            
            if response.success, let data = response.data {
                // 保存 Token
                storageService.saveToken(data.token)
                
                // 保存用户信息
                storageService.saveUserInfo(data.user)
                
                // 更新状态
                isLoggedIn = true
                userInfo = data.user
                
                logInfo("Login successful: \(username)", tag: "AuthViewModel")
            } else {
                throw AppError.serverError(response.message ?? "Login failed")
            }
        } catch {
            logError("Login error: \(error.localizedDescription)", tag: "AuthViewModel")
            throw error
        }
    }
    
    // MARK: - 注册
    
    func register(username: String, password: String, deviceId: String, email: String? = nil) async throws {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await networkService.register(
                username: username,
                password: password,
                deviceId: deviceId,
                email: email
            )
            
            if response.success, let data = response.data {
                // 保存 Token
                storageService.saveToken(data.token)
                
                // 保存用户信息
                storageService.saveUserInfo(data.user)
                
                // 更新状态
                isLoggedIn = true
                userInfo = data.user
                
                logInfo("Register successful: \(username)", tag: "AuthViewModel")
            } else {
                throw AppError.serverError(response.message ?? "Register failed")
            }
        } catch {
            logError("Register error: \(error.localizedDescription)", tag: "AuthViewModel")
            throw error
        }
    }
    
    // MARK: - 登出
    
    func logout() {
        // 清除本地数据
        storageService.clearAllData()
        
        // 更新状态
        isLoggedIn = false
        userInfo = nil
        
        // 清除通知
        NotificationService.shared.clearAllNotifications()
        NotificationService.shared.clearBadge()
        
        // 断开 MQTT
        MQTTService.shared.disconnect()
        
        logInfo("Logout successful", tag: "AuthViewModel")
    }
    
    // MARK: - 获取用户信息
    
    func refreshUserInfo() async throws {
        guard let token = storageService.getToken() else {
            throw AppError.authenticationError
        }
        
        do {
            let response = try await networkService.getUserInfo(token: token)
            
            if response.success, let data = response.data {
                let user = User(
                    userId: data.userId,
                    username: data.username,
                    email: data.email,
                    deviceId: data.deviceId,
                    mqttUsername: data.mqttUsername,
                    token: token
                )
                
                storageService.saveUserInfo(user)
                userInfo = user
                
                logInfo("User info refreshed", tag: "AuthViewModel")
            }
        } catch {
            logError("Failed to refresh user info: \(error.localizedDescription)", tag: "AuthViewModel")
            throw error
        }
    }
    
    // MARK: - 验证输入
    
    func validateUsername(_ username: String) -> Bool {
        return username.isValidUsername
    }
    
    func validateEmail(_ email: String) -> Bool {
        return email.isValidEmail
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}