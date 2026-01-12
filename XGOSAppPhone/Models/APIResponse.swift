//
//  APIResponse.swift
//  XGOSAppPhone
//
//  API 通用响应模型
//

import Foundation

// MARK: - 通用 API 响应
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
}

// MARK: - 用户信息响应
struct UserInfoResponse: Codable {
    let success: Bool
    let message: String?
    let data: UserInfoData?
    
    struct UserInfoData: Codable {
        let userId: String
        let username: String
        let email: String?
        let deviceId: String?
        let mqttUsername: String?
        let createdAt: String
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case username
            case email
            case deviceId = "device_id"
            case mqttUsername = "mqtt_username"
            case createdAt = "created_at"
        }
    }
}

// MARK: - 服务器信息响应
struct ServerInfoResponse: Codable {
    let success: Bool
    let message: String?
    let data: ServerInfoData?
    
    struct ServerInfoData: Codable {
        let version: String
        let uptime: String
        let mqttConnected: Bool
        let users: Int
        let devices: Int
        let alerts: Int
        let videos: Int
    }
}

// MARK: - 确认报警响应
struct ConfirmAlertResponse: Codable {
    let success: Bool
    let message: String?
}

// MARK: - 解决报警响应
struct ResolveAlertResponse: Codable {
    let success: Bool
    let message: String?
}