//
//  Brand+CoreDataProperties.swift
//  Soyou
//
//  Created by CocoaBob on 03/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Brand {

    @NSManaged var extra: String?
    @NSManaged var id: NSNumber?
    @NSManaged var imageUrl: String?
    @NSManaged var label: String?
    @NSManaged var categories: NSObject?
    @NSManaged var order: NSNumber?

}
