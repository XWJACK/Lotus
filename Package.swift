//
//  Package.swift
//  PageKit
//
//  Created by Jack on 4/28/17.
//
//

import PackageDescription

let package = Package(
    name: "Lotus",
    dependencies : [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", versions: Version(4, 0, 0)..<Version(5, 0, 0)),
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON", versions: Version(3, 0, 0)..<Version(4, 0, 0))
    ],
    exclude: ["Demo", "Tests"]
)
