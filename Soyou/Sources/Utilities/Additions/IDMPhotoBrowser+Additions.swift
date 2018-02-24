//
//  IDMPhotoBrowser+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 01/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

extension IDMPhotoBrowser {
    
    class func present(_ photos: [IDMPhoto]!, index: UInt!, view: UIView?, scaleImage: UIImage?, viewVC: UIViewController!) {
        let _photoBrowser = (view != nil) ? IDMPhotoBrowser(photos: photos, animatedFrom: view) : IDMPhotoBrowser(photos: photos)
        guard let photoBrowser = _photoBrowser else { return }
        if scaleImage != nil {
            photoBrowser.scaleImage = scaleImage
        }
        photoBrowser.displayToolbar = true
        photoBrowser.displayActionButton = false
        photoBrowser.displayArrowButton = false
        photoBrowser.displayCounterLabel = true
        photoBrowser.displayDoneButton = false
        photoBrowser.usePopAnimation = false
        photoBrowser.useWhiteBackgroundColor = false
        photoBrowser.disableVerticalSwipe = false
        photoBrowser.forceHideStatusBar = false
        photoBrowser.dismissOnTouch = true
        photoBrowser.autoHideInterface = false
        
        photoBrowser.setInitialPageIndex(index)
        
        viewVC.present(photoBrowser, animated: true, completion: nil)
    }
}
