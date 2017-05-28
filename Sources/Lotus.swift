//
//  Lotus.swift
//  Lotus
//
//  Created by Jack on 4/2/17.
//
//

import Foundation

//MARK: - DataTask

/// Send data task by url
///
/// - Parameter url: URL
/// - Returns: DataClient
public func send(_ url: URL) -> DataClient {
    return Center.default.send(url)
}

/// Send data task by URLRequest
///
/// - Parameter request: URLRequest
/// - Returns: DataClient
public func send(_ request: URLRequest) -> DataClient {
    return Center.default.send(request)
}

//MARK: - DownloadTask

/// Download by url
///
/// - Parameter url: URL
/// - Returns: DownloadClient
public func download(_ url: URL) -> DownloadClient {
    return Center.default.download(url)
}

/// Download by URLRequest
///
/// - Parameter request: URLRequest
/// - Returns: DownloadClient
public func download(_ request: URLRequest) -> DownloadClient {
    return Center.default.download(request)
}
