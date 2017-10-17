//
//  CacheCenter.swift
//  Lotus
//
//  Created by Jack on 16/08/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation

/// Cache center to cache api data to file.
open class CacheCenter {
    
    /// Default cache center with default cache floader.
    public static let `default` = CacheCenter()
    /// Cache file url.
    public final let cachesURL: URL
    /// Configuration for cache center.
    public final weak var configuration: CenterConfiguration? = nil
    ///Log center
    public var logCenter: LogCenter? { return configuration?.logCenter }
    /// Cache serial queue.
    private final let cacheQueue: DispatchQueue = DispatchQueue(label: "com.lotus.cache.serial")
    
    /// Initlization
    ///
    /// - Parameter cacheFolder: Cache folder name, default is **"com.gouhuoapp.api.cache"**
    public init(cacheFolder: String = "com.gouhuoapp.api.cache") {
        cachesURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(cacheFolder)
        
        createCacheDirectory()
    }
    
    /// Saving cache to file, sub class can override to custom modify cache data.
    ///
    /// - Parameters:
    ///   - data: Raw data will been saved.
    ///   - key: The raw key to uniquely the cache, default is request url.
    /// - Returns: Custom modify cache data, default do nothing.
    open func save(rawData data: Data?, withRawKey key: String) -> Data? {
        return data
    }
    
    /// Reading cache from file, sub class can override to custom modify cache data.
    ///
    /// - Parameters:
    ///   - data: Raw data will been readed.
    ///   - key: The raw key to uniquely the cache, defualt is request url.
    /// - Returns: Custom modify cache data, default is do nothing.
    open func read(rawData data: Data?, withRawKey key: String) -> Data? {
        return data
    }
    
    /// Saving and recording cache by raw key.
    ///
    /// - Parameter key: The raw key to uniquely the cache, defualt is request url.
    /// - Returns: Custom modify the key, the best is make **md5**.
    open func cache(byRawKey key: String) -> String {
        return key
    }
    
    /// Clear cache.
    ///
    /// - Parameter completed: Call back when it completed.
    final public func clear(completed: ((Bool) -> ())? = nil) {
        cacheQueue.async {
            do {
                try FileManager.default.removeItem(at: self.cachesURL)
                self.logCenter?.record("Clear cache completed")
                self.createCacheDirectory()
                completed?(true)
            } catch {
                self.logCenter?.record(error)
                completed?(false)
            }
        }
    }
    
    /// Saving cache to file.
    ///
    /// - Parameters:
    ///   - data: The data need to been cached.
    ///   - key: The raw key to uniquely the cache, defualt is request url.
    final func save(data: Data?, withKey key: String) {
        cacheQueue.async {
            let cachePath = self.cachesURL.appendingPathComponent(self.cache(byRawKey: key)).path
            guard let data = self.save(rawData: data, withRawKey: key) else { return }
            if !NSKeyedArchiver.archiveRootObject(data, toFile: cachePath) {
                self.logCenter?.record(LotusError.CacheError.savingCacheError(data: data, cachePath: cachePath))
            }
            self.logCenter?.record("Saving \(data) to cache with origin key: " + key)
        }
    }
    
    /// Reading cache from file.
    ///
    /// - Parameters:
    ///   - key: The raw key to uniquely the cache, defualt is request url.
    ///   - block: Completed call back if success.
    final func read(dataByKey key: String, completed block: @escaping (Data) -> ()) {
        cacheQueue.async {
            let cachePath = self.cachesURL.appendingPathComponent(self.cache(byRawKey: key)).path
            let data = NSKeyedUnarchiver.unarchiveObject(withFile: cachePath) as? Data
            
            if let cacheData = self.read(rawData: data, withRawKey: key) {
                self.logCenter?.record("Reading \(cacheData) from cache with origin key: " + key)
                block(cacheData)
            } else if FileManager.default.fileExists(atPath: cachePath) {
                /// Reading cache error.
                self.logCenter?.record(LotusError.CacheError.readingCacheError(cachePath: cachePath))
            }
        }
    }
    
    /// Creating cache directory if not exist.
    private func createCacheDirectory() {
        if !FileManager.default.fileExists(atPath: cachesURL.path) {
            do {
                try FileManager.default.createDirectory(at: cachesURL, withIntermediateDirectories: true, attributes: nil)
                logCenter?.record("Create cache folder into path: \(cachesURL.absoluteString)")
            } catch {
                logCenter?.record(error)
            }
        }
    }
}
