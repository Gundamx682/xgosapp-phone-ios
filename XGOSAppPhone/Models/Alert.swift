//
//  Alert.swift
//  XGOSAppPhone
//
//  报警数据模型
//

import Foundation

struct Alert: Codable, Identifiable {
    let id: String
    let deviceId: String
    let userId: String
    let severity: AlertSeverity
    let message: String
    let status: AlertStatus
    let createdAt: Date
    let confirmedAt: Date?
    let resolvedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case deviceId = "device_id"
        case userId = "user_id"
        case severity
        case message
        case status
        case createdAt = "created_at"
        case confirmedAt = "confirmed_at"
        case resolvedAt = "resolved_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        deviceId = try container.decode(String.self, forKey: .deviceId)
        userId = try container.decode(String.self, forKey: .userId)
        severity = try container.decode(AlertSeverity.self, forKey: .severity)
        message = try container.decode(String.self, forKey: .message)
        status = try container.decode(AlertStatus.self, forKey: .status)
        
        // 处理日期字符串
        let dateFormatter = ISO8601DateFormatter()
        if let createdAtString = try? container.decode(String.self, forKey: .createdAt) {
            createdAt = dateFormatter.date(from: createdAtString) ?? Date()
        } else {
            createdAt = Date()
        }
        
        confirmedAt = try? container.decodeIfPresent(Date.self, forKey: .confirmedAt)
        resolvedAt = try? container.decodeIfPresent(Date.self, forKey: .resolvedAt)
    }
}

// MARK: - 报警严重程度
enum AlertSeverity: String, Codable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case critical = "CRITICAL"
    
    var displayName: String {
        switch self {
        case .low: return "低"
        case .medium: return "中"
        case .high: return "高"
        case .critical: return "紧急"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "#4CAF50"      // 绿色
        case .medium: return "#FF9800"   // 橙色
        case .high: return "#FF5722"     // 红色
        case .critical: return "#D32F2F" // 深红色
        }
    }
}

// MARK: - 报警状态
enum AlertStatus: String, Codable {
    case unconfirmed = "UNCONFIRMED"
    case confirmed = "CONFIRMED"
    case resolved = "RESOLVED"
    
    var displayName: String {
        switch self {
        case .unconfirmed: return "未确认"
        case .confirmed: return "已确认"
        case .resolved: return "已解决"
        }
    }
}

// MARK: - 报警列表响应
struct AlertListResponse: Codable {
    let success: Bool
    let message: String?
    let data: AlertListData?
    
    struct AlertListData: Codable {
        let alerts: [Alert]
        let total: Int
        let page: Int
        let limit: Int
    }
}