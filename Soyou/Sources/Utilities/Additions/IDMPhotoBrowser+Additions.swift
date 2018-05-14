//
//  IDMPhotoBrowser+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 01/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

extension IDMPhotoBrowser {
    
    class func present(_ photos: [IDMPhoto]!, index: UInt!, view: UIView?, scaleImage: UIImage?, viewVC: UIViewController!) {
        let _photoBrowser = (view != nil) ? IDMPhotoBrowser(photos: photos, animatedFrom: view) : IDMPhotoBrowser(photos: photos)
        guard let photoBrowser = _photoBrowser else { return }
        if scaleImage != nil {
            photoBrowser.scaleImage = scaleImage
        }
        photoBrowser.displayToolbar = true
        photoBrowser.displayActionButton = false
        photoBrowser.displayArrowButton = false
        photoBrowser.displayCounterLabel = true
        photoBrowser.displayDoneButton = false
        photoBrowser.usePopAnimation = false
        photoBrowser.useWhiteBackgroundColor = false
        photoBrowser.disableVerticalSwipe = false
        photoBrowser.forceHideStatusBar = false
        photoBrowser.dismissOnTouch = true
        photoBrowser.autoHideInterface = false
        
        photoBrowser.setInitialPageIndex(index)
        
        let gesture = UILongPressGestureRecognizer.init(target: photoBrowser, action: #selector(IDMPhotoBrowser.handleLongPressGesture(_:)))
        photoBrowser.view.addGestureRecognizer(gesture)
        
        viewVC.present(photoBrowser, animated: true, completion: nil)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        guard let currentIndex = self.value(forKey: "_currentPageIndex") as? UInt else { return }
        guard let photo = self.photo(at: currentIndex) else { return }
        let codes = photo.underlyingImage()?.detectQRCodes(true)
        var actions = [UIAlertAction]()
        actions.append(UIAlertAction(title: NSLocalizedString("photo_browser_action_save_image"),
                                     style: UIAlertActionStyle.default,
                                     handler: { (action: UIAlertAction) -> Void in
                                        if PicturePickerViewController.isNeedsToShowAuthorizationAlert() {
                                            return
                                        }
                                        MBProgressHUD.show(self.view)
                                        if var image = photo.underlyingImage() {
                                            if image.size.width > 1080 && image.size.height > 1080 {
                                                image = image.resizedImage(byMagick: "1080x1080^")
                                            }
                                            UIImageWriteToSavedPhotosAlbum(image, self, #selector(CirclesTableViewCell.image(_:didFinishSavingWithError:contextInfo:)), nil)
                                        }
        }))
        if codes != nil {
            actions.append(UIAlertAction(title: NSLocalizedString("photo_browser_action_detect_qr_code"),
                                         style: UIAlertActionStyle.default,
                                         handler: { (action: UIAlertAction) -> Void in
                                            Utils.shared.handleScannedQRCode(codes)
            }))
        }
        actions.append(UIAlertAction(title: NSLocalizedString("alert_button_cancel"),
                                     style: UIAlertActionStyle.cancel,
                                     handler: nil))
        UIAlertController.presentActionSheet(from: self, actions: actions)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        MBProgressHUD.hide(self.view)
        if let window = UIApplication.shared.keyWindow  {
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.isUserInteractionEnabled = false
            hud.mode = .text
            hud.label.text = error == nil ? NSLocalizedString("photo_browser_image_saved") : error?.localizedDescription
            hud.hide(animated: true, afterDelay: 1)
        }
    }
}
