//
//  ClientDelegate.swift
//  Lotus
//
//  Created by Jack on 15/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Client delegate.
class ClientDelegate: NSObject, URLSessionTaskDelegate {
    
    /// Client
    final weak var client: Client?
    /// URLSessionTask
    final let task: URLSessionTask?
    /// Response Error
    fileprivate(set) final var error: Error?
    /// Data for request
    fileprivate final var data = Data()
    /// Response time.
    fileprivate final var endTime: TimeInterval = 0
    /// Debug center.
    fileprivate final var debugCenter: DebugCenter? { return client?.center?.configuration.debugCenter }
    /// Cache center.
    fileprivate final var cacheCenter: CacheCenter? { return client?.center?.configuration.cacheCenter }
    /// Log center.
    fileprivate final var logCenter: LogCenter? { return client?.center?.configuration.logCenter }
    
    /// Init with task.
    ///
    /// - Parameter task: URLSessionTask
    init(task: URLSessionTask?) {
        self.task = task
    }
    
    //MARK: - URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        
        endTime = Date().timeIntervalSince1970
        
        guard let client = client else { return }
        
        (self.data, self.error) = debugCenter?.receive(task, data: self.data, error: error) ?? (self.data, self.error)
        logCenter?.record(self)
        
        /// Failed
        if let error = self.error {
            
            if let failedBlock = client.failedCallBack?.block {
                client.failedCallBack?.queue.async { failedBlock(LotusError.systemError(error)) }
            }
            
        } else {
            
            if let successBlock = client.successCallBack?.block {
                client.successCallBack?.queue.async { successBlock(self.data) }
            }
            
//            if client.isCache {
//                cacheCenter?.save(data: self.data.isEmpty ? nil : self.data, withKey: task.response?.url?.absoluteString ?? "Error URL Cache Key")
//            }
        }
        
        /// Response
        if let responseBlock = client.responseCallBack?.block {
            client.responseCallBack?.queue.async { responseBlock() }
        }
    }
}

/// Data client delegate.
final class DataClientDelegate: ClientDelegate, URLSessionDataDelegate {
    
    //MARK: - URLSessionDataDelegate
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        
        guard let client = client as? DataClient else { return }
        
        self.data.append(data)
        
        /// Data Response
        if let dataBlock = client.rawDataCallBack?.block {
            client.rawDataCallBack?.queue.async { dataBlock(data) }
        }
        
        /// Progress Block
        if let progressBlock = client.progressCallBack?.block {
            
            let totalBytesExpected = dataTask.response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            let progress = Progress(totalUnitCount: totalBytesExpected)
            progress.completedUnitCount = Int64(self.data.count)
            
            client.progressCallBack?.queue.async { progressBlock(progress) }
        }
    }

}

// MARK: - CustomLogConvertible

extension ClientDelegate: CustomLogConvertible {
    var log: Log {
        let response = task?.response as? HTTPURLResponse
        var raw: [String: String] = [:]
        raw["Task Identifier"] = task?.taskIdentifier.description ?? "Unknow Task Identifier"
        raw["End Time"] = endTime.description
        raw["URL"] = response?.url?.absoluteString ?? "Unknow URL"
        raw["Response Code"] = response?.statusCode.description ?? "Unknow Status Code"
        raw["HTTP Header"] = (response?.allHeaderFields as? [String: String])?.description ?? "Unknow HTTP Header"
        raw["Data"] = data.isEmpty ? "Empty Data" : try? JSON(data: data).rawString() ?? "Unable To Parse Data"
        raw["Error"] = error?.localizedDescription ?? "No Error"
        return Log(raw: raw)
    }
}
