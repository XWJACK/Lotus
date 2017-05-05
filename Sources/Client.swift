//
//  Client.swift
//  Lotus
//
//  Created by Jack on 4/2/17.
//
//

import Foundation
import Alamofire

protocol Clientable {
    static func request(method: HTTPMethod)
}

protocol GET {
    static func get(params: HTTPHeaders)
}
