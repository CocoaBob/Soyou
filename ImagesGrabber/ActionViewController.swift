//
//  ActionViewController.swift
//  ImagesGrabber
//
//  Created by CocoaBob on 2018-05-25.
//  Copyright © 2018 Soyou. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

import TLPhotoPicker

class ActionViewController: TLPhotosPickerViewController {
    
    override func viewDidLoad() {
        setupConfigure()
        
        super.viewDidLoad()
        
        // Get data from JavaScript
        guard let inputItems = self.extensionContext?.inputItems as? [NSExtensionItem] else {
            done()
            return
        }
        for inputItem in inputItems {
            guard let attachments = inputItem.attachments else { return }
            for attachment in attachments {
                guard let itemProvider = attachment as? NSItemProvider else { return }
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String, options: nil) { (item, error) in
                        if let dictionary = item as? Dictionary<String, Any>,
                            let jsData = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                            let imgUrls = jsData["imgs"] as? [String] {
                            self.setupImages(imgUrls)
                        }
                    }
                }
            }
        }
    }
}

extension ActionViewController: TLPhotosPickerViewControllerDelegate {
    
    func setupConfigure() {
        var configure = TLPhotosPickerConfigure()
        configure.defaultCameraRollTitle = NSLocalizedString("photo_picker_default_title")
        configure.tapHereToChange = NSLocalizedString("photo_picker_tap_to_change")
        configure.cancelTitle = NSLocalizedString("photo_picker_cancel")
        configure.doneTitle = NSLocalizedString("photo_picker_save")
        configure.usedCameraButton = false
        configure.usedPrefetch = false
        configure.allowedLivePhotos = false
        configure.allowedVideo = false
        configure.allowedVideoRecording = false
        configure.numberOfColumn = 4
        configure.singleSelectedMode = false
//        configure.maxSelectedAssets = 9
        configure.fetchOption = nil
        configure.placeholderIcon = UIImage(named: "img_placeholder_1_1_s")
        configure.nibSet = (nibName: "PicturePickerCell", bundle: Bundle.main)
        self.configure = configure
    }
    
    func setupImages(_ urls: [String]) {
        var assets = [TLPHAsset]()
        for url in urls {
            if let imageURL = URL(string: url) {
                if let imageResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageURL)),
                    let image = UIImage(data: imageResponse.data) {
                    assets.append(TLPHAsset(image: image))
                } else {
                    assets.append(TLPHAsset(url: imageURL))
                }
            }
        }
        
        if assets.isEmpty {
            done()
            return
        }
        
        self.customCollection = TLAssetsCollection(assets: assets, title: NSLocalizedString("photo_picker_default_title"))
        self.customNavigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.done))
    }
    
    func didDismissPhotoPicker(with tlphAssets: [TLPHAsset]) {
        print(tlphAssets)
    }
}

extension ActionViewController {
    
    @IBAction func done(_ isSuccessful: Bool = false) {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

extension ActionViewController {
    
    @IBAction override func cancelButtonTap() {
        super.cancelButtonTap()
        done()
    }
    
    @IBAction override func doneButtonTap() {
        super.doneButtonTap()
        done(true)
    }
}
