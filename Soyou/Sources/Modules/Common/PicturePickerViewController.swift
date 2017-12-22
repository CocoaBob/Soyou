//
//  PicPickerViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2017-12-20.
//  Copyright © 2017 Soyou. All rights reserved.
//

class PicturePickerViewController: TLPhotosPickerViewController {
    
    static func present(from viewController: UIViewController,
                        assets: [TLPHAsset],
                        delegate: TLPhotosPickerViewControllerDelegate) {
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
        configure.numberOfColumn = 3
        configure.singleSelectedMode = false
        configure.maxSelectedAssets = 9
        configure.fetchOption = nil
//        configure.selectedColor = UIColor.clear
        configure.placeholderIcon = UIImage(named: "img_placeholder_1_1_m")
        configure.nibSet = (nibName: "PicturePickerCell", bundle: Bundle.main)
        
        let collection = TLAssetsCollection(assets: assets, title: NSLocalizedString("photo_picker_default_title"))
        
        let vc = PicturePickerViewController(with: collection)
        vc.configure = configure
        vc.delegate = delegate
        
        viewController.present(vc, animated: true, completion: nil)
        vc.focusCollection(collection: collection)
    }
}

