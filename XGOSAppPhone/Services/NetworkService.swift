//
//  NetworkService.swift
//  XGOSAppPhone
//
//  网络服务 - HTTP 请求
//

import Foundation
import Combine

class NetworkService: ObservableObject {
    
    static let shared = NetworkService()
    
    private let session: URLSession
    private var baseURL: String {
        return UserDefaults.standard.string(forKey: Constants.StorageKeys.serverAPIIP) ?? Constants.Server.defaultAPIIP
    }
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        session = URLSession(configuration: configuration)
    }
    
    // MARK: - 通用请求方法
    
    private func request<T: Codable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        token: String? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard let url = URL(string: "\(baseURL):\(Constants.Server.apiPort)\(endpoint)") else {
            throw AppError.networkError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        logInfo("API Request: \(method) \(url.absoluteString)", tag: "NetworkService")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.networkError("Invalid response")
            }
            
            logInfo("API Response: Status \(httpResponse.statusCode)", tag: "NetworkService")
            
            switch httpResponse.statusCode {
            case 200...299:
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            case 401:
                throw AppError.authenticationError
            case 400...499:
                if let errorResponse = try? JSONDecoder().decode(APIResponse<String>.self, from: data) {
                    throw AppError.serverError(errorResponse.message ?? "Client error")
                }
                throw AppError.serverError("Client error")
            case 500...599:
                if let errorResponse = try? JSONDecoder().decode(APIResponse<String>.self, from: data) {
                    throw AppError.serverError(errorResponse.message ?? "Server error")
                }
                throw AppError.serverError("Server error")
            default:
                throw AppError.networkError("Unexpected status code: \(httpResponse.statusCode)")
            }
        } catch let error as AppError {
            throw error
        } catch {
            logError("Network error: \(error.localizedDescription)", tag: "NetworkService")
            throw AppError.networkError(error.localizedDescription)
        }
    }
    
    // MARK: - 认证接口
    
    /// 用户登录
    func login(username: String, password: String) async throws -> AuthResponse {
        let request = LoginRequest(username: username, password: password)
        let body = try JSONEncoder().encode(request)
        return try await request(
            endpoint: Constants.API.login,
            method: "POST",
            body: body,
            responseType: AuthResponse.self
        )
    }
    
    /// 用户注册
    func register(username: String, password: String, deviceId: String, email: String? = nil) async throws -> AuthResponse {
        let request = RegisterRequest(username: username, password: password, deviceId: deviceId, email: email)
        let body = try JSONEncoder().encode(request)
        return try await request(
            endpoint: Constants.API.register,
            method: "POST",
            body: body,
            responseType: AuthResponse.self
        )
    }
    
    /// 获取用户信息
    func getUserInfo(token: String) async throws -> UserInfoResponse {
        return try await request(
            endpoint: Constants.API.userInfo,
            method: "GET",
            token: token,
            responseType: UserInfoResponse.self
        )
    }
    
    // MARK: - 报警接口
    
    /// 获取报警列表
    func getAlerts(token: String, page: Int = 1, limit: Int = 20) async throws -> AlertListResponse {
        let endpoint = "\(Constants.API.alerts)?page=\(page)&limit=\(limit)"
        return try await request(
            endpoint: endpoint,
            method: "GET",
            token: token,
            responseType: AlertListResponse.self
        )
    }
    
    /// 确认报警
    func confirmAlert(alertId: String, token: String) async throws -> ConfirmAlertResponse {
        let endpoint = "\(Constants.API.alerts)/\(alertId)/confirm"
        return try await request(
            endpoint: endpoint,
            method: "POST",
            token: token,
            responseType: ConfirmAlertResponse.self
        )
    }
    
    /// 解决报警
    func resolveAlert(alertId: String, token: String) async throws -> ResolveAlertResponse {
        let endpoint = "\(Constants.API.alerts)/\(alertId)/resolve"
        return try await request(
            endpoint: endpoint,
            method: "POST",
            token: token,
            responseType: ResolveAlertResponse.self
        )
    }
    
    // MARK: - 视频接口
    
    /// 获取视频列表
    func getVideos(token: String, page: Int = 1, limit: Int = 20) async throws -> VideoListResponse {
        let endpoint = "\(Constants.API.videos)?page=\(page)&limit=\(limit)"
        return try await request(
            endpoint: endpoint,
            method: "GET",
            token: token,
            responseType: VideoListResponse.self
        )
    }
    
    // MARK: - 服务器接口
    
    /// 获取服务器信息
    func getServerInfo() async throws -> ServerInfoResponse {
        return try await request(
            endpoint: "/api/admin/stats",
            method: "GET",
            responseType: ServerInfoResponse.self
        )
    }
}