//
//  DebugCenter.swift
//  Lotus
//
//  Created by Jack on 14/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation

/// Hock all request and response from Lotus.
/// Custom data struct when request.
open class DebugCenter {
    
    /// Given default debug center.
    public static let `default` = DebugCenter()
    
    /// Configuration for debug center.
    public weak var configuration: CenterConfiguration? = nil
    
    /// Initlization.
    public init() {
    }
    
    /// Lotus will send request.
    ///
    /// - Parameters:
    ///   - client: Raw DataClient.
    ///   - error: Error.
    /// - Returns: Custom modify DataClient, default is do nothing.
    open func send(_ client: DataClient, error: Error?) -> DataClient {
        return client
    }
    
    /// Lotus will recive response.
    ///
    /// - Parameters:
    ///   - task: URLSessionTask.
    ///   - data: The data has been receive.
    ///   - error: Error.
    /// - Returns: Custom data and error, default is do nothing.
    open func receive(_ task: URLSessionTask?, data: Data, error: Error?) -> (Data, Error?) {
        return (data, error)
    }
}
