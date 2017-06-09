# Lotus

![Xcode 8.3+](https://img.shields.io/badge/Xcode-8.3%2B-blue.svg)
![iOS 8.0+](https://img.shields.io/badge/iOS-8.0%2B-blue.svg)
![macOS 10.10+](https://img.shields.io/badge/macOS-10.9%2B-blue.svg)
![Swift 3.1+](https://img.shields.io/badge/Swift-3.0%2B-orange.svg)
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)
![pod](https://img.shields.io/badge/pod-v0.1.0-brightgreen.svg)

## Overview

Simple way to access network

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects.

Specify Lotus into your project's Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!

target '<Your App Target>' do
  pod 'Lotus', :git => 'git@github.com:XWJACK/Lotus.git'
end
```

Then run the following command:

```sh
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized
dependency manager for Cocoa.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Lotus into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "XWJACK/Lotus" ~> 0.1.0
```

Run `carthage update` to build the framework and drag the built `Lotus.framework` into your Xcode project.

## Usage

### Make a request

```swift
import Lotus

let url = URL(string: "https://httpbin.org/get")
Lotus.send(url)
```

### Receive Response

```swift
Lotus.send(url)
     .receive(queue: .global(), data: { (data) in
          /// Receive data or part of data
     })
     .receive(queue: .global(), success: { (data) in
          /// Receive all data
     })
     .receive(queue: .global(), failed: { (error) in
         /// Error
     })
```

### Easy extension with SwiftyJSON

```swift
/// Extension with json decoding
extension Client {
    @discardableResult
    func receive(queue: DispatchQueue = .main, json block: ((JSON) -> ())? = nil) -> Self {
        return receive(queue: queue, success: { block?(JSON(data: $0)) })
    }
}
```

