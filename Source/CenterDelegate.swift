//
//  CenterDelegate.swift
//  Lotus
//
//  Created by Jack on 14/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation

/// Center Delegate for URLSession
public final class CenterDelegate: NSObject, URLSessionDataDelegate {
    
    /// Saving all request.
    private var requests: [Int: Client] = [:]
    /// NSLock.
    private let lock = NSLock()
    
    /// Access the task delegate for the specified task in a thread-safe manner.
    public subscript(_ task: URLSessionTask) -> Client? {
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
    
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didCompleteWithError error: Error?) {
        
        guard let delegate = self[task]?.delegate as? DataClientDelegate else { return }
        
        delegate.urlSession(session, task: task, didCompleteWithError: error)
        
        self[task] = nil
    }
    
    //MARK: - URLSessionDataDelegate
    
    public func urlSession(_ session: URLSession,
                           dataTask: URLSessionDataTask,
                           didReceive data: Data) {
        
        (self[dataTask]?.delegate as? DataClientDelegate)?.urlSession(session, dataTask: dataTask, didReceive: data)
    }
    
    //MARK: - URLSessionDownloadDelegate
    
//    open func urlSession(_ session: URLSession,
//                         downloadTask: URLSessionDownloadTask,
//                         didFinishDownloadingTo location: URL) {
//        
//        guard let client = self[downloadTask] as? DownloadClient else { return }
//        
//        /// Download Block
//        if let url = client.downloadCallBack? {
//            try? FileManager.default.moveItem(at: location, to: url)
//        }
//    }
//    
//    open func urlSession(_ session: URLSession,
//                         downloadTask: URLSessionDownloadTask,
//                         didWriteData bytesWritten: Int64,
//                         totalBytesWritten: Int64,
//                         totalBytesExpectedToWrite: Int64) {
//        
//        guard let client = self[downloadTask] else { return }
//        
//        /// Progress Block
//        if let progressBlock = client.progressCallBack?.block {
//            
//            let progress = Progress(totalUnitCount: totalBytesExpectedToWrite)
//            progress.completedUnitCount = totalBytesWritten
//            
//            client.progressCallBack?.queue.async { progressBlock(progress) }
//        }
//    }
}
