//
//  NotificationService.swift
//  XGOSAppPhone
//
//  通知服务
//

import Foundation
import UserNotifications

class NotificationService: NSObject, ObservableObject {
    
    static let shared = NotificationService()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override private init() {
        super.init()
        setupNotificationCategories()
    }
    
    // MARK: - 权限请求
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                logInfo("Notification authorization granted", tag: "NotificationService")
            } else {
                logWarning("Notification authorization denied", tag: "NotificationService")
            }
            
            if let error = error {
                logError("Notification authorization error: \(error.localizedDescription)", tag: "NotificationService")
            }
        }
    }
    
    // MARK: - 设置通知类别
    
    private func setupNotificationCategories() {
        let alertCategory = UNNotificationCategory(
            identifier: Constants.Notification.alertChannel,
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        let videoCategory = UNNotificationCategory(
            identifier: Constants.Notification.videoChannel,
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([alertCategory, videoCategory])
    }
    
    // MARK: - 发送报警通知
    
    func sendAlertNotification(deviceId: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "车辆预警"
        content.body = "\(deviceId): \(message)"
        content.sound = .default
        content.categoryIdentifier = Constants.Notification.alertChannel
        content.badge = 1
        
        // 添加震动
        content.threadIdentifier = "xgosapp_alerts"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "alert_\(deviceId)_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                logError("Failed to send alert notification: \(error.localizedDescription)", tag: "NotificationService")
            } else {
                logInfo("Alert notification sent: \(deviceId)", tag: "NotificationService")
            }
        }
    }
    
    // MARK: - 发送视频通知
    
    func sendVideoNotification(filename: String, deviceId: String) {
        let content = UNMutableNotificationContent()
        content.title = "新视频可用"
        content.body = "\(deviceId) 上传了新视频: \(filename)"
        content.sound = .default
        content.categoryIdentifier = Constants.Notification.videoChannel
        content.badge = 1
        
        // 添加震动
        content.threadIdentifier = "xgosapp_videos"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "video_\(filename)_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                logError("Failed to send video notification: \(error.localizedDescription)", tag: "NotificationService")
            } else {
                logInfo("Video notification sent: \(filename)", tag: "NotificationService")
            }
        }
    }
    
    // MARK: - 发送 MQTT 连接状态通知
    
    func sendMQTTStatusNotification(connected: Bool) {
        let content = UNMutableNotificationContent()
        
        if connected {
            content.title = "MQTT 已连接"
            content.body = "实时消息推送已启用"
            content.sound = .default
        } else {
            content.title = "MQTT 已断开"
            content.body = "实时消息推送已暂停"
            content.sound = .default
        }
        
        content.categoryIdentifier = Constants.Notification.mqttServiceChannel
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "mqtt_status_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                logError("Failed to send MQTT status notification: \(error.localizedDescription)", tag: "NotificationService")
            }
        }
    }
    
    // MARK: - 清除所有通知
    
    func clearAllNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
        logInfo("All notifications cleared", tag: "NotificationService")
    }
    
    // MARK: - 清除角标
    
    func clearBadge() {
        notificationCenter.setBadgeCount(0)
    }
}