//
//  FileManager.swift
//  iPrices
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

import Foundation

class FileManager: NSObject {
    
    static var docDir: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.last!
    }()
}