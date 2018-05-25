//
//  PicPickerViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2017-12-20.
//  Copyright © 2017 Soyou. All rights reserved.
//

class PicturePickerViewController: TLPhotosPickerViewController {
    
    static func share9Photos(from fromVC: UIViewController,
                             customAssets: [TLPHAsset],
                             delegate: TLPhotosPickerViewControllerDelegate) {
        self.askForPermissionOrDo() {
            var configure = TLPhotosPickerConfigure()
            configure.defaultCameraRollTitle = NSLocalizedString("photo_picker_default_title")
            configure.tapHereToChange = NSLocalizedString("photo_picker_tap_to_change")
            configure.cancelTitle = NSLocalizedString("photo_picker_cancel")
            configure.doneTitle = NSLocalizedString("photo_picker_share")
            configure.usedCameraButton = false
            configure.usedPrefetch = false
            configure.allowedLivePhotos = false
            configure.allowedVideo = false
            configure.allowedVideoRecording = false
            configure.numberOfColumn = 4
            configure.singleSelectedMode = false
            configure.maxSelectedAssets = 9
            configure.fetchOption = nil
            configure.placeholderIcon = UIImage(named: "img_placeholder_1_1_s")
            configure.nibSet = (nibName: "PicturePickerCell", bundle: Bundle.main)
            
            let collection = TLAssetsCollection(assets: customAssets, title: NSLocalizedString("photo_picker_default_title"))
            
            let vc = PicturePickerViewController(with: collection)
            vc.configure = configure
            vc.delegate = delegate
            
            fromVC.present(vc, animated: true, completion: nil)
        }
    }
    
    static func pickOnePhoto(from fromVC: UIViewController,
                             delegate: TLPhotosPickerViewControllerDelegate) {
        self.askForPermissionOrDo() {
            var configure = TLPhotosPickerConfigure()
            configure.defaultCameraRollTitle = NSLocalizedString("photo_picker_default_title")
            configure.tapHereToChange = NSLocalizedString("photo_picker_tap_to_change")
            configure.cancelTitle = NSLocalizedString("photo_picker_cancel")
            configure.doneTitle = NSLocalizedString("photo_picker_confirm")
            configure.usedCameraButton = true
            configure.usedPrefetch = false
            configure.allowedLivePhotos = false
            configure.allowedVideo = false
            configure.allowedVideoRecording = false
            configure.numberOfColumn = 4
            configure.singleSelectedMode = true
            configure.maxSelectedAssets = 1
            configure.fetchOption = nil
            configure.placeholderIcon = UIImage(named: "img_placeholder_1_1_s")
            configure.nibSet = (nibName: "PicturePickerCell2", bundle: Bundle.main)
            
            let vc = PicturePickerViewController()
            vc.configure = configure
            vc.delegate = delegate
            
            fromVC.present(vc, animated: true, completion: nil)
        }
    }
    
    static func pick9Photos(from fromVC: UIViewController,
                            customAssets: [TLPHAsset]?,
                            selectedAssets: [TLPHAsset]?,
                            maxSelection: Int,
                            delegate: TLPhotosPickerViewControllerDelegate) {
        self.askForPermissionOrDo() {
            var configure = TLPhotosPickerConfigure()
            configure.defaultCameraRollTitle = NSLocalizedString("photo_picker_default_title")
            configure.tapHereToChange = NSLocalizedString("photo_picker_tap_to_change")
            configure.cancelTitle = NSLocalizedString("photo_picker_cancel")
            configure.doneTitle = NSLocalizedString("photo_picker_confirm")
            configure.usedCameraButton = true
            configure.usedPrefetch = false
            configure.allowedLivePhotos = false
            configure.allowedVideo = false
            configure.allowedVideoRecording = false
            configure.numberOfColumn = 4
            configure.itemMinSpacing = 1
            configure.singleSelectedMode = maxSelection == 1
            configure.maxSelectedAssets = maxSelection
            configure.fetchOption = nil
            configure.placeholderIcon = UIImage(named: "img_placeholder_1_1_s")
            configure.nibSet = (nibName: "PicturePickerCell", bundle: Bundle.main)
            
            var collection: TLAssetsCollection?
            if let customAssets = customAssets {
                collection = TLAssetsCollection(assets: customAssets, title: NSLocalizedString("photo_picker_default_title"))
            }
            
            let vc = PicturePickerViewController(with: collection)
            vc.configure = configure
            vc.delegate = delegate
            if let selectedAssets = selectedAssets {
                vc.selectedAssets.append(contentsOf: selectedAssets)
            }
            
            fromVC.present(vc, animated: true, completion: nil)
        }
    }
    
    static func askForPermissionOrDo(_ completion: (()->())?) {
        func showNoPersmissionAlert() {
            UIAlertController.presentAlert(from: nil,
                                           title: NSLocalizedString("photo_picker_photo_library_unavailable_title"),
                                           message: NSLocalizedString("photo_picker_photo_library_unavailable_content"),
                                           UIAlertAction(title: NSLocalizedString("photo_picker_settings"),
                                                         style: UIAlertActionStyle.default,
                                                         handler: { (action: UIAlertAction) -> Void in
                                                            if let url = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                            }
                                           }),
                                           UIAlertAction(title: NSLocalizedString("alert_button_close"),
                                                         style: UIAlertActionStyle.cancel,
                                                         handler: nil))
        }
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .restricted || status == .denied {
            showNoPersmissionAlert()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    completion?()
                } else {
                    showNoPersmissionAlert()
                }
            })
        } else {
            completion?()
        }
    }
}

