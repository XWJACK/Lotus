//
//  Lotus.swift
//  Lotus
//
//  Created by Jack on 14/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK: - Typealias

//MARK: Alamofire
public typealias Parameters = Alamofire.Parameters
public typealias Method = Alamofire.HTTPMethod
public typealias URLEncoding = Alamofire.URLEncoding
public typealias URLConvertible = Alamofire.URLConvertible
public typealias AlamofireError = Alamofire.AFError
public typealias Headers = Alamofire.HTTPHeaders
//MARK: SwiftyJSON
public typealias JSON = SwiftyJSON.JSON

//MARK: - Custom for Lotus

/// Struct for request.
public struct Request {
    
    /// Path for request.
    public let path: String
    /// Parameters for request.
    public let parameters: Parameters?
    /// Method for request.
    public let method: Method
    /// Encoding for request.
    public let encoding: URLEncoding
    /// HTTP Headers
    public let headers: Headers?
    
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
                method: Method = .get,
                encoding: URLEncoding = .default,
                headers: Headers? = nil) {
        
        self.path = path
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
}

/// Struct for result
open class Result {
    
    /// Custom parse data, default is in "data"
    open var data: (JSON) -> JSON
    /// Custom error for failed call back, default is always no error.
    open var error: (JSON) -> Error?
    
    /// Struct for result
    public init(data: @escaping (JSON) -> JSON = { $0["data"] },
                error: @escaping (JSON) -> Error? = { _ in nil }) {
        self.data = data
        self.error = error
    }
}

/// Confirm this protocol to conversion any type to RequestStruct.
public protocol RequestConversion {
    /// Request adapter
    var request: Request { get }
}

/// Confirm this protocol to conversion data to any type.
public protocol ResultConversion {
    /// Result parse.
    static var result: Result { get }
    /// Result adapter
    init(json: JSON)
}

// Given default.
public extension ResultConversion {
    static var result: Result { return Result() }
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
