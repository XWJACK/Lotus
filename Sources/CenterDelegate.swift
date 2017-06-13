//
//  CenterDelegate.swift
//  Lotus
//
//  Created by Jack on 5/14/17.
//
//

import Foundation

/// Center Delegate for URLSession
open class CenterDelegate: NSObject, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    private var requests: [Int: Client] = [:]
    private let lock = NSLock()
    
    /// Access the task delegate for the specified task in a thread-safe manner.
    open subscript(task: URLSessionTask) -> Client? {
        get {
            lock.lock() ; defer { lock.unlock() }
            return requests[task.taskIdentifier]
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            requests[task.taskIdentifier] = newValue
        }
    }
    
    //MARK: - URLSessionTaskDelegate
    
    open func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        
        guard let client = self[task] else { return }
        
        /// Failed
        if let error = error,
            let failedBlock = client.failedCallBack?.block {
            client.failedCallBack?.queue.async { failedBlock(error) }
        } else if let successBlock = client.successCallBack?.block {
            client.successCallBack?.queue.async { successBlock(client.data) }
        }
        
        /// Response
        if let responseBlock = client.responseCallBack?.block {
            client.responseCallBack?.queue.async { responseBlock() }
        }
        
        self[task] = nil
    }
    
    //MARK: - URLSessionDataDelegate
    
    open func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        
        guard let client = self[dataTask] as? DataClient else { return }
        
        client.data.append(data)
        
        /// Data Response
        if let dataBlock = client.dataCallBack?.block {
            client.dataCallBack?.queue.async { dataBlock(data) }
        }
        
        /// Progress Block
        if let progressBlock = client.progressCallBack?.block {
            
            let totalBytesExpected = dataTask.response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            let progress = Progress(totalUnitCount: totalBytesExpected)
            progress.completedUnitCount = Int64(client.data.count)
            
            client.progressCallBack?.queue.async { progressBlock(progress) }
        }
    }
    
    //MARK: - URLSessionDownloadDelegate
    
    open func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        guard let client = self[downloadTask] as? DownloadClient else { return }
        
        /// Download Block
        if let downloadBlock = client.downloadCallBack?.block {
            client.downloadCallBack?.queue.async { downloadBlock(location) }
        }
    }
    
    open func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        guard let client = self[downloadTask] else { return }
        
        /// Progress Block
        if let progressBlock = client.progressCallBack?.block {
            
            let progress = Progress(totalUnitCount: totalBytesExpectedToWrite)
            progress.completedUnitCount = totalBytesWritten
            
            client.progressCallBack?.queue.async { progressBlock(progress) }
        }
    }
}
