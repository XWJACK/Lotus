//
//  Lotus.swift
//  Lotus
//
//  Created by Jack on 4/2/17.
//
//

import Foundation

public func send(_ url: URL) -> Client {
    return Session.default.send(url)
}

public func send(_ request: URLRequest) -> Client {
    return Session.default.send(request)
}

public func download(_ url: URL) -> Client {
    return Session.default.download(url)
}

public func download(_ request: URLRequest) -> Client {
    return Session.default.download(request)
}
