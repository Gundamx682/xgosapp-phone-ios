//
//  AlertListView.swift
//  XGOSAppPhone
//
//  报警列表界面
//

import SwiftUI

struct AlertListView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constants.UI.backgroundColor)
                    .ignoresSafeArea()
                
                if homeViewModel.isLoadingAlerts {
                    ProgressView("加载中...")
                } else if homeViewModel.alerts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                        
                        Text("暂无报警")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    }
                } else {
                    List {
                        ForEach(homeViewModel.alerts) { alert in
                            AlertDetailRow(alert: alert, viewModel: homeViewModel)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("报警列表")
            .onAppear {
                Task {
                    await homeViewModel.loadAlerts()
                }
            }
            .refreshable {
                await homeViewModel.loadAlerts()
            }
        }
    }
}

// MARK: - 报警详情行

struct AlertDetailRow: View {
    let alert: Alert
    let viewModel: HomeViewModel
    @State private var showActionSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 顶部信息
            HStack {
                Circle()
                    .fill(Color(hex: alert.severity.color))
                    .frame(width: 10, height: 10)
                
                Text(alert.severity.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: alert.severity.color))
                
                Spacer()
                
                Text(alert.createdAt.relativeTimeDescription())
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
            }
            
            // 报警消息
            Text(alert.message)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: Constants.UI.textColor))
            
            // 设备信息
            HStack {
                Image(systemName: "car.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                
                Text(alert.deviceId)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                
                Spacer()
                
                // 状态标签
                Text(alert.status.displayName)
                    .font(.system(size: 12))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(4)
            }
            
            // 操作按钮
            if alert.status == .unconfirmed || alert.status == .confirmed {
                HStack(spacing: 10) {
                    if alert.status == .unconfirmed {
                        Button(action: {
                            Task {
                                await viewModel.confirmAlert(alertId: alert.id)
                            }
                        }) {
                            Text("确认")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .background(Color(hex: "#2196F3"))
                                .cornerRadius(8)
                        }
                    }
                    
                    if alert.status == .confirmed {
                        Button(action: {
                            Task {
                                await viewModel.resolveAlert(alertId: alert.id)
                            }
                        }) {
                            Text("解决")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .background(Color(hex: "#4CAF50"))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(hex: Constants.UI.cardColor))
        .cornerRadius(10)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
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

#Preview {
    AlertListView()
        .environmentObject(MQTTService.shared)
}