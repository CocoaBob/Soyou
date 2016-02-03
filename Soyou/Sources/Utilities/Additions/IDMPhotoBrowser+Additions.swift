//
//  IDMPhotoBrowser+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 01/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

extension IDMPhotoBrowser {
    
    class func present(photos: [IDMPhoto]!, index: UInt!, view: UIView?, scaleImage: UIImage?, viewVC: UIViewController!) {
        let photoBrowser = (view != nil) ? IDMPhotoBrowser(photos: photos, animatedFromView: view) : IDMPhotoBrowser(photos: photos)
        if scaleImage != nil {
            photoBrowser.scaleImage = scaleImage
        }
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