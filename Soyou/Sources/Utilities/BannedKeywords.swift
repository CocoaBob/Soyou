//
//  BannedKeywords.swift
//  Soyou
//
//  Created by CocoaBob on 2018-05-09.
//  Copyright © 2018 Soyou. All rights reserved.
//

class BannedKeywords {
    
    private let kBannedKeywords = "kBannedKeywords"
    private let kLastUpdateDate = "kLastUpdateDate"
    
    private lazy var keywords: Set<String> = {
        let storedKeywords = UserDefaults.objectForKey(kBannedKeywords) as? [String]
        if let storedKeywords = storedKeywords {
            return Set(storedKeywords)
        } else {
            return Set<String>()
        }
    }()
    
    private lazy var updateDate: Date = {
        let date = UserDefaults.objectForKey(kLastUpdateDate) as? Date
        if let date = date {
            return date
        } else {
            return Date.distantPast
        }
    }()
    
    static let shared = BannedKeywords()
    static let censoredImage =  UIImage(named: NSLocalizedString("censored_image_name"))!
}

// MARK: - Methods
extension BannedKeywords {
    
    func updateFromServer() {
        // Update time inteval should be larger than 1 day
        if self.updateDate.timeIntervalSinceNow > -86400 {
            return
        }
        DataManager.shared.getBannedKeywords { (response, error) in
            if let response = response,
                let data = DataManager.getResponseData(response) as? [String] {
                self.update(data)
            }
        }
    }
    
    private func update(_ keywords: [String]) {
        self.keywords = self.keywords.union(keywords)
        UserDefaults.setObject(Array(self.keywords), forKey: kBannedKeywords)
        UserDefaults.setObject(Date(), forKey: kLastUpdateDate)
    }
    
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
        return BannedKeywords.shared.test(self)
    }
    
    func censored() -> String {
        if self.containsBannedKeywords() {
            return NSLocalizedString("forbidden_content")
        }
        return self
    }
}

extension UIImage {
    
    func isCensoredQRCode() -> Bool {
        let whitelist = ["soyou.io"]
        if let codes = self.detectQRCodes() {
            for code in codes {
                for link in whitelist {
                    if code.range(of: link) != nil {
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
            return BannedKeywords.censoredImage
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
                                if image?.isCensoredQRCode() == true {
                                    finalImage = BannedKeywords.censoredImage
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
