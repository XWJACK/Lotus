//
//  Client.swift
//  Lotus
//
//  Created by Jack on 14/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Base client for request
public class Client {
    
    public typealias SuccessBlock = (Data) -> ()
    public typealias ProgressBlock = (Progress) -> ()
    public typealias FailedBlock = (Error) -> ()
    public typealias ResponseBlock = () -> ()
    
    /// Origin URLRequest
    public final let request: URLRequest?
    /// Center.
    final weak var center: Center? = nil
    /// Delegate for Client.
    final let delegate: ClientDelegate
    /// Request error.
    final let error: Error?
    /// Begin request time.
    final var beginTime: TimeInterval = 0
//    /// Is cache response data.
//    final internal(set) var isCache: Bool = false
    
    final var successCallBack: (queue: DispatchQueue, block: SuccessBlock?)?
    final var progressCallBack: (queue: DispatchQueue, block: ProgressBlock?)?
    final var failedCallBack: (queue: DispatchQueue, block: FailedBlock?)?
    final var responseCallBack: (queue: DispatchQueue, block: ResponseBlock?)?
    
    /// Cache center.
    final var cacheCenter: CacheCenter? { return center?.configuration.cacheCenter }
    
    /// Init
    ///
    /// - Parameters:
    ///   - request: URLRequest
    ///   - delegate: ClientDelegate
    ///   - error: Error for request
    init(_ request: URLRequest?,
         delegate: ClientDelegate,
         error: Error? = nil) {
        
        self.request = request
        self.delegate = delegate
        self.error = error
        
        self.delegate.client = self
    }
    
    /// Resumes the task, if it is suspended.
    func resume() {
        delegate.task?.resume()
        beginTime = Date().timeIntervalSince1970
    }
    
//    /// Reading and saving cache. **Must after success block**.
//    ///
//    /// - Parameter isCache: Is need cached.
//    public func cache(_ isCache: Bool = true) {
//        self.isCache = isCache
//        guard isCache else { return }
//        cacheCenter?.read(dataByKey: request?.url?.absoluteString ?? "Error URL Cache Key", completed: { (data) in
//            if let queue = self.successCallBack?.queue {
//                queue.async { self.successCallBack?.block?(data) }
//            }
//        })
//    }
    
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
public final class DataClient: Client {
    
    public typealias RawDataBlock = (Data) -> ()
    
    var rawDataCallBack: (queue: DispatchQueue, block: RawDataBlock?)?
    
    /// Add raw data block, it may be called more than once, and each call provides only data received since the previous call. The app is responsible for accumulating this data if needed.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: DataBlock
    /// - Returns: Self
    @discardableResult
    public func receive(queue: DispatchQueue = .main, rawData block: (RawDataBlock)? = nil) -> Self {
        self.rawDataCallBack = (queue, block)
        return self
    }
    
    /// Add raw json block, it will call back when receive data and parse to JSON
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: JSON block
    /// - Returns: Self
    @discardableResult
    public func receive(queue: DispatchQueue = .main, rawJSON block: ((JSON) -> ())? = nil) -> Self {
        return receive(queue: queue, success: { block?((try? JSON(data: $0)) ?? JSON()) })
    }
    
    /// Add generic block, it will call back when receive data with no error.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: Generic block
    /// - Returns: Self
    @discardableResult
    public func receive<T: ResultConversion>(queue: DispatchQueue = .main, generic block: ((T) -> ())? = nil) -> Self {
        return receive(queue: queue, rawJSON: { [weak self] in
            
            if let error = T.result.error($0), let failedBlock = self?.failedCallBack?.block {
                self?.failedCallBack?.queue.async { failedBlock(LotusError.customError(error)) }
                return
            }
            
            block?(T(json: T.result.data($0)))
        })
    }
    
    /// Add generic array block, it will call back when receive data with no error.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: Generic array block
    /// - Returns: Self
    @discardableResult
    public func receive<T: ResultConversion>(queue: DispatchQueue = .main, genericArray block: (([T]) -> ())? = nil) -> Self {
        return receive(queue: queue, rawJSON: { [weak self] in
            
            if let error = T.result.error($0), let failedBlock = self?.failedCallBack?.block {
                self?.failedCallBack?.queue.async { failedBlock(LotusError.customError(error)) }
                return
            }
            
            block?(T.result.data($0).arrayValue.map{ T(json: $0) })
        })
    }
}
/*
/// Client for download request
open class DownloadClient: Client {
    
    public typealias DownloadBlock = (URL) -> ()
    
    var downloadCallBack: (queue: DispatchQueue, block: DownloadBlock?)?
    
    /// Add download block, it will call back when download success to url.
    ///
    /// - Parameters:
    ///   - queue: Call back queue
    ///   - block: DownloadBlock
    /// - Returns: Self
    @discardableResult
    public func receive(queue: DispatchQueue = .main, download block: (DownloadBlock)? = nil) -> Self {
        self.downloadCallBack = (queue, block)
        return self
    }
}
*/

//MARK: - 
extension Client: CustomLogConvertible {
    
    open var log: Log {
        var raw: [String: String] = [:]
        raw["Task Identifier"] = delegate.task?.taskIdentifier.description ?? "Unknow Task Identifier"
        raw["Begin Time"] = beginTime.description
        raw["Method"] = request?.httpMethod ?? "Unknow Method"
        raw["URL"] = request?.url?.absoluteString ?? "Unknow URL"
        raw["HTTP Header"] = request?.allHTTPHeaderFields?.description ?? "Unknow HTTP Header"
        raw["HTTP Body"] = request?.httpBody == nil ? "No HTTP Body" : String(data: request!.httpBody!, encoding: .utf8)
        raw["Error"] = error?.localizedDescription ?? "No Error"
        return Log(raw: raw)
    }
}
