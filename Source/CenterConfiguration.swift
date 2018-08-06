//
//  CenterConfiguration.swift
//  Lotus
//
//  Created by Jack on 14/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation
import Alamofire

/// Configuration for Center.
public class CenterConfiguration {
    
    /// Custom host with http, default is empty string.
    public var host: (() -> URLConvertible) = { return "" }
    
    /// Custom global http headers, default is nil.
    public var headers: (() -> HTTPHeaders)? = nil
    
    /// System url session configuration.
    public let sessionConfiguration: URLSessionConfiguration
    
    /// Lotus debug center.
    public var debugCenter: DebugCenter = .default {
        didSet {
            debugCenter.configuration = self
        }
    }
    
    /// Lotus cache center.
    public var cacheCenter: CacheCenter = .default {
        didSet {
            cacheCenter.configuration = self
        }
    }
    
    /// Lotus log center.
    public var logCenter: LogCenter = .default {
        didSet {
            logCenter.configuration = self
        }
    }
    
    /// Initlization.
    ///
    /// - Parameter sessionConfig: URLSessionConfiguration, defualt is `default`
    public init(sessionConfig: URLSessionConfiguration = .default) {
        self.sessionConfiguration = sessionConfig
        
        debugCenter.configuration = self
        cacheCenter.configuration = self
        logCenter.configuration = self
    }
}
