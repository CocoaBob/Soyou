//
//  CensorshipManager.swift
//  Soyou
//
//  Created by CocoaBob on 2018-05-09.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class CensorshipManager {
    
    private let kBannedKeywords = "kBannedKeywords"
    private let kAllowedDomains = "kAllowedDomains"
    private let kLastUpdateDate = "kLastUpdateDate"
    
    private lazy var bannedKeywords: Set<String> = {
        let storedKeywords = UserDefaults.standard.object(forKey: kBannedKeywords) as? [String]
        if let storedKeywords = storedKeywords {
            return Set(storedKeywords)
        } else {
            return Set<String>()
        }
    }()
    
    fileprivate lazy var allowedDomains: Set<String> = {
        let storedData = UserDefaults.standard.object(forKey: kAllowedDomains) as? [String]
        if let storedData = storedData {
            return Set(storedData)
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
    
    static let shared = CensorshipManager()
    static let censoredImage = UIImage(namedInBundle: localized("censored_image_name"))!
}

// MARK: - Methods
extension CensorshipManager {
    
    fileprivate func testBannedWord(_ string: String?) -> Bool {
        guard !self.bannedKeywords.isEmpty else { return false }
        guard var string = string else { return false }
        string = String(String.UnicodeScalarView(string.unicodeScalars.filter({ CharacterSet.letters.contains($0) })))
        string = string.lowercased()
        for keyword in self.bannedKeywords {
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
        return CensorshipManager.shared.testBannedWord(self)
    }
    
    func isInWhiteList() -> Bool {
        let whitelist = CensorshipManager.shared.allowedDomains
        for link in whitelist {
            if self.contains(link.lowercased()) {
                return true
            }
        }
        return false
    }
    
    func censored() -> String {
        if self.containsBannedKeywords() {
            return localized("forbidden_content")
        }
        return self
    }
}

extension UIImage {
    
    static let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: CIContext(), options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
    
    func detectQRCodes(_ onlyWhiteListItems: Bool = false) -> [String]? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let whitelist = CensorshipManager.shared.allowedDomains
        var codes = [String]()
        if let features = UIImage.qrDetector?.features(in: ciImage) as? [CIQRCodeFeature] {
            for feature in features  {
                if let code = feature.messageString {
                    if onlyWhiteListItems {
                        var isAllowed = false
                        for link in whitelist {
                            if code.contains(link.lowercased()) {
                                isAllowed = true
                                break
                            }
                        }
                        if isAllowed {
                            codes.append(code)
                        }
                    } else {
                        codes.append(code)
                    }
                }
            }
        }
        
        return codes.isEmpty ? nil : codes
    }
    
    func isCensoredQRCode() -> Bool {
        let whitelist = CensorshipManager.shared.allowedDomains
        if let codes = self.detectQRCodes() {
            for code in codes {
                for link in whitelist {
                    if code.contains(link.lowercased()) {
                        return false
                    }
                }
            }
            return true // All QR Code are banned
        }
        return false
    }
    
    func censored() -> UIImage {
        if self.isCensoredQRCode() {
            return CensorshipManager.censoredImage
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
//                            DispatchQueue.global(qos: .default).async {
                                if image?.isCensoredQRCode() == true {
                                    finalImage = CensorshipManager.censoredImage
                                    SDImageCache.shared().store(finalImage,
                                                                forKey: SDWebImageManager.shared().cacheKey(for: url),
                                                                completion: nil)
                                }
//                                DispatchQueue.main.async {
                                    self.image = finalImage
                                    completedBlock?(finalImage, error, cacheType, url)
//                                }
//                            }
        }
    }
}

