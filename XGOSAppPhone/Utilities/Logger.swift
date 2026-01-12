//
//  Logger.swift
//  XGOSAppPhone
//
//  日志工具
//

import Foundation
import os.log

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

class Logger {
    
    static let shared = Logger()
    
    private let subsystem = "com.xgosapp.phone"
    
    private init() {}
    
    /// 调试日志
    func debug(_ message: String, tag: String = "XGOSApp") {
        log(message, level: .debug, tag: tag)
    }
    
    /// 信息日志
    func info(_ message: String, tag: String = "XGOSApp") {
        log(message, level: .info, tag: tag)
    }
    
    /// 警告日志
    func warning(_ message: String, tag: String = "XGOSApp") {
        log(message, level: .warning, tag: tag)
    }
    
    /// 错误日志
    func error(_ message: String, tag: String = "XGOSApp") {
        log(message, level: .error, tag: tag)
    }
    
    private func log(_ message: String, level: LogLevel, tag: String) {
        let timestamp = Date().formattedString(format: "yyyy-MM-dd HH:mm:ss.SSS")
        let logMessage = "[\(timestamp)] [\(level.rawValue)] [\(tag)] \(message)"
        
        #if DEBUG
        print(logMessage)
        #endif
        
        // 使用 os.log 记录
        let osLog = OSLog(subsystem: subsystem, category: tag)
        let osLogType: OSLogType
        switch level {
        case .debug:
            osLogType = .debug
        case .info:
            osLogType = .info
        case .warning:
            osLogType = .default
        case .error:
            osLogType = .error
        }
        os_log("%{public}@", log: osLog, type: osLogType, message)
    }
}

// MARK: - 便捷函数
func logDebug(_ message: String, tag: String = "XGOSApp") {
    Logger.shared.debug(message, tag: tag)
}

func logInfo(_ message: String, tag: String = "XGOSApp") {
    Logger.shared.info(message, tag: tag)
}

func logWarning(_ message: String, tag: String = "XGOSApp") {
    Logger.shared.warning(message, tag: tag)
}

func logError(_ message: String, tag: String = "XGOSApp") {
    Logger.shared.error(message, tag: tag)
}