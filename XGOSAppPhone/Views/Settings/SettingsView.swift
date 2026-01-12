//
//  SettingsView.swift
//  XGOSAppPhone
//
//  设置界面
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var showLogoutAlert = false
    @State private var showServerConfigSheet = false
    @State private var isTestingConnection = false
    @State private var testConnectionResult: Bool?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constants.UI.backgroundColor)
                    .ignoresSafeArea()
                
                List {
                    // 用户信息
                    userInfoSection
                    
                    // 服务器配置
                    serverConfigSection
                    
                    // MQTT 状态
                    mqttStatusSection
                    
                    // 应用信息
                    appInfoSection
                    
                    // 退出登录
                    logoutSection
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("设置")
            .onAppear {
                settingsViewModel.loadSettings()
            }
            .sheet(isPresented: $showServerConfigSheet) {
                ServerConfigSheet(viewModel: settingsViewModel, isTestingConnection: $isTestingConnection, testConnectionResult: $testConnectionResult)
            }
            .alert("退出登录", isPresented: $showLogoutAlert) {
                Button("取消", role: .cancel) { }
                Button("退出", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("确定要退出登录吗？")
            }
        }
    }
    
    // MARK: - 用户信息
    
    private var userInfoSection: some View {
        Section {
            HStack(spacing: 16) {
                // 用户头像
                Circle()
                    .fill(Color(hex: Constants.UI.primaryColor))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(String(settingsViewModel.userInfo?.username.prefix(1).uppercased() ?? "U"))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                // 用户信息
                VStack(alignment: .leading, spacing: 4) {
                    Text(settingsViewModel.userInfo?.username ?? "未知用户")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: Constants.UI.textColor))
                    
                    if let email = settingsViewModel.userInfo?.email {
                        Text(email)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    }
                    
                    if let deviceId = settingsViewModel.userInfo?.deviceId {
                        Text("设备 ID: \(deviceId)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
        } header: {
            Text("用户信息")
        }
    }
    
    // MARK: - 服务器配置
    
    private var serverConfigSection: some View {
        Section {
            HStack {
                Text("服务器配置")
                    .foregroundColor(Color(hex: Constants.UI.textColor))
                
                Spacer()
                
                Text(settingsViewModel.serverAPIIP)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showServerConfigSheet = true
            }
        } header: {
            Text("服务器")
        }
    }
    
    // MARK: - MQTT 状态
    
    private var mqttStatusSection: some View {
        Section {
            HStack {
                Circle()
                    .fill(settingsViewModel.mqttConnectionState.isConnected ? Color.green : Color.red)
                    .frame(width: 10, height: 10)
                
                Text("MQTT 连接")
                    .foregroundColor(Color(hex: Constants.UI.textColor))
                
                Spacer()
                
                Text(settingsViewModel.mqttConnectionState.displayText)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
            }
        } header: {
            Text("连接状态")
        }
    }
    
    // MARK: - 应用信息
    
    private var appInfoSection: some View {
        Section {
            HStack {
                Text("应用版本")
                    .foregroundColor(Color(hex: Constants.UI.textColor))
                
                Spacer()
                
                Text(settingsViewModel.appVersion)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
            }
            
            HStack {
                Text("构建版本")
                    .foregroundColor(Color(hex: Constants.UI.textColor))
                
                Spacer()
                
                Text(settingsViewModel.buildNumber)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
            }
        } header: {
            Text("关于")
        }
    }
    
    // MARK: - 退出登录
    
    private var logoutSection: some View {
        Section {
            Button(action: {
                showLogoutAlert = true
            }) {
                Text("退出登录")
                    .font(.system(size: 16))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - 服务器配置面板

struct ServerConfigSheet: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Binding var isTestingConnection: Bool
    @Binding var testConnectionResult: Bool?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("API 服务器")
                            .foregroundColor(Color(hex: Constants.UI.textColor))
                        Spacer()
                        TextField("IP 地址", text: $viewModel.serverAPIIP)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 150)
                    }
                    
                    HStack {
                        Text("MQTT 服务器")
                            .foregroundColor(Color(hex: Constants.UI.textColor))
                        Spacer()
                        TextField("IP 地址", text: $viewModel.serverMQTTIP)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 150)
                    }
                } header: {
                    Text("服务器配置")
                } footer: {
                    Text("修改后需要重新连接 MQTT")
                }
                
                Section {
                    Button(action: {
                        Task {
                            await testConnection()
                        }
                    }) {
                        HStack {
                            if isTestingConnection {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: Constants.UI.primaryColor)))
                            } else if let result = testConnectionResult {
                                Image(systemName: result ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(result ? .green : .red)
                            }
                            
                            Text("测试连接")
                                .foregroundColor(Color(hex: Constants.UI.primaryColor))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .disabled(isTestingConnection)
                }
            }
            .navigationTitle("服务器配置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        viewModel.saveServerConfiguration()
                        dismiss()
                    }
                    .disabled(isTestingConnection)
                }
            }
        }
    }
    
    // MARK: - 测试连接
    
    private func testConnection() async {
        isTestingConnection = true
        testConnectionResult = nil
        
        let result = await viewModel.testServerConnection()
        
        testConnectionResult = result
        isTestingConnection = false
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
        .environmentObject(MQTTService.shared)
}