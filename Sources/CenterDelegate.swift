//
//  CenterDelegate.swift
//  Lotus
//
//  Created by Jack on 5/14/17.
//
//

import Foundation

open class CenterDelegate: NSObject, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    private var requests: [Int: Client] = [:]
    private let queue: DispatchQueue = DispatchQueue(label: "com.Lotus.CenterDelegate.Serial")
    
    func set(_ client: Client?,
             withTask task: URLSessionTask) {
        
        queue.async {
            self.requests[task.taskIdentifier] = client
        }
    }
    
    private func get(_ task: URLSessionTask,
                     block clientBlock: @escaping (Client?) -> ()) {
        
        queue.async {
            clientBlock(self.requests[task.taskIdentifier])
        }
    }
    
    //MARK: - URLSessionTaskDelegate
    
    open func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        
        get(task) { (client) in
            guard let client = client else { return }
            
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
        }
        
        
        /// Destory
        set(nil, withTask: task)
    }
    
    //MARK - URLSessionDataDelegate
    
    open func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        
        get(dataTask) { (client) in
            guard let client = client as? DataClient else { return }
            
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
    }
    
    //MARK - URLSessionDownloadDelegate
    
    open func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        get(downloadTask) { (client) in
            guard let client = client as? DownloadClient else { return }
            
            /// Download Block
            if let downloadBlock = client.downloadCallBack?.block {
                client.downloadCallBack?.queue.async { downloadBlock(location) }
            }
        }
    }
    
    open func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        get(downloadTask) { (client) in
            guard let client = client else { return }
            
            /// Progress Block
            if let progressBlock = client.progressCallBack?.block {
                
                let progress = Progress(totalUnitCount: totalBytesExpectedToWrite)
                progress.completedUnitCount = totalBytesWritten
                
                client.progressCallBack?.queue.async { progressBlock(progress) }
            }
        }
    }
}
