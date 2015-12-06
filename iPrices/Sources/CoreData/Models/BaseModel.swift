//
//  BaseModel.swift
//  iPrices
//
//  Created by CocoaBob on 06/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class BaseModel: NSManagedObject {
    
    static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    } ()
    
}