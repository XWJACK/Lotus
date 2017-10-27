//
//  CommonCrypto.swift
//  Lotus
//
//  Created by Jack on 27/10/2017.
//  Copyright © 2017 XWJACK. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    /// MD5
    ///
    /// For more information about import C library into Framework:
    /// http://xwjack.github.io/2017/02/13/Add-Standard-C-File-into-Swift-Framework.html
    /// http://stackoverflow.com/questions/25248598/importing-commoncrypto-in-a-swift-framework/37125785#37125785
    /// https://github.com/onmyway133/Arcane
    ///
    /// For more information about custom in swift:
    /// https://github.com/krzyzanowskim/CryptoSwift
    ///
    /// - returns: nil if encoding is not utf8 encoding.
    public func md5() -> String? {
        guard let messageData = self.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
