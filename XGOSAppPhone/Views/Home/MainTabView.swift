//
//  MainTabView.swift
//  XGOSAppPhone
//
//  主界面 - 底部导航栏
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)
            
            AlertListView()
                .tabItem {
                    Label("报警", systemImage: "exclamationmark.triangle.fill")
                }
                .tag(1)
            
            VideoListView()
                .tabItem {
                    Label("视频", systemImage: "video.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .accentColor(Color(hex: Constants.UI.primaryColor))
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(MQTTService.shared)
}