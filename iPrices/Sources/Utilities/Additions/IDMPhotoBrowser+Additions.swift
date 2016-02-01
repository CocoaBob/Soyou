//
//  IDMPhotoBrowser+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 01/02/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

extension IDMPhotoBrowser {
    
    class func present(photos: [IDMPhoto], index: UInt, viewVC: UIViewController) {
        let photoBrowser = IDMPhotoBrowser(photos: photos)
        photoBrowser.displayToolbar = true
        photoBrowser.displayActionButton = true
        photoBrowser.displayArrowButton = true
        photoBrowser.displayCounterLabel = true
        photoBrowser.displayDoneButton = true
        photoBrowser.usePopAnimation = false
        photoBrowser.useWhiteBackgroundColor = false
        photoBrowser.disableVerticalSwipe = false
        photoBrowser.forceHideStatusBar = false
        
        photoBrowser.setInitialPageIndex(index)
        
        viewVC.presentViewController(photoBrowser, animated: true, completion: nil)
    }
}