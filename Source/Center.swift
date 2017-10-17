//
//  Center.swift
//  Lotus
//
//  Created by Jack on 14/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation

/// Center for all request
public class Center {
    
    /// Default center instanse
    static public let `default`: Center = Center()
    
    /// Session
    public let session: URLSession
    /// Center delegate.
    public let delegate: CenterDelegate
    /// Center configuration.
    public let configuration: CenterConfiguration
    
    /// Center init
    ///
    /// - Parameters:
    ///   - configuration: CenterConfiguration
    ///   - delegate: CenterDelegate
    public init(configuration: CenterConfiguration = CenterConfiguration(),
                delegate: CenterDelegate = CenterDelegate()) {
        
        self.delegate = delegate
        self.configuration = configuration
        
        self.session = URLSession(configuration: configuration.sessionConfiguration,
                                  delegate: delegate,
                                  delegateQueue: nil)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    //MARK: - DataTask
    
    /// Send data task by Any conform RequestConversion
    ///
    /// - Parameter router: RequestConversion
    /// - Returns: DataClient
    @discardableResult
    public func send(_ router: RequestConversion) -> DataClient {
        
        var originRequest: URLRequest? = nil
        do {
            /// Getting url.
            let url = try configuration.host().asURL().appendingPathComponent(router.request.path)
            
            /// Getting http headers for all session.
            var headers: Headers = configuration.headers?() ?? [:]
            /// Add custom each request headers.
            router.request.headers?.forEach{ headers[$0.key] = $0.value }
            
            /// Making an origin request.
            originRequest = try URLRequest(url: url,
                                           method: router.request.method,
                                           headers: headers)
            /// Encoding origin request.
            let request = try router.request.encoding.encode(originRequest!,
                                                             with: router.request.parameters)
            
            return send(request, failedWith: nil)
        } catch {
            return send(originRequest, failedWith: error)
        }
    }
    
    /// Send data task by url
    ///
    /// - Parameter url: URL
    /// - Returns: DataClient
    @discardableResult
    public func send(_ url: URL) -> DataClient {
        let urlRequest = URLRequest(url: url)
        return send(urlRequest)
    }
    
    /// Send data task by URLRequest
    ///
    /// - Parameter request: URLRequest
    /// - Returns: DataClient
    @discardableResult
    public func send(_ request: URLRequest) -> DataClient {
        return send(request, failedWith: nil)
    }
    
    /// Send data task with error
    ///
    /// - Parameters:
    ///   - request: URLRequest
    ///   - error: Error
    /// - Returns: DataClient
    private func send(_ request: URLRequest?, failedWith error: Error?) -> DataClient {
        
        /// Is request is valid with no error.
        guard let validRequest = request, error == nil else {
            let client = DataClient(request, delegate: DataClientDelegate(task: nil), error: error)
            let modifyClient = configuration.debugCenter.send(client, error: error)
            configuration.logCenter.record(modifyClient)
            return modifyClient
        }
        
        /// Creating data task.
        let dataTask = session.dataTask(with: validRequest)
        let client = DataClient(validRequest, delegate: DataClientDelegate(task: dataTask))
        delegate[dataTask] = client
        client.center = self
        
        /// Debug this request.
        let modifyClient = configuration.debugCenter.send(client, error: error)
        
        /// Begining this request.
        modifyClient.resume()
        
        /// Recording this request.
        configuration.logCenter.record(modifyClient)
        
        return client
    }
}
