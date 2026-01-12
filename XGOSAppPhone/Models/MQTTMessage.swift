//
//  MQTTMessage.swift
//  XGOSAppPhone
//
//  MQTT 消息模型
//

import Foundation

struct MQTTMessage: Codable, Identifiable {
    let id = UUID()
    let topic: String
    let payload: String
    let timestamp: Date
    
    init(topic: String, payload: String) {
        self.topic = topic
        self.payload = payload
        self.timestamp = Date()
    }
    
    /// 判断是否为报警消息
    var isAlertMessage: Bool {
        return topic.contains("/alert/notification")
    }
    
    /// 判断是否为视频消息
    var isVideoMessage: Bool {
        return topic.contains("/video/available")
    }
    
    /// 解析报警数据
    func parseAlertData() -> AlertData? {
        guard isAlertMessage,
              let data = payload.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        
        return AlertData(
            deviceId: json["deviceId"] as? String ?? "",
            message: json["message"] as? String ?? "",
            severity: json["severity"] as? String ?? "MEDIUM",
            timestamp: json["timestamp"] as? String ?? ""
        )
    }
    
    /// 解析视频数据
    func parseVideoData() -> VideoData? {
        guard isVideoMessage,
              let data = payload.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        
        return VideoData(
            videoId: json["videoId"] as? String ?? "",
            filename: json["filename"] as? String ?? "",
            deviceId: json["deviceId"] as? String ?? ""
        )
    }
}

// MARK: - 报警数据
struct AlertData {
    let deviceId: String
    let message: String
    let severity: String
    let timestamp: String
}

// MARK: - 视频数据
struct VideoData {
    let videoId: String
    let filename: String
    let deviceId: String
}

// MARK: - MQTT 连接状态
enum MQTTConnectionState {
    case disconnected
    case connecting
    case connected
    case error(Error)
    
    var isConnected: Bool {
        if case .connected = self {
            return true
        }
        return false
    }
    
    var displayText: String {
        switch self {
        case .disconnected:
            return "已断开"
        case .connecting:
            return "连接中..."
        case .connected:
            return "已连接"
        case .error(let error):
            return "错误: \(error.localizedDescription)"
        }
    }
}