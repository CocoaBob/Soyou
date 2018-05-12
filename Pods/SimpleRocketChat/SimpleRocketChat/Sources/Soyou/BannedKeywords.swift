//
//  BannedKeywords.swift
//  Soyou
//
//  Created by CocoaBob on 2018-05-09.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class BannedKeywords {
    
    private let kBannedKeywords = "kBannedKeywords"
    private let kLastUpdateDate = "kLastUpdateDate"
    
    private lazy var keywords: Set<String> = {
        let storedKeywords = UserDefaults.standard.object(forKey: kBannedKeywords) as? [String]
        if let storedKeywords = storedKeywords {
            return Set(storedKeywords)
        } else {
            return Set<String>()
        }
    }()
    
    private lazy var updateDate: Date = {
        let date = UserDefaults.standard.object(forKey: kLastUpdateDate) as? Date
        if let date = date {
            return date
        } else {
            return Date.distantPast
        }
    }()
    
    static let shared = BannedKeywords()
    static let replacedImage = UIImage(namedInBundle: "SoyouImagePlaceholder2")!
}

// MARK: - Methods
extension BannedKeywords {
    
    fileprivate func test(_ string: String?) -> Bool {
        guard !self.keywords.isEmpty else { return false }
        guard var string = string else { return false }
        string = String(String.UnicodeScalarView(string.unicodeScalars.filter({ CharacterSet.letters.contains($0) })))
        for keyword in self.keywords {
            if string.contains(keyword) {
                return true
            }
        }
        return false
    }
    
    static func censorThenDo(_ content: String?, _ completion: (()->())?) {
        if content?.containsBannedKeywords() ?? false {
            let alertController = UIAlertController(title: nil, message: localized("forbidden_content_alert"), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: localized("alert_button_ok"),
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))
            var presentingVC = UIApplication.shared.keyWindow?.rootViewController
            if let presentedVC = presentingVC?.presentedViewController {
                presentingVC = presentedVC
            }
            presentingVC?.present(alertController, animated: true, completion: nil)
        } else {
            completion?()
        }
    }
}

// MARK: - Helper
extension String {
    
    fileprivate func containsBannedKeywords() -> Bool {
        if self.isEmpty {
            return false
        }
        return BannedKeywords.shared.test(self)
    }
    
    func censored() -> String {
        if self.containsBannedKeywords() {
            return localized("forbidden_content")
        }
        return self
    }
}

extension UIImage {
    
    func detectQRCode() -> String? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let context = CIContext()
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: nil)
        if let features = detector?.features(in: ciImage) as? [CIQRCodeFeature] {
            for feature in features  {
                if let decodedString = feature.messageString {
                    return decodedString
                }
            }
        }
        return nil
    }
    
    func containsNonSoyouLink() -> Bool {
        if let content = self.detectQRCode(), // If it's QR code
            content.range(of: "soyou.io") == nil { // But its content isn't soyou.io
            return true
        }
        return false
    }
    
    func censored() -> UIImage {
        if self.containsNonSoyouLink() {
            return BannedKeywords.replacedImage
        } else {
            return self
        }
    }
}

extension UIImageView {
    
    func setImageWithCensorship(with url: URL?,
                                placeholderImage placeholder: UIImage? = nil,
                                options: SDWebImageOptions = [],
                                progress progressBlock: SDWebImage.SDWebImageDownloaderProgressBlock? = nil,
                                completed completedBlock: SDWebImage.SDExternalCompletionBlock? = nil) {
        var newOptions = options
        newOptions.insert(.avoidAutoSetImage)
        self.sd_setImage(with: url,
                         placeholderImage: placeholder,
                         options: newOptions,
                         progress: progressBlock) { (image, error, cacheType, url) in
                            var finalImage = image
                            DispatchQueue.global(qos: .default).async {
                                if image?.containsNonSoyouLink() == true {
                                    finalImage = BannedKeywords.replacedImage
                                    SDImageCache.shared().store(finalImage,
                                                                forKey: SDWebImageManager.shared().cacheKey(for: url),
                                                                completion: nil)
                                }
                                DispatchQueue.main.async {
                                    self.image = finalImage
                                    completedBlock?(finalImage, error, cacheType, url)
                                }
                            }
        }
    }
}

