//
//  Session.swift
//  Lotus
//
//  Created by Jack on 4/3/17.
//
//

import Foundation

open class Session {
    
    static public let `default`: Session = Session()
    
    public var globalFailBlock: ((Error) -> ())? = nil
    
    open var timeOut: TimeInterval = 60
    open let session: URLSession
    open let delegateQueue = OperationQueue()
    
    let delegate: SessionDelegate
    
    init(config: URLSessionConfiguration = .default,
         delegate: SessionDelegate = SessionDelegate()) {
        
        self.delegate = delegate
        
        config.timeoutIntervalForRequest = timeOut
        
        delegateQueue.maxConcurrentOperationCount = 1
        delegateQueue.name = "com.xwjack.Lotus.SessionDelegateQueue"
        delegateQueue.isSuspended = false
        
        session = URLSession(configuration: config,
                             delegate: delegate,
                             delegateQueue: delegateQueue)
    }
    
    public func send(_ url: URL) -> Client {
        let urlRequest = URLRequest(url: url, timeoutInterval: timeOut)
        return send(urlRequest)
    }
    
    public func send(_ request: URLRequest) -> Client {
        let dataTask = session.dataTask(with: request)
        let client = Client(request, dataTask)
        delegate[dataTask] = client
        dataTask.resume()
        return client
    }
}
