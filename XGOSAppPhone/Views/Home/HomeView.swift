//
//  HomeView.swift
//  XGOSAppPhone
//
//  首页
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constants.UI.backgroundColor)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 欢迎信息
                        welcomeSection
                        
                        // MQTT 连接状态
                        mqttStatusSection
                        
                        // 统计信息
                        if let serverInfo = homeViewModel.serverInfo {
                            statisticsSection(serverInfo: serverInfo)
                        }
                        
                        // 最近报警
                        recentAlertsSection
                        
                        // 最近视频
                        recentVideosSection
                    }
                    .padding()
                }
            }
            .navigationTitle("首页")
            .onAppear {
                Task {
                    await homeViewModel.refreshAllData()
                }
            }
            .refreshable {
                await homeViewModel.refreshAllData()
            }
        }
    }
    
    // MARK: - 欢迎信息
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("欢迎回来，\(authViewModel.userInfo?.username ?? "用户")")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: Constants.UI.textColor))
            
            Text("今天是 \(Date().formattedString(format: "yyyy年MM月dd日"))")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - MQTT 连接状态
    
    private var mqttStatusSection: some View {
        HStack {
            Circle()
                .fill(homeViewModel.mqttConnectionState.isConnected ? Color.green : Color.red)
                .frame(width: 10, height: 10)
            
            Text("MQTT: \(homeViewModel.mqttConnectionState.displayText)")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
            
            Spacer()
        }
        .padding()
        .background(Color(hex: Constants.UI.cardColor))
        .cornerRadius(10)
    }
    
    // MARK: - 统计信息
    
    private func statisticsSection(serverInfo: ServerInfoResponse.ServerInfoData) -> some View {
        VStack(spacing: 15) {
            Text("系统统计")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: Constants.UI.textColor))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 15) {
                StatCard(title: "用户", value: "\(serverInfo.users)", icon: "person.fill", color: "#2196F3")
                StatCard(title: "设备", value: "\(serverInfo.devices)", icon: "car.fill", color: "#FF9800")
                StatCard(title: "报警", value: "\(serverInfo.alerts)", icon: "exclamationmark.triangle.fill", color: "#F44336")
                StatCard(title: "视频", value: "\(serverInfo.videos)", icon: "video.fill", color: "#4CAF50")
            }
        }
        .padding()
        .background(Color(hex: Constants.UI.cardColor))
        .cornerRadius(10)
    }
    
    // MARK: - 最近报警
    
    private var recentAlertsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("最近报警")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: Constants.UI.textColor))
                
                Spacer()
                
                NavigationLink(destination: AlertListView()) {
                    Text("查看全部")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: Constants.UI.primaryColor))
                }
            }
            
            if homeViewModel.isLoadingAlerts {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if homeViewModel.alerts.isEmpty {
                Text("暂无报警")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(homeViewModel.alerts.prefix(5)) { alert in
                    AlertRow(alert: alert)
                }
            }
        }
        .padding()
        .background(Color(hex: Constants.UI.cardColor))
        .cornerRadius(10)
    }
    
    // MARK: - 最近视频
    
    private var recentVideosSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("最近视频")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: Constants.UI.textColor))
                
                Spacer()
                
                NavigationLink(destination: VideoListView()) {
                    Text("查看全部")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: Constants.UI.primaryColor))
                }
            }
            
            if homeViewModel.isLoadingVideos {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if homeViewModel.videos.isEmpty {
                Text("暂无视频")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(homeViewModel.videos.prefix(5)) { video in
                    VideoRow(video: video)
                }
            }
        }
        .padding()
        .background(Color(hex: Constants.UI.cardColor))
        .cornerRadius(10)
    }
}

// MARK: - 统计卡片

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: Constants.UI.textColor))
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: Constants.UI.backgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - 报警行

struct AlertRow: View {
    let alert: Alert
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(hex: alert.severity.color))
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.message)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textColor))
                    .lineLimit(1)
                
                Text("\(alert.deviceId) • \(alert.createdAt.relativeTimeDescription())")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
            }
            
            Spacer()
            
            Text(alert.status.displayName)
                .font(.system(size: 12))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.2))
                .foregroundColor(statusColor)
                .cornerRadius(4)
        }
        .padding(.vertical, 8)
    }
    
    private var statusColor: Color {
        switch alert.status {
        case .unconfirmed:
            return Color(hex: "#FF9800")
        case .confirmed:
            return Color(hex: "#2196F3")
        case .resolved:
            return Color(hex: "#4CAF50")
        }
    }
}

// MARK: - 视频行

struct VideoRow: View {
    let video: Video
    
    var body: some View {
        HStack {
            Image(systemName: "video.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(hex: Constants.UI.primaryColor))
                .frame(width: 40, height: 40)
                .background(Color(hex: Constants.UI.primaryColor).opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(video.filename)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textColor))
                    .lineLimit(1)
                
                Text("\(video.deviceId) • \(video.formattedSize) • \(video.createdAt.relativeTimeDescription())")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
            }
            
            Spacer()
            
            NavigationLink(destination: VideoPlayerView(video: video)) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: Constants.UI.primaryColor))
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(MQTTService.shared)
}