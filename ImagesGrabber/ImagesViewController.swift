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
    
    var items: [ImageItem]?
    var selectedItems = [ImageItem]()
    
    var swipeSelectionIsAddingSelections = false
    var swipeSelectionFirstIndex = 0
    var swipeSelectionLastIndex = 0
    var selectedItemsBeforeSwipeSelection = [ImageItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwipeSelection()
        
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
    
    func updateVisibleCells() {
        for visibleIndexPath in collectionView.indexPathsForVisibleItems {
            if let cell = collectionView.cellForItem(at: visibleIndexPath) as? ImageCell {
                cell.updateSelection()
            }
        }
    }
}

// MARK: - Actions
extension ImagesViewController {
    
    func done(_ isSuccessful: Bool = false) {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @IBAction func cancel() {
        done()
    }
    
    @IBAction func save() {
        done(true)
    }
}
