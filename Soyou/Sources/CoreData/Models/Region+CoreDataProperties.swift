//
//  Region+CoreDataProperties.swift
//  Soyou
//
//  Created by CocoaBob on 31/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Region {
    
    @NSManaged var appOrder: NSNumber?
    @NSManaged var code: String?
    @NSManaged var currency: String?
}
