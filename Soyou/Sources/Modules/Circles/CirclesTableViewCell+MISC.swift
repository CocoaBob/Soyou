//
//  CirclesTableViewCell+MISC.swift
//  Soyou
//
//  Created by CocoaBob on 2018-03-03.
//  Copyright © 2018 Soyou. All rights reserved.
//

// MARK: - UITextViewDelegate
extension CirclesTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let params = URL.absoluteString.components(separatedBy: "soyou.io/").last?.components(separatedBy: "-"), params.count == 3 else {
            return false
        }
        let userId = Int(params[0])
        guard let username = params[1].base64Decoded(),
            let userProfileUrl = params[2].base64Decoded() else {
                return false
        }
        self.viewUserProfile(with: userId, username: username, profileUrl: userProfileUrl)
        return false
    }
}

// MARK: More/Less control
extension CirclesTableViewCell {
    
    func resetMoreLessControl() {
        self.lblContentHeight.isActive = true
    }
    
    func contentIsMoreThanSixLines() -> Bool {
        let maxHeight = self.lblContent.sizeThatFits(CGSize(width: self.lblContent.bounds.width,
                                                            height: CGFloat.greatestFiniteMagnitude)).height
        return maxHeight > 108 // height for 6 lines
    }
    
    func updateMoreLessControl() {
        if self.contentIsMoreThanSixLines() {
            self.btnMoreLessHeight.constant = 26 // Button height
            self.btnMoreLess.isHidden = false
            let title = self.lblContentHeight.isActive ? "circles_vc_button_more" : "circles_vc_button_less"
            self.btnMoreLess.setTitle(NSLocalizedString(title), for: .normal)
            self.lblContent.bottomInset = 0 // Bottom margin
            self.lblContentHeight.constant = 108 // Height of 6 lines
        } else {
            self.btnMoreLessHeight.constant = 0
            self.btnMoreLess.isHidden = true
            self.lblContent.bottomInset = ((self.circle?.images?.count ?? 0) > 0) ? 8 : 0 // Bottom margin
            self.lblContentHeight.constant = 116 // 108 + 8 bottom margin
        }
    }
    
    @IBAction func toggleMoreLessControl() {
        self.lblContentHeight.isActive = !self.lblContentHeight.isActive
        self.updateMoreLessControl()
        if let tableView = self.parentViewController?.tableView() {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

// MARK: Share original images
extension CirclesTableViewCell: CircleComposeViewControllerDelegate {
    
    func forwardTextAndImages(text: String?, urls: [URL]?) {
        self.textToShare = text
        
        if let urls = urls {
            var imagesToShare = [URL: UIImage]()
            let dispatchGroup = DispatchGroup()
            for imageUrl in urls {
                let cacheKey = SDWebImageManager.shared().cacheKey(for: imageUrl)
                if let image = SDImageCache.shared().imageFromCache(forKey: cacheKey) {
                    imagesToShare[imageUrl] = image
                } else {
                    MBProgressHUD.show(self.parentViewController?.view)
                    dispatchGroup.enter()
                    SDWebImageManager.shared().loadImage(
                        with: imageUrl,
                        options: [.continueInBackground, .allowInvalidSSLCertificates],
                        progress: nil,
                        completed: { (image, data, error, type, finished, url) -> Void in
                            MBProgressHUD.hide(self.parentViewController?.view)
                            if let image = image {
                                imagesToShare[imageUrl] = image
                            }
                            dispatchGroup.leave()
                    })
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                var images = [UIImage]()
                for url in urls {
                    if let image = imagesToShare[url] {
                        images.append(image)
                    }
                }
                self.composeTextAndImages(text: self.textToShare, images: images)
            }
        } else {
            self.composeTextAndImages(text: self.textToShare, images: nil)
        }
    }
    
    func composeTextAndImages(text: String?, images: [UIImage]?) {
        // Prepare TLPHAsset
        var assets: [TLPHAsset]?
        if let images = images {
            assets = [TLPHAsset]()
            for (i, image) in images.enumerated() {
                assets?.append(TLPHAsset(image: image))
                assets?.last?.selectedOrder = i + 1
            }
        }
        // Create CircleComposeViewController
        let vc = CircleComposeViewController.instantiate()
        let nav = UINavigationController(rootViewController: vc)
        // Setup
        vc.delegate = self
        vc.customAssets = assets
        vc.selectedAssets = assets
        vc.content = text
        vc.isSharing = true
        vc.visibility = CircleVisibility.friends
        vc.originalId = self.circle?.id
        // Present
        self.parentViewController?.present(nav, animated: true, completion: nil)
    }
    
    func didPostNewCircle() {
        self.parentViewController?.didPostNewCircle()
    }
    
    func didDismiss(text: String?, images: [UIImage]?, needsToShare: Bool) {
        if needsToShare {
            Utils.copyTextAndShareImages(from: self.parentViewController, text: text, images: images)
            if let id = self.circle?.id {
                DataManager.shared.analyticsShareCircle(id: id)
            } else {
                DLog("Circle ID is nil!")
            }
        }
    }
}
