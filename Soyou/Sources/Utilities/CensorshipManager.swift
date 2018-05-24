//
//  CensorshipManager.swift
//  Soyou
//
//  Created by CocoaBob on 2018-05-09.
//  Copyright © 2018 Soyou. All rights reserved.
//

class CensorshipManager {
    
    private let kBannedKeywords = "kBannedKeywords"
    private let kAllowedDomains = "kAllowedDomains"
    
    private lazy var bannedKeywords: Set<String> = {
        let storedData = UserDefaults.objectForKey(kBannedKeywords) as? [String]
        if let storedData = storedData {
            return Set(storedData)
        } else {
            return Set<String>()
        }
    }()
    
    fileprivate lazy var allowedDomains: Set<String> = {
        let storedData = UserDefaults.objectForKey(kAllowedDomains) as? [String]
        if let storedData = storedData {
            return Set(storedData)
        } else {
            return Set<String>()
        }
    }()
    
    static let shared = CensorshipManager()
    static let censoredImage =  UIImage(named: NSLocalizedString("censored_image_name"))!
}

// MARK: - Methods
extension CensorshipManager {
    
    func updateFromServer() {
        DataManager.shared.getCheckList { (responseObject, error) in
            if let responseObject = responseObject,
                let data = DataManager.getResponseData(responseObject) as? [String: Any] {
                if let values = data["bannedKeywords"] as? [String] {
                    self.updateBannedKeywords(values.map { $0.lowercased() })
                }
                if let values = data["allowedDomains"] as? [String] {
                    self.updateAllowedDomains(values.map { $0.lowercased() })
                }
            }
        }
    }
    
    private func updateBannedKeywords(_ values: [String]) {
        self.bannedKeywords = self.bannedKeywords.union(values)
        UserDefaults.setObject(Array(self.bannedKeywords), forKey: kBannedKeywords)
    }
    
    private func updateAllowedDomains(_ values: [String]) {
        self.allowedDomains = self.allowedDomains.union(values)
        UserDefaults.setObject(Array(self.allowedDomains), forKey: kAllowedDomains)
    }
    
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
            UIAlertController.presentAlert(message: NSLocalizedString("forbidden_content_alert"),
                                           UIAlertAction(title: NSLocalizedString("alert_button_ok"),
                                                         style: UIAlertActionStyle.default,
                                                         handler: nil))
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
            return NSLocalizedString("forbidden_content")
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
