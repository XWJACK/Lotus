//
//  Center.swift
//  Lotus
//
//  Created by Jack on 4/3/17.
//
//

import Foundation

/// Center for all request
open class Center {
    
    /// Default center instanse
    static public let `default`: Center = Center()
    
    open var globalFailCallBack: (queue: DispatchQueue, block: Client.FailedBlock?) = (.global(qos: .background), nil)
    
    /// Timeout for request
    open var timeOut: TimeInterval = 60
    open let session: URLSession
    open let delegate: CenterDelegate
    
    public init(config: URLSessionConfiguration = .default,
                delegate: CenterDelegate = CenterDelegate()) {
        
        self.delegate = delegate
        
        config.timeoutIntervalForRequest = timeOut
        
        session = URLSession(configuration: config,
                             delegate: delegate,
                             delegateQueue: nil)
    }
    
    //MARK: - DataTask
    
    /// Send data task by url
    ///
    /// - Parameter url: URL
    /// - Returns: DataClient
    public func send(_ url: URL) -> DataClient {
        let urlRequest = URLRequest(url: url, timeoutInterval: timeOut)
        return send(urlRequest)
    }
    
    /// Send data task by URLRequest
    ///
    /// - Parameter request: URLRequest
    /// - Returns: DataClient
    public func send(_ request: URLRequest) -> DataClient {
        let dataTask = session.dataTask(with: request)
        let client = DataClient(request, dataTask)
        delegate.set(client, withTask: dataTask)
        dataTask.resume()
        return client.receive(queue: globalFailCallBack.queue, failed: globalFailCallBack.block)
    }
    
    //MARK: - DownloadTask
    
    /// Download by url
    ///
    /// - Parameter url: URL
    /// - Returns: DownloadClient
    public func download(_ url: URL) -> DownloadClient {
        let urlRequest = URLRequest(url: url, timeoutInterval: timeOut)
        return download(urlRequest)
    }
    
    /// Download by URLRequest
    ///
    /// - Parameter request: URLRequest
    /// - Returns: DownloadClient
    public func download(_ request: URLRequest) -> DownloadClient {
        let downloadTask = session.downloadTask(with: request)
        let client = DownloadClient(request, downloadTask)
        delegate.set(client, withTask: downloadTask)
        downloadTask.resume()
        return client.receive(queue: globalFailCallBack.queue, failed: globalFailCallBack.block)
    }
}
