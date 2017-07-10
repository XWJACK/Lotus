//
//  Client.swift
//  Lotus
//
//  Created by Jack on 5/14/17.
//
//

import Foundation

/// Base client for request
open class Client {
    
    public typealias SuccessBlock = (Data) -> ()
    public typealias ProgressBlock = (Progress) -> ()
    public typealias FailedBlock = (Error) -> ()
    public typealias ResponseBlock = () -> ()
    
    /// Origin URLRequest
    open let request: URLRequest
    /// Origin URLSessionTask
    open let task: URLSessionTask
    open internal(set) var data = Data()
    
    var successCallBack: (queue: DispatchQueue, block: SuccessBlock?)?
    var progressCallBack: (queue: DispatchQueue, block: ProgressBlock?)?
    var failedCallBack: (queue: DispatchQueue, block: FailedBlock?)?
    var responseCallBack: (queue: DispatchQueue, block: ResponseBlock?)?
    
    init(_ request: URLRequest,
         _ task: URLSessionTask) {
        
        self.request = request
        self.task = task
    }
    
    /// Add success block, it will call back when received response with no error.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: SuccessBlock
    /// - Returns: Self
    @discardableResult
    public func receive(queue: DispatchQueue = .main, success block: (SuccessBlock)? = nil) -> Self {
        self.successCallBack = (queue, block)
        return self
    }
    
    /// Add progress block, it may be call back muti-time.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: ProgressBlock
    /// - Returns: Self
    @discardableResult
    public func receive(queue: DispatchQueue = .main, progress block: (ProgressBlock)? = nil) -> Self {
        self.progressCallBack = (queue, block)
        return self
    }
    
    /// Add fail block, it will call back when received response with error.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: FailedBlock
    /// - Returns: Self
    @discardableResult
    public func receive(queue: DispatchQueue = .main, failed block: (FailedBlock)? = nil) -> Self {
        self.failedCallBack = (queue, block)
        return self
    }
    
    /// Add progress block, it will call back when received response.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: ResponseBlock
    /// - Returns: Self
    @discardableResult
    public func receive(queue: DispatchQueue = .main, response block: (ResponseBlock)? = nil) -> Self {
        self.responseCallBack = (queue, block)
        return self
    }
}

/// Client for data request
open class DataClient: Client {
    
    public typealias DataBlock = (Data) -> ()
    
    var dataCallBack: (queue: DispatchQueue, block: DataBlock?)?
    
    /// Add progress block, it may be called more than once, and each call provides only data received since the previous call. The app is responsible for accumulating this data if needed.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: DataBlock
    /// - Returns: Self
    @discardableResult
    public func receive(queue: DispatchQueue = .main, data block: (DataBlock)? = nil) -> Self {
        self.dataCallBack = (queue, block)
        return self
    }
}

/// Client for download request
open class DownloadClient: Client {
    
    public typealias DownloadBlock = () -> URL
    
    var downloadCallBack: DownloadBlock?
    
    /// Add download block, it will call back when download success to url.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: DownloadBlock
    /// - Returns: Self
    @discardableResult
    public func receive(download block: (DownloadBlock)? = nil) -> Self {
        self.downloadCallBack = block
        return self
    }
}
