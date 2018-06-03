//
//  ImagesViewController+Selections.swift
//  ImagesGrabber
//
//  Created by CocoaBob on 2018-06-03.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Selections
extension ImagesViewController {

//    fileprivate func orderUpdateCells() {
//        let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems.sorted(by: { $0.row < $1.row })
//        for indexPath in visibleIndexPaths {
//            guard let cell = self.collectionView.cellForItem(at: indexPath) as? TLPhotoCollectionViewCell else { continue }
//            guard let asset = self.focusedCollection?.getTLAsset(at: indexPath.row) else { continue }
//            if let selectedAsset = getSelectedAssets(asset) {
//                cell.selectedAsset = true
//                cell.orderLabel?.text = "\(selectedAsset.selectedOrder)"
//            } else {
//                cell.selectedAsset = false
//            }
//        }
//    }
//
//    fileprivate func selectIndexPath(_ indexPath: IndexPath, asset: TLPHAsset) {
//        guard !self.selectedAssets.contains(asset) else { return }
//        guard !maxCheck() else { return }
//        asset.selectedOrder = self.selectedAssets.count + 1
//        self.selectedAssets.append(asset)
//        if self.collectionView.indexPathsForVisibleItems.contains(indexPath),
//            let cell = self.collectionView.cellForItem(at: indexPath) as? TLPhotoCollectionViewCell {
//            cell.selectedAsset = true
//            cell.orderLabel?.text = "\(asset.selectedOrder)"
//        }
//        //requestCloudDownload(asset: asset, indexPath: indexPath)
//        if asset.type != .photo, self.configure.autoPlay {
//            playVideo(asset: asset, indexPath: indexPath)
//        }
//    }
//
//    fileprivate func deselectIndexPath(_ indexPath: IndexPath, asset: TLPHAsset) {
//        guard let removeIndex = self.selectedAssets.index(where: { $0 == asset }) else {
//            return
//        }
//        self.selectedAssets.remove(at: removeIndex)
//        self.selectedAssets = self.selectedAssets.enumerated().flatMap({ (offset,asset) -> TLPHAsset? in
//            asset.selectedOrder = offset + 1
//            return asset
//        })
//        if self.collectionView.indexPathsForVisibleItems.contains(indexPath),
//            let cell = self.collectionView.cellForItem(at: indexPath) as? TLPhotoCollectionViewCell {
//            cell.selectedAsset = false
//            self.orderUpdateCells()
//        }
//        //cancelCloudRequest(indexPath: indexPath)
//        if self.playRequestId?.indexPath == indexPath {
//            stopPlay()
//        }
//    }
}
