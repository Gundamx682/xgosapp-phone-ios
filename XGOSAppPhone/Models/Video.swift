//
//  Video.swift
//  XGOSAppPhone
//
//  视频数据模型
//

import Foundation

struct Video: Codable, Identifiable {
    let id: String
    let userId: String
    let deviceId: String
    let filename: String
    let path: String
    let size: Int64
    let duration: Int?
    let resolution: String?
    let format: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case deviceId = "device_id"
        case filename
        case path
        case size
        case duration
        case resolution
        case format
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        deviceId = try container.decode(String.self, forKey: .deviceId)
        filename = try container.decode(String.self, forKey: .filename)
        path = try container.decode(String.self, forKey: .path)
        size = try container.decode(Int64.self, forKey: .size)
        duration = try? container.decodeIfPresent(Int.self, forKey: .duration)
        resolution = try? container.decodeIfPresent(String.self, forKey: .resolution)
        format = try? container.decodeIfPresent(String.self, forKey: .format)
        
        // 处理日期字符串
        let dateFormatter = ISO8601DateFormatter()
        if let createdAtString = try? container.decode(String.self, forKey: .createdAt) {
            createdAt = dateFormatter.date(from: createdAtString) ?? Date()
        } else {
            createdAt = Date()
        }
    }
    
    /// 获取视频 URL
    var videoURL: URL? {
        // path 格式: "username/filename.mp4"
        let baseURL = Constants.Server.apiBaseURL
        let urlString = "\(baseURL)/uploads/\(path)"
        return URL(string: urlString)
    }
    
    /// 格式化文件大小
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
    
    /// 格式化时长
    var formattedDuration: String {
        guard let duration = duration else { return "未知" }
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - 视频列表响应
struct VideoListResponse: Codable {
    let success: Bool
    let message: String?
    let data: VideoListData?
    
    struct VideoListData: Codable {
        let videos: [Video]
        let total: Int
        let page: Int
        let limit: Int
    }
}