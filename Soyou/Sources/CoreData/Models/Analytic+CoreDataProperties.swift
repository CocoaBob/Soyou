//
//  Analytic+CoreDataProperties.swift
//  Soyou
//
//  Created by chenglian on 16/1/4.
//  Copyright © 2016年 Soyou. All rights reserved.
//

import Foundation
import CoreData

extension Analytic {
    
    @NSManaged var id: NSNumber?
    @NSManaged var data: String?
    @NSManaged var target: NSNumber?
    @NSManaged var action: NSNumber?
    @NSManaged var operatedAt: Date?
    
}
