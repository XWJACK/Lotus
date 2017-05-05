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
    
    open let session: URLSession
    
    public init(config: URLSessionConfiguration = .default) {
        session = URLSession(configuration: config)
    }
    
//    open func request(_ urlRequest: URLRequest) -> DataRequest {
//        
//    }
}
