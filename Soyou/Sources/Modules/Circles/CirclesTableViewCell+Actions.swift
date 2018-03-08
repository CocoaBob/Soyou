//
//  CirclesTableViewCell+Actions.swift
//  Soyou
//
//  Created by CocoaBob on 2018-03-03.
//  Copyright © 2018 Soyou. All rights reserved.
//

// MARK: CirclesTableViewCell Actions
extension CirclesTableViewCell {
    
    @IBAction func delete() {
        guard let circle = self.circle, let circleID = circle.id else {
            return
        }
        guard let vc = self.parentViewController else {
            return
        }
        UIAlertController.presentAlert(from: vc,
                                       message: NSLocalizedString("circles_vc_delete_alert"),
                                       UIAlertAction(title: NSLocalizedString("alert_button_delete"),
                                                     style: UIAlertActionStyle.default,
                                                     handler: { (action: UIAlertAction) -> Void in
                                                        MBProgressHUD.show(vc.view)
                                                        DataManager.shared.deleteCircle(circleID) { responseObject, error in
                                                            circle.delete({
                                                                MBProgressHUD.hide(vc.view)
                                                            })
                                                        }
                                       }),
                                       UIAlertAction(title: NSLocalizedString("alert_button_cancel"),
                                                     style: UIAlertActionStyle.default,
                                                     handler: nil))
    }
    
    @IBAction func like() {
        guard let circleId = self.circle?.id else {
            return
        }
        DataManager.shared.likeCircle(circleId, wasLiked: self.isLiked) { (response, error) in
            if let response = response,
                let data = DataManager.getResponseData(response) as? NSArray {
                self.circle?.likes = data
                self.configureLikes(data)
                UIView.setAnimationsEnabled(false)
                self.parentViewController?.tableView().beginUpdates()
                self.parentViewController?.tableView().endUpdates()
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    
    @IBAction func save() {
        guard let imgURLs = self.imgURLs else { return }
        UIAlertController.presentAlert(from: self.parentViewController,
                                       message: NSLocalizedString("circles_vc_save_alert"),
                                       UIAlertAction(title: NSLocalizedString("alert_button_save"),
                                                     style: UIAlertActionStyle.default,
                                                     handler: { (action: UIAlertAction) -> Void in
                                                        var urls = [URL]()
                                                        for dict in imgURLs {
                                                            if let str = dict["original"], let url = URL(string: str) {
                                                                urls.append(url)
                                                            }
                                                        }
                                                        self.getAllImages(urls: urls) { images in
                                                            if images?.count ?? 0 > 0 {
                                                                MBProgressHUD.show(self.parentViewController?.view)
                                                            }
                                                            self.imagesToSave = images
                                                            self.imagesCountToSave = images?.count ?? 0
                                                            self.saveNextImage()
                                                        }
                                       }),
                                       UIAlertAction(title: NSLocalizedString("alert_button_cancel"),
                                                     style: UIAlertActionStyle.cancel,
                                                     handler: nil))
    }
    
    func saveNextImage() {
        if let image = self.imagesToSave?.first {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(CirclesTableViewCell.image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            MBProgressHUD.hide(self.parentViewController?.view)
            if let window = UIApplication.shared.keyWindow  {
                let hud = MBProgressHUD.showAdded(to: window, animated: true)
                hud.isUserInteractionEnabled = false
                hud.mode = .text
                hud.label.text = FmtString(NSLocalizedString("circles_vc_save_completed"), self.imagesCountToSave)
                hud.hide(animated: true, afterDelay: 1)
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let index = self.imagesToSave?.index(of: image) {
            self.imagesToSave?.remove(at: index)
        }
        self.saveNextImage()
    }
    
    @IBAction func share() {
        guard let circle = self.circle else {
            return
        }
        if let imgURLs = self.imgURLs {
            var urls = [URL]()
            for dict in imgURLs {
                if let str = dict["original"], let url = URL(string: str) {
                    urls.append(url)
                }
            }
            self.forwardTextAndImages(text: circle.text, urls: urls)
        } else {
            self.forwardTextAndImages(text: circle.text, urls: nil)
        }
    }
    
    func browseImages(_ view: UIView, _ index: UInt) {
        guard let imgURLs = self.imgURLs else {
            return
        }
        var scaleImage: UIImage?
        var photos = [IDMPhoto]()
        for (i, dict) in imgURLs.enumerated() {
            if let originalStr = dict["original"], let originalURL = URL(string: originalStr),
                let thumbnailStr = dict["thumbnail"], let thumbnailURL = URL(string: thumbnailStr) {
                var photo: IDMPhoto?
                if let cachedOriginalImage = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: originalURL)) {
                    photo = IDMPhoto(image: cachedOriginalImage)
                    if i == index {
                        scaleImage = cachedOriginalImage
                    }
                } else {
                    photo = IDMPhoto(url: originalURL)
                }
                if let cachedThumbnailImage = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: thumbnailURL)) {
                    photo?.placeholderImage = cachedThumbnailImage
                    if i == index, scaleImage == nil {
                        scaleImage = cachedThumbnailImage
                    }
                }
                if let photo = photo {
                    photos.append(photo)
                }
            }
        }
        IDMPhotoBrowser.present(photos, index: index, view: view, scaleImage: scaleImage, viewVC: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    @IBAction func viewUserProfile() {
        self.viewUserProfile(with: self.circle?.userId as? Int, username: self.circle?.username, profileUrl: self.circle?.userProfileUrl)
    }
    
    func viewUserProfile(with userId: Int?, username: String?, profileUrl: String?) {
        guard let vc = self.parentViewController else { return }
        var isDifferentUser = true
        if let nextID = userId, let currID = vc.userID, currID == nextID {
            isDifferentUser = false
        }
        if isDifferentUser {
            CirclesViewController.pushNewInstance(userId, profileUrl, username, from: vc.navigationController)
        }
    }
}
