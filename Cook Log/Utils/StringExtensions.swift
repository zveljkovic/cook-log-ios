import Security
import SwiftUI
import UIKit
import Foundation
import CryptoKit
import CommonCrypto

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    var notEmpty: Bool {
        get { return !self.isEmpty }
    }
    
    static func randomNoonce(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    @available(iOS 13, *)
    func sha256() -> String {
      let inputData = Data(self.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    func widthOfString(usingFont font: Font) -> CGFloat {
        let attributedString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
        let line = CTLineCreateWithAttributedString(attributedString)
        let lineBounds = CTLineGetBoundsWithOptions(line, .useGlyphPathBounds)
        return CGFloat(lineBounds.width)
        
//        let fontAttributes = [NSAttributedString.Key.font: font]
//        let size = self.size(withAttributes: fontAttributes)
//        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
