//
//  Lotus.swift
//  Lotus
//
//  Created by Jack on 4/2/17.
//
//

import Foundation

public var globalFailBlock: ((Error) -> ())? = nil

public func send(_ url: URL) -> Client {
    return Session.default.send(url).receive(failed: globalFailBlock)
}

public func send(_ request: URLRequest) -> Client {
    return Session.default.send(request).receive(failed: globalFailBlock)
}
