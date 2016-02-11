//
//  IntroViewController.swift
//  Soyou
//
//  Created by CocoaBob on 11/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class IntroViewController {
    
    class func showIntroView() {
        guard let keyWindow = UIApplication.sharedApplication().keyWindow else { return }
        
        var introPages = [EAIntroPage]()
        for i in 1...4 {
            let introPage = EAIntroPage()
            introPage.title = "Introduction Page \(i)"
            introPage.desc = "Introduction descriptions for Page \(i)"
            introPage.bgImage = UIImage(named: "bg\(i)")
            introPage.titleIconView = UIImageView(image: UIImage(named: "title\(i)"))
            introPages.append(introPage)
        }
        let introView = EAIntroView(frame: keyWindow.bounds, andPages: introPages)
        
        introView.showInView(keyWindow, animateDuration: 0.3)
    }
}