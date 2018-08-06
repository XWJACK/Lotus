//
//  Lotus.swift
//  Lotus
//
//  Created by Jack on 14/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation
import Alamofire

//MARK: - Custom for Lotus

/// Struct for request.
public struct Request {
    
    /// Path for request.
    public let path: String
    /// Parameters for request.
    public let parameters: Parameters?
    /// Method for request.
    public let method: HTTPMethod
    /// Encoding for request.
    public let encoding: URLEncoding
    /// HTTP Headers
    public let headers: HTTPHeaders?
    
    /// Request struct
    ///
    /// - Parameters:
    ///   - path: Path for request
    ///   - parameters: Parameters for request, default is `nil`.
    ///   - method: Method for request, default is `get`.
    ///   - encoding: Encoding for request, default is `default`
    ///   - headers: HTTP Header for request, default is nil.
    public init(path: String,
                parameters: Parameters? = nil,
                method: HTTPMethod = .get,
                encoding: URLEncoding = .default,
                headers: HTTPHeaders? = nil) {
        
        self.path = path
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
}

/// Abstract JSON Result
public typealias AbstractJSONResult = Dictionary<String, Any>

/// Confirm this protocol to conversion any type to RequestStruct.
public protocol RequestConversion {
    /// Request adapter
    var request: Request { get }
}

/// Confirm this protocol to conversion data to any type.
public protocol ResultConversion: Decodable {
    /// Custom parse data, default is current
    static var data: (AbstractJSONResult) -> AbstractJSONResult { get }
    /// Custom error for failed call back, default is always no error.
    static var error: (AbstractJSONResult) -> Error? { get }
}

// Given default for ResultConversion.
public extension ResultConversion {
    static var data: (AbstractJSONResult) -> AbstractJSONResult { return { $0 } }
    static var error: (AbstractJSONResult) -> Error? { return { _ in nil } }
}

//MARK: - Public function

/// Send data task by Any conform RequestConversion
///
/// - Parameter router: RequestConversion
/// - Returns: DataClient
@discardableResult
public func send(_ router: RequestConversion) -> DataClient {
    return Center.default.send(router)
}

/// Send data task by url
///
/// - Parameter url: URL
/// - Returns: DataClient
@discardableResult
public func send(_ url: URL) -> DataClient {
    return Center.default.send(url)
}

/// Send data task by URLRequest
///
/// - Parameter request: URLRequest
/// - Returns: DataClient
@discardableResult
public func send(_ request: URLRequest) -> DataClient {
    return Center.default.send(request)
}
