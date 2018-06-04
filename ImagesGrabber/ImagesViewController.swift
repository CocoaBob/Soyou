//
//  ImagesViewController.swift
//  ImagesGrabber
//
//  Created by CocoaBob on 2018-05-25.
//  Copyright © 2018 Soyou. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class ImagesViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var btnSave: UIBarButtonItem!
    
    var items: [ImageItem]?
    var selectedItems = [ImageItem]()
    
    var swipeSelectionIsAddingSelections = false
    var swipeSelectionFirstIndex = 0
    var swipeSelectionLastIndex = 0
    var selectedItemsBeforeSwipeSelection = [ImageItem]()
    
    var saveCompletion: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("images_vc_title")
        self.navigationItem.prompt = NSLocalizedString("images_vc_desc")
        
        setupSwipeSelection()
        
        // Get data from JavaScript
        guard let inputItems = self.extensionContext?.inputItems as? [NSExtensionItem] else {
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
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCellSize()
    }
}

// MARK: - UI
extension ImagesViewController {
    
    fileprivate func updateCellSize() {
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let minSpacing = CGFloat(1)
        layout.minimumLineSpacing = minSpacing
        layout.minimumInteritemSpacing = minSpacing
        let numberOfColumn = CGFloat(4)
        let width = (self.view.frame.size.width - (minSpacing * (numberOfColumn - 1))) / numberOfColumn
        layout.itemSize = CGSize(width: width, height: width)
        self.collectionView.collectionViewLayout = layout
    }
    
    func updateSelectionStatusForVisibleCells() {
        for visibleIndexPath in collectionView.indexPathsForVisibleItems {
            if let cell = collectionView.cellForItem(at: visibleIndexPath) as? ImageCell {
                cell.updateSelection()
            }
        }
    }
}

// MARK: - Actions
extension ImagesViewController {
    
    func dismiss() {
        if let extensionContext = self.extensionContext {
            extensionContext.completeRequest(returningItems: nil, completionHandler: nil)
        } else {
            if let navC = self.navigationController, navC.viewControllers.count > 1, navC.viewControllers.last == self {
                navC.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel() {
        dismiss()
    }
    
    @IBAction func save() {
        btnCancel.isEnabled = false
        btnSave.isEnabled = false
        self.navigationItem.prompt = NSLocalizedString("images_vc_saving")
        collectionView.isUserInteractionEnabled = false
        saveSelectedImages() {
//            self.btnCancel.isEnabled = true
//            self.btnSave.isEnabled = true
//            self.navigationItem.prompt = NSLocalizedString("images_vc_saved")
//            self.collectionView.isUserInteractionEnabled = true
            self.dismiss()
        }
    }
}
