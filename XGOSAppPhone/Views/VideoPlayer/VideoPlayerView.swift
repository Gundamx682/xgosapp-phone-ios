//
//  VideoPlayerView.swift
//  XGOSAppPhone
//
//  视频播放器 - 全屏沉浸式播放
//

import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayerView: View {
    let video: Video
    @Environment(\.dismiss) var dismiss
    @State private var showControls = true
    @State private var hideControlsTask: Task<Void, Never>?
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if let url = video.videoURL {
                VideoPlayerControllerView(url: url, showControls: $showControls)
                    .ignoresSafeArea()
            }
            
            // 返回按钮
            if showControls {
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                }
            }
        }
        .onTapGesture {
            toggleControls()
        }
        .statusBar(hidden: !showControls)
        .onAppear {
            startAutoHideTimer()
        }
        .onDisappear {
            hideControlsTask?.cancel()
        }
    }
    
    // MARK: - 切换控制栏
    
    private func toggleControls() {
        withAnimation {
            showControls.toggle()
        }
        
        if showControls {
            startAutoHideTimer()
        } else {
            hideControlsTask?.cancel()
        }
    }
    
    // MARK: - 自动隐藏计时器
    
    private func startAutoHideTimer() {
        hideControlsTask?.cancel()
        hideControlsTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(Constants.Video.autoHideDelay * 1_000_000_000))
            
            if !Task.isCancelled && showControls {
                withAnimation {
                    showControls = false
                }
            }
        }
    }
}

// MARK: - 视频播放器控制器

struct VideoPlayerControllerView: UIViewControllerRepresentable {
    let url: URL
    @Binding var showControls: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: url)
        controller.showsPlaybackControls = false
        controller.allowsPictureInPicturePlayback = false
        
        // 设置播放器行为
        controller.entersFullScreenWhenPlaybackBegins = true
        controller.exitsFullScreenWhenPlaybackEnds = false
        
        // 开始播放
        controller.player?.play()
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // 根据控制栏状态显示/隐藏
        if showControls {
            uiViewController.showsPlaybackControls = true
        } else {
            uiViewController.showsPlaybackControls = false
        }
    }
}

#Preview {
    let video = Video(
        id: "1",
        userId: "user1",
        deviceId: "device1",
        filename: "test.mp4",
        path: "user1/test.mp4",
        size: 1024000,
        duration: 60,
        resolution: "1920x1080",
        format: "mp4",
        createdAt: Date()
    )
    
    return VideoPlayerView(video: video)
}