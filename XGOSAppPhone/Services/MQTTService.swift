//
//  MQTTService.swift
//  XGOSAppPhone
//
//  MQTT 服务 - 实时消息推送
//

import Foundation
import CocoaMQTT
import Combine

class MQTTService: NSObject, ObservableObject, CocoaMQTTDelegate {
    
    static let shared = MQTTService()
    
    @Published var connectionState: MQTTConnectionState = .disconnected
    @Published var messages: [MQTTMessage] = []
    
    private var mqtt: CocoaMQTT?
    private var currentUserId: String?
    private var reconnectTimer: Timer?
    
    override private init() {
        super.init()
    }
    
    // MARK: - 设置
    
    func setup() {
        logInfo("MQTT Service initialized", tag: "MQTTService")
    }
    
    // MARK: - 连接管理
    
    func connect(username: String, password: String, userId: String) {
        self.currentUserId = userId
        
        // 断开现有连接
        disconnect()
        
        // 获取 MQTT 服务器地址
        let mqttIP = UserDefaults.standard.string(forKey: Constants.StorageKeys.serverMQTTIP) ?? Constants.Server.defaultMQTTIP
        
        // 生成唯一的 Client ID
        let clientID = "xgosapp-phone-\(username)-\(Int(Date().timeIntervalSince1970))"
        
        logInfo("Connecting to MQTT broker: \(mqttIP):\(Constants.Server.mqttPort)", tag: "MQTTService")
        logInfo("Client ID: \(clientID)", tag: "MQTTService")
        
        // 创建 MQTT 客户端
        mqtt = CocoaMQTT(clientID: clientID, host: mqttIP, port: UInt16(Constants.Server.mqttPort))
        mqtt?.username = username
        mqtt?.password = password
        mqtt?.delegate = self
        mqtt?.keepAlive = Constants.MQTT.keepAlive
        mqtt?.cleanSession = false
        
        // 连接
        connectionState = .connecting
        mqtt?.connect()
    }
    
    func disconnect() {
        logInfo("Disconnecting MQTT", tag: "MQTTService")
        mqtt?.disconnect()
        mqtt = nil
        connectionState = .disconnected
        stopReconnectTimer()
    }
    
    // MARK: - 订阅管理
    
    func subscribe(userId: String) {
        guard let mqtt = mqtt, mqtt.connState == .connected else {
            logWarning("MQTT not connected, cannot subscribe", tag: "MQTTService")
            return
        }
        
        let alertTopic = String(format: Constants.MQTT.alertTopic, userId)
        let videoTopic = String(format: Constants.MQTT.videoTopic, userId)
        
        mqtt.subscribe(alertTopic, qos: .qos1)
        mqtt.subscribe(videoTopic, qos: .qos1)
        
        logInfo("Subscribed to topics: \(alertTopic), \(videoTopic)", tag: "MQTTService")
    }
    
    func unsubscribe(userId: String) {
        guard let mqtt = mqtt else { return }
        
        let alertTopic = String(format: Constants.MQTT.alertTopic, userId)
        let videoTopic = String(format: Constants.MQTT.videoTopic, userId)
        
        mqtt.unsubscribe(alertTopic)
        mqtt.unsubscribe(videoTopic)
        
        logInfo("Unsubscribed from topics", tag: "MQTTService")
    }
    
    // MARK: - 重连机制
    
    private func startReconnectTimer() {
        stopReconnectTimer()
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: Constants.MQTT.reconnectDelay, repeats: false) { [weak self] _ in
            self?.reconnect()
        }
    }
    
    private func stopReconnectTimer() {
        reconnectTimer?.invalidate()
        reconnectTimer = nil
    }
    
    private func reconnect() {
        guard let userId = currentUserId else { return }
        
        // 从 UserDefaults 获取用户信息
        let username = UserDefaults.standard.string(forKey: Constants.StorageKeys.username) ?? ""
        let password = "" // MQTT 密码为空
        
        logInfo("Attempting to reconnect MQTT", tag: "MQTTService")
        connect(username: username, password: password, userId: userId)
    }
    
    // MARK: - CocoaMQTTDelegate
    
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        logInfo("MQTT connected to \(host):\(port)", tag: "MQTTService")
        connectionState = .connected
        
        // 订阅主题
        if let userId = currentUserId {
            subscribe(userId: userId)
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        logInfo("MQTT connect ack: \(ack.rawValue)", tag: "MQTTService")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        logInfo("MQTT message published", tag: "MQTTService")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        logInfo("MQTT publish ack: \(id)", tag: "MQTTService")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        guard let topic = message.topic,
              let payload = message.string else {
            return
        }
        
        logInfo("MQTT message received: \(topic)", tag: "MQTTService")
        
        // 创建消息对象
        let mqttMessage = MQTTMessage(topic: topic, payload: payload)
        
        // 添加到消息列表
        DispatchQueue.main.async {
            self.messages.append(mqttMessage)
            
            // 限制消息数量
            if self.messages.count > 500 {
                self.messages.removeFirst(self.messages.count - 500)
            }
        }
        
        // 处理消息
        handleMessage(mqttMessage)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        logInfo("MQTT subscribed to: \(topic)", tag: "MQTTService")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        logInfo("MQTT unsubscribed from: \(topic)", tag: "MQTTService")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        logDebug("MQTT ping", tag: "MQTTService")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        logDebug("MQTT pong", tag: "MQTTService")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        if let error = err {
            logError("MQTT disconnected with error: \(error.localizedDescription)", tag: "MQTTService")
            connectionState = .error(error)
            
            // 启动重连
            startReconnectTimer()
        } else {
            logInfo("MQTT disconnected", tag: "MQTTService")
            connectionState = .disconnected
        }
    }
    
    // MARK: - 消息处理
    
    private func handleMessage(_ message: MQTTMessage) {
        if message.isAlertMessage {
            handleAlertMessage(message)
        } else if message.isVideoMessage {
            handleVideoMessage(message)
        }
    }
    
    private func handleAlertMessage(_ message: MQTTMessage) {
        guard let alertData = message.parseAlertData() else {
            logError("Failed to parse alert message", tag: "MQTTService")
            return
        }
        
        logInfo("Alert received: \(alertData.deviceId) - \(alertData.message)", tag: "MQTTService")
        
        // 发送通知
        NotificationService.shared.sendAlertNotification(
            deviceId: alertData.deviceId,
            message: alertData.message
        )
    }
    
    private func handleVideoMessage(_ message: MQTTMessage) {
        guard let videoData = message.parseVideoData() else {
            logError("Failed to parse video message", tag: "MQTTService")
            return
        }
        
        logInfo("Video available: \(videoData.filename)", tag: "MQTTService")
        
        // 发送通知
        NotificationService.shared.sendVideoNotification(
            filename: videoData.filename,
            deviceId: videoData.deviceId
        )
    }
}