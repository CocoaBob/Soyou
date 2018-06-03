//
//  ImagesViewController+Selections.swift
//  ImagesGrabber
//
//  Created by CocoaBob on 2018-06-03.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

// MARK: - Selections
extension ImagesViewController {
    
    func selectItem(_ item: ImageItem) {
        selectedItems.append(item)
        item.order = selectedItems.count
        item.isSelected = true
    }
    
    func deselectItem(_ item: ImageItem) {
        item.isSelected = false
        if let index = selectedItems.index(of: item) {
            selectedItems.remove(at: index)
        }
        for i in 0..<selectedItems.count {
            let item = selectedItems[i]
            item.order = i + 1
        }
    }
}

// MARK: Swipe selection
extension ImagesViewController: UIGestureRecognizerDelegate {
    
    func setupSwipeSelection() {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.delegate = self
        self.collectionView.addGestureRecognizer(swipeGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        if gesture.state != .began && gesture.state != .changed {
            return
        }
        let currLocation = gesture.location(in: collectionView)
        // If no cell is selected
        guard let currIndexPath = collectionView.indexPathForItem(at: currLocation) else {
            return
        }
        let currIndex = currIndexPath.row
        guard let item = item(at: currIndex) else {
            return
        }
        switch (gesture.state) {
        case .began:
            let velocity = gesture.velocity(in: collectionView)
            // Only horizontal
            if abs(velocity.x) < abs(velocity.y) {
                gesture.state = .cancelled
                return
            } else {
                collectionView.panGestureRecognizer.state = .cancelled
            }
            selectedItemsBeforeSwipeSelection = self.selectedItems
            swipeSelectionFirstIndex = currIndex
            swipeSelectionLastIndex = currIndex
            if self.selectedItems.contains(item) {
                swipeSelectionIsAddingSelections = false
                self.deselectItem(item)
            } else {
                swipeSelectionIsAddingSelections = true
                self.selectItem(item)
            }
        case .changed:
            if currIndex == swipeSelectionLastIndex {
                return
            }
            // Prepare old/new ranges
            let oldRange = min(swipeSelectionFirstIndex,swipeSelectionLastIndex)...max(swipeSelectionFirstIndex,swipeSelectionLastIndex)
            let newRange = min(swipeSelectionFirstIndex,currIndex)...max(swipeSelectionFirstIndex,currIndex)
            // Collect indexes to restore or apply
            let indexesToRestore = oldRange.filter { !newRange.contains($0) }
            let indexesToApply = newRange.filter { !oldRange.contains($0) }
            // Do restore or apply
            if currIndex > swipeSelectionFirstIndex {
                _ = indexesToApply.map { self.updateSwipeSelection($0, true) }
            } else {
                _ = indexesToApply.reversed().map { self.updateSwipeSelection($0, true) }
            }
            _ = indexesToRestore.map { self.updateSwipeSelection($0, false) }
            // Remember the new last index
            swipeSelectionLastIndex = currIndex
        default:
            break
        }
    }
    
    func updateSwipeSelection(_ i: Int, _ isApply: Bool) {
        guard let item = item(at: i) else {
            return
        }
        let wasSelected = self.selectedItemsBeforeSwipeSelection.contains(item)
        if isApply {
            if self.swipeSelectionIsAddingSelections && !wasSelected {
                self.selectItem(item)
            } else if !self.swipeSelectionIsAddingSelections && wasSelected {
                self.deselectItem(item)
            }
        } else {
            let isSelected = self.selectedItems.contains(item)
            if wasSelected && !isSelected {
                self.selectItem(item)
            } else if !wasSelected && isSelected {
                self.deselectItem(item)
            }
        }
        updateSelectionStatusForVisibleCells()
    }
}
