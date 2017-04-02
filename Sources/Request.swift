//
//  Request.swift
//  Lotus
//
//  Created by Jack on 4/2/17.
//
//

import Foundation

typealias ParamType = [String: String]

protocol Requestable {
    func send<Request, Response>(_ params: ParamType) -> Client<Request, Response>
}


