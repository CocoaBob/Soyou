//
//  ImagesViewController+Save.swift
//  ImagesGrabber
//
//  Created by CocoaBob on 2018-06-03.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import UIKit

extension ImagesViewController {
    
    func saveSelectedImages(_ completion: (()->())?) {
        saveCompletion = completion
        saveNextImage()
    }
    
    fileprivate func saveNextImage() {
        if self.selectedItems.isEmpty {
            saveCompletion?()
            saveCompletion = nil
        } else {
            let item = self.selectedItems.first
            if let image = item?.image {
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               #selector(ImagesViewController.image(_:didFinishSavingWithError:contextInfo:)),
                                               nil)
            } else {
                self.selectedItems.remove(at: 0)
                saveNextImage()
            }
        }
    }
    
    @objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        self.selectedItems.remove(at: 0)
        saveNextImage()
    }
}
