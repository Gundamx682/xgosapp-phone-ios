//
//  VideoListViewModel.swift
//  XGOSAppPhone
//
//  视频列表视图模型
//

import Foundation

@MainActor
class VideoListViewModel: ObservableObject {
    
    @Published var videos: [Video] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkService = NetworkService.shared
    private let storageService = StorageService.shared
    
    // MARK: - 加载视频列表
    
    func loadVideos() async {
        guard let token = storageService.getToken() else {
            errorMessage = "未登录"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await networkService.getVideos(token: token, page: 1, limit: 50)
            
            if response.success, let data = response.data {
                videos = data.videos
                logInfo("Loaded \(videos.count) videos", tag: "VideoListViewModel")
            } else {
                errorMessage = response.message ?? "加载视频列表失败"
            }
        } catch {
            logError("Failed to load videos: \(error.localizedDescription)", tag: "VideoListViewModel")
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - 刷新视频列表
    
    func refreshVideos() async {
        await loadVideos()
    }
}