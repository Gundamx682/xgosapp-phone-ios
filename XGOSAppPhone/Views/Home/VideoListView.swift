//
//  VideoListView.swift
//  XGOSAppPhone
//
//  视频列表界面
//

import SwiftUI

struct VideoListView: View {
    @StateObject private var viewModel = VideoListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: Constants.UI.backgroundColor)
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("加载中...")
                } else if viewModel.videos.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "video")
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                        
                        Text("暂无视频")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    }
                } else {
                    List {
                        ForEach(viewModel.videos) { video in
                            NavigationLink(destination: VideoPlayerView(video: video)) {
                                VideoListRow(video: video)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("视频列表")
            .onAppear {
                Task {
                    await viewModel.loadVideos()
                }
            }
            .refreshable {
                await viewModel.refreshVideos()
            }
        }
    }
}

// MARK: - 视频列表行

struct VideoListRow: View {
    let video: Video
    
    var body: some View {
        HStack(spacing: 12) {
            // 视频缩略图
            ZStack {
                Color.gray.opacity(0.3)
                    .frame(width: 100, height: 70)
                    .cornerRadius(8)
                
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            }
            
            // 视频信息
            VStack(alignment: .leading, spacing: 6) {
                Text(video.filename)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: Constants.UI.textColor))
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    Label(video.deviceId, systemImage: "car.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    
                    Label(video.formattedSize, systemImage: "doc.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    
                    if let duration = video.formattedDuration {
                        Label(duration, systemImage: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
                    }
                }
                
                Text(video.createdAt.relativeTimeDescription())
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: Constants.UI.textSecondaryColor))
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    VideoListView()
        .environmentObject(MQTTService.shared)
}