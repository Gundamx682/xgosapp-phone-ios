//
//  User.swift
//  XGOSAppPhone
//
//  用户数据模型
//

import Foundation

struct User: Codable {
    let userId: String
    let username: String
    let email: String?
    let deviceId: String?
    let mqttUsername: String?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case email
        case deviceId = "device_id"
        case mqttUsername = "mqtt_username"
        case token
    }
}

// MARK: - 登录请求
struct LoginRequest: Codable {
    let username: String
    let password: String
}

// MARK: - 注册请求
struct RegisterRequest: Codable {
    let username: String
    let password: String
    let deviceId: String
    let email: String?
}

// MARK: - 认证响应
struct AuthResponse: Codable {
    let success: Bool
    let message: String?
    let data: AuthData?
    
    struct AuthData: Codable {
        let token: String
        let user: User
    }
}