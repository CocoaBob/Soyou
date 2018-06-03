//
//  ImagesViewController+CollectionView.swift
//  ImagesGrabber
//
//  Created by CocoaBob on 2018-06-01.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Data
extension ImagesViewController {
    
    func setupImages(_ urls: [String]) {
        var items = [ImageItem]()
        for url in urls {
            if let imageURL = URL(string: url) {
                if let imageResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageURL)),
                    let image = UIImage(data: imageResponse.data) {
                    items.append(ImageItem(image: image))
                } else {
                    items.append(ImageItem(url: imageURL))
                }
            }
        }
        imageItems = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func item(at index: Int) -> ImageItem? {
        if index < imageItems?.count ?? 0 {
            return imageItems?[index]
        }
        return nil
    }
}

// MARK: - UICollectionView delegate & datasource
extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // UICollectionViewDelegate
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // UICollectionViewDataSource
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        if let cell = cell as? ImageCell {
            cell.imageItem = item(at: indexPath.item)
        }
        return cell
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageItems?.count ?? 0
    }
}
