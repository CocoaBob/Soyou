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
    var uuid = UUID().uuidString
    var isSelected = false
    var order = 0
    
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

extension ImageItem: Equatable {
    
    static func ==(lhs: ImageItem, rhs: ImageItem) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
