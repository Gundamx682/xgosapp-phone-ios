//
//  Constants.swift
//  XGOSAppPhone
//
//  应用常量配置
//

import Foundation

struct Constants {
    
    // MARK: - 服务器配置
    struct Server {
        static let defaultAPIIP = "192.168.1.100"
        static let defaultMQTTIP = "192.168.1.100"
        static let apiPort = 3000
        static let mqttPort = 1883
        
        static var apiBaseURL: String {
            return "http://\(defaultAPIIP):\(apiPort)"
        }
        
        static var mqttBrokerURL: String {
            return "mqtt://\(defaultMQTTIP):\(mqttPort)"
        }
    }
    
    // MARK: - API 端点
    struct API {
        static let auth = "/api/auth"
        static let login = "\(auth)/login"
        static let register = "\(auth)/register"
        static let alerts = "/api/alerts"
        static let videos = "/api/videos"
        static let userInfo = "/api/user/info"
    }
    
    // MARK: - MQTT 主题
    struct MQTT {
        static let alertTopic = "user/%@/alert/notification"
        static let videoTopic = "user/%@/video/available"
        static let keepAlive: UInt16 = 30
        static let connectionTimeout: TimeInterval = 30
        static let reconnectDelay: TimeInterval = 5
    }
    
    // MARK: - 存储键
    struct StorageKeys {
        static let token = "user_token"
        static let username = "user_username"
        static let userId = "user_id"
        static let deviceId = "user_device_id"
        static let mqttUsername = "user_mqtt_username"
        static let serverAPIIP = "server_api_ip"
        static let serverMQTTIP = "server_mqtt_ip"
    }
    
    // MARK: - 通知
    struct Notification {
        static let alertChannel = "alert_channel"
        static let videoChannel = "video_channel"
        static let mqttServiceChannel = "mqtt_service_channel"
    }
    
    // MARK: - UI
    struct UI {
        static let primaryColor = "#2196F3"
        static let secondaryColor = "#FF5722"
        static let backgroundColor = "#F5F5F5"
        static let cardColor = "#FFFFFF"
        static let textColor = "#212121"
        static let textSecondaryColor = "#757575"
    }
    
    // MARK: - 视频
    struct Video {
        static let autoHideDelay: TimeInterval = 3.0
        static let supportedFormats = ["mp4", "mov", "m4v"]
    }
}

// MARK: - 错误定义
enum AppError: Error, LocalizedError {
    case networkError(String)
    case authenticationError
    case serverError(String)
    case invalidResponse
    case mqttConnectionError
    case videoPlaybackError
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "网络错误: \(message)"
        case .authenticationError:
            return "认证失败，请重新登录"
        case .serverError(let message):
            return "服务器错误: \(message)"
        case .invalidResponse:
            return "无效的响应"
        case .mqttConnectionError:
            return "MQTT 连接失败"
        case .videoPlaybackError:
            return "视频播放失败"
        }
    }
}