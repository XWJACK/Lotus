//
//  LotusError.swift
//  Lotus
//
//  Created by Jack on 14/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation

/// Error for Lotus.
public enum LotusError: Error {
    /// Send request error.
    public enum RequestError: Error {
        /// Invalid base url.
        case invalidBaseURL(urlString: String)
    }
    /// Receive response error.
    public enum ResponseError: Error {
    }
    /// Reading and saving cache error.
    public enum CacheError: Error {
        /// Reading cache from file error.
        case readingCacheError(cachePath: String)
        /// Saving cache to file error.
        case savingCacheError(data: Data, cachePath: String)
    }
    /// Log error.
    public enum LogError: Error {
        /// Recording log error.
        case recordError
    }
    /// System throw error.
    case systemError(Error)
    /// Custom error.
    case customError(Error)
}

// MARK: - LotusError.RequestError LocalizedError

extension LotusError.RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidBaseURL(let urlString): return "Base URL is not valid: " + urlString
        }
    }
}

// MARK: - LotusError.CacheError LocalizedError
extension LotusError.CacheError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .readingCacheError(let cachePath): return "Can't reading cache from: \(cachePath)"
        case .savingCacheError(let data, let cachePath): return "Can't saving cache to: \(cachePath) with data: \(data)"
        }
    }
}
