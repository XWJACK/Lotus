//
//  LogCenter.swift
//  Lotus
//
//  Created by Jack on 17/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation

/// Custom conversion any type to Log.
public protocol CustomLogConvertible {
    var log: Log { get }
}

/// Custom log struct.
public final class Log {
    /// Raw log formatter.
    var raw: [String: String] = [:]
}

// MARK: - CustomLogConvertible

extension String: CustomLogConvertible {
    public var log: Log {
        let log = Log()
        log.raw["Info: "] = self
        return log
    }
}

/// Log Center to record log.
open class LogCenter {
    
    /// Default log center with default log file name.
    public static let `default` = LogCenter()
    /// Configuration for log center.
    public final weak var configuration: CenterConfiguration? = nil
    /// File url for saving logs.
    public final let logURL: URL
    /// Cache serial queue.
    private final let logQueue: DispatchQueue = DispatchQueue(label: "com.lotus.log.serial")
    
    /// Initlization.
    ///
    /// - Parameter logFileName: Log file name, default is **"com.gouhuoapp.log"**.
    public init(logFileName: String = "com.gouhuoapp.log") {
        logURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(logFileName)
        createLogFile()
    }
    
    /// Save log to file, sub class can override to custom formatter.
    ///
    /// - Parameters:
    ///   - log: Log
    ///   - logTime: Recording log time.
    /// - Returns: String formatter, default is separator by **", "** with no data.
    open func save(_ log: Log, witTime logTime: TimeInterval) -> String {
        log.raw["Data"] = nil
        return logTime.description + ", " + log.raw.values.joined(separator: ", ")
    }
    
    /// Display log to terminal, sub class can override to custom formatter.
    ///
    /// - Parameters:
    ///   - log: Log
    ///   - logTime: Recording log time.
    /// - Returns: String formatter, default is separator by **", "**.
    open func terminal(_ log: Log, witTime logTime: TimeInterval) -> String {
        return "👼" + Date(timeIntervalSince1970: logTime).description + ", " + log.raw.values.joined(separator: ", ")
    }
    
    /// Recording content whitch confirm CustomLogConvertible
    ///
    /// - Parameter content: CustomLogConvertible
    final public func record(_ content: CustomLogConvertible) {
        
        let logTime = Date().timeIntervalSince1970
        
        #if DEBUG
            logQueue.async {
                self.recordToTerminal(self.terminal(content.log, witTime: logTime))
                self.recordToFile(self.save(content.log, witTime: logTime))
            }
        #else
            logQueue.async {
                self.recordToFile(self.save(content.log, witTime: logTime))
            }
        #endif
    }
    
    /// Recording error.
    ///
    /// - Parameter content: Error
    final public func record(_ content: Error) {
        record(content.localizedDescription)
    }
    
    /// Recording log to terminal.
    ///
    /// - Parameter content: String
    private func recordToTerminal(_ content: String) {
        print(content)
    }
    
    /// Recording log to file.
    ///
    /// - Parameter content: String
    private func recordToFile(_ content: String) {
        do {
            guard let data = content.appending("\n").data(using: .utf8) else {
                throw LotusError.LogError.recordError
            }
            
            let fileHandle = try FileHandle(forWritingTo: self.logURL)
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        } catch {
            print(error)
        }
    }
    
    /// Create log file if not exist.
    private func createLogFile() {
        if !FileManager.default.fileExists(atPath: logURL.path) {
            FileManager.default.createFile(atPath: logURL.path, contents: nil, attributes: nil)
        }
    }
}
