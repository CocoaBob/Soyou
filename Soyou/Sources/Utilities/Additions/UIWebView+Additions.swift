//
//  UIWebView+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2018-06-10.
//  Copyright © 2018 Soyou. All rights reserved.
//

import UIKit

extension UIWebView {
    
    func allImgURLs() -> [String]? {
        return self.stringByEvaluatingJavaScript(from: "var imgs = []; for (var i = 0; i < document.images.length; i++) { imgs.push(document.images[i].src) }; imgs.toString();")?.components(separatedBy: ",")
    }
}
