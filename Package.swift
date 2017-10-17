//
//  Package.swift
//  Lotus
//
//  Created by Jack on 14/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "Lotus",
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", versions: Version(4, 5, 0)..<Version(5, 0, 0))
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON", versions: Version(3, 1, 0)..<Version(4, 0, 0))
    ],
    exclude: ["Diagram", "Tests"]
)
