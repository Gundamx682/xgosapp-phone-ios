//
//  HomeViewModel.swift
//  XGOSAppPhone
//
//  主界面视图模型
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    // 报警数据
    @Published var alerts: [Alert] = []
    @Published var isLoadingAlerts = false
    @Published var alertErrorMessage: String?
    
    // 视频数据
    @Published var videos: [Video] = []
    @Published var isLoadingVideos = false
    @Published var videoErrorMessage: String?
    
    // MQTT 消息
    @Published var mqttMessages: [MQTTMessage] = []
    
    // 服务器信息
    @Published var serverInfo: ServerInfoResponse.ServerInfoData?
    @Published var isLoadingServerInfo = false
    
    private let networkService = NetworkService.shared
    private let storageService = StorageService.shared
    private let mqttService = MQTTService.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupMQTTListener()
    }
    
    // MARK: - MQTT 监听
    
    private func setupMQTTListener() {
        mqttService.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] messages in
                self?.mqttMessages = messages
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 加载报警列表
    
    func loadAlerts() async {
        guard let token = storageService.getToken() else {
            alertErrorMessage = "未登录"
            return
        }
        
        isLoadingAlerts = true
        alertErrorMessage = nil
        
        defer {
            isLoadingAlerts = false
        }
        
        do {
            let response = try await networkService.getAlerts(token: token, page: 1, limit: 20)
            
            if response.success, let data = response.data {
                alerts = data.alerts
                logInfo("Loaded \(alerts.count) alerts", tag: "HomeViewModel")
            } else {
                alertErrorMessage = response.message ?? "加载报警列表失败"
            }
        } catch {
            logError("Failed to load alerts: \(error.localizedDescription)", tag: "HomeViewModel")
            alertErrorMessage = error.localizedDescription
        }
    }
    
    // MARK: - 加载视频列表
    
    func loadVideos() async {
        guard let token = storageService.getToken() else {
            videoErrorMessage = "未登录"
            return
        }
        
        isLoadingVideos = true
        videoErrorMessage = nil
        
        defer {
            isLoadingVideos = false
        }
        
        do {
            let response = try await networkService.getVideos(token: token, page: 1, limit: 20)
            
            if response.success, let data = response.data {
                videos = data.videos
                logInfo("Loaded \(videos.count) videos", tag: "HomeViewModel")
            } else {
                videoErrorMessage = response.message ?? "加载视频列表失败"
            }
        } catch {
            logError("Failed to load videos: \(error.localizedDescription)", tag: "HomeViewModel")
            videoErrorMessage = error.localizedDescription
        }
    }
    
    // MARK: - 确认报警
    
    func confirmAlert(alertId: String) async {
        guard let token = storageService.getToken() else {
            return
        }
        
        do {
            let response = try await networkService.confirmAlert(alertId: alertId, token: token)
            
            if response.success {
                // 更新本地报警状态
                if let index = alerts.firstIndex(where: { $0.id == alertId }) {
                    alerts[index] = Alert(
                        id: alerts[index].id,
                        deviceId: alerts[index].deviceId,
                        userId: alerts[index].userId,
                        severity: alerts[index].severity,
                        message: alerts[index].message,
                        status: .confirmed,
                        createdAt: alerts[index].createdAt,
                        confirmedAt: Date(),
                        resolvedAt: alerts[index].resolvedAt
                    )
                }
                
                logInfo("Alert confirmed: \(alertId)", tag: "HomeViewModel")
            }
        } catch {
            logError("Failed to confirm alert: \(error.localizedDescription)", tag: "HomeViewModel")
        }
    }
    
    // MARK: - 解决报警
    
    func resolveAlert(alertId: String) async {
        guard let token = storageService.getToken() else {
            return
        }
        
        do {
            let response = try await networkService.resolveAlert(alertId: alertId, token: token)
            
            if response.success {
                // 更新本地报警状态
                if let index = alerts.firstIndex(where: { $0.id == alertId }) {
                    alerts[index] = Alert(
                        id: alerts[index].id,
                        deviceId: alerts[index].deviceId,
                        userId: alerts[index].userId,
                        severity: alerts[index].severity,
                        message: alerts[index].message,
                        status: .resolved,
                        createdAt: alerts[index].createdAt,
                        confirmedAt: alerts[index].confirmedAt,
                        resolvedAt: Date()
                    )
                }
                
                logInfo("Alert resolved: \(alertId)", tag: "HomeViewModel")
            }
        } catch {
            logError("Failed to resolve alert: \(error.localizedDescription)", tag: "HomeViewModel")
        }
    }
    
    // MARK: - 加载服务器信息
    
    func loadServerInfo() async {
        isLoadingServerInfo = true
        
        defer {
            isLoadingServerInfo = false
        }
        
        do {
            let response = try await networkService.getServerInfo()
            
            if response.success, let data = response.data {
                serverInfo = data
                logInfo("Server info loaded", tag: "HomeViewModel")
            }
        } catch {
            logError("Failed to load server info: \(error.localizedDescription)", tag: "HomeViewModel")
        }
    }
    
    // MARK: - 刷新所有数据
    
    func refreshAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadAlerts() }
            group.addTask { await self.loadVideos() }
            group.addTask { await self.loadServerInfo() }
        }
    }
}