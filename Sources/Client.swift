//
//  Client.swift
//  Lotus
//
//  Created by Jack on 5/14/17.
//
//

import Foundation

public typealias ClientSuccessBlock = (Data) -> ()

public typealias ClientDataBlock = (Data) -> ()
public typealias ClientProgressBlock = (Progress) -> ()
public typealias ClientFailedBlock = (Error) -> ()
public typealias ClientResponseBlock = () -> ()

public typealias ClientDownloadBlock = (URL) -> ()

open class Client {
    
    open let request: URLRequest
    open let task: URLSessionTask
    open internal(set) var data = Data()
    
    var successCallBack: (queue: DispatchQueue, block: ClientSuccessBlock?)?
    
    var dataCallBack: (queue: DispatchQueue, block: ClientDataBlock?)?
    var progressCallBack: (queue: DispatchQueue, block: ClientProgressBlock?)?
    var failedCallBack: (queue: DispatchQueue, block: ClientFailedBlock?)?
    var responseCallBack: (queue: DispatchQueue, block: ClientResponseBlock?)?
    
    var downloadCallBack: (queue: DispatchQueue, block: ClientDownloadBlock?)?
    
    init(_ request: URLRequest, _ task: URLSessionTask) {
        self.request = request
        self.task = task
    }
    
    @discardableResult
    public func receive(_ queue: DispatchQueue = .main, success block: (ClientSuccessBlock)? = nil) -> Self {
        self.successCallBack = (queue, block)
        return self
    }
    
    @discardableResult
    public func receive(_ queue: DispatchQueue = .main, data block: (ClientDataBlock)? = nil) -> Self {
        self.dataCallBack = (queue, block)
        return self
    }
    
    @discardableResult
    public func receive(_ queue: DispatchQueue = .main, progress block: (ClientProgressBlock)? = nil) -> Self {
        self.progressCallBack = (queue, block)
        return self
    }
    
    @discardableResult
    public func receive(_ queue: DispatchQueue = .main, failed block: (ClientFailedBlock)? = nil) -> Self {
        self.failedCallBack = (queue, block)
        return self
    }
    
    @discardableResult
    public func receive(_ queue: DispatchQueue = .main, response block: (ClientResponseBlock)? = nil) -> Self {
        self.responseCallBack = (queue, block)
        return self
    }
    
    @discardableResult
    public func receive(_ queue: DispatchQueue = .main, download block: (ClientDownloadBlock)? = nil) -> Self {
        self.downloadCallBack = (queue, block)
        return self
    }
}
