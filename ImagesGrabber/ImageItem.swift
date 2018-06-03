//
//  ImageItem.swift
//  ImagesGrabber
//
//  Created by CocoaBob on 2018-06-01.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import UIKit

class ImageItem {
    
    var url: URL?
    var image: UIImage?
    
    init() {
        
    }
    
    convenience init(url: URL) {
        self.init()
        self.url = url
    }
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
    }
}
