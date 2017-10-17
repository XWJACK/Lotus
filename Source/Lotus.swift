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
//import CommonCrypto

//MARK: - Typealias

public typealias Parameters = Alamofire.Parameters
public typealias Method = Alamofire.HTTPMethod
public typealias URLEncoding = Alamofire.URLEncoding
public typealias URLConvertible = Alamofire.URLConvertible
public typealias AlamofireError = Alamofire.AFError
public typealias Headers = Alamofire.HTTPHeaders

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

//MARK: - Temp add.
/*
extension String {
    /// MD5
    ///
    /// For more information about import C library into Framework:
    /// http://stackoverflow.com/questions/25248598/importing-commoncrypto-in-a-swift-framework/37125785#37125785 and
    /// https://github.com/onmyway133/Arcane
    ///
    /// - returns: nil `iff` encoding is not utf8
    public func md5() -> String? {
        guard let messageData = self.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
*/