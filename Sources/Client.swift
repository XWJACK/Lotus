//
//  Client.swift
//  Lotus
//
//  Created by Jack on 4/2/17.
//
//

import Foundation

open class Client<Request, Response> {
    
    public var request: URLRequest?
    public var response: HTTPURLResponse?
    
    func success() -> Self {
        return self
    }
    
    func failure() -> Self {
        return self
    }
    
    func then() -> Self {
        return self
    }
}
