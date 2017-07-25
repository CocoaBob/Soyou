//
//  Discount+CoreDataProperties.swift
//  Soyou
//
//  Created by CocoaBob on 26/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Discount {
    
    @NSManaged var appIsFavorite: NSNumber?
    @NSManaged var appIsUpdated: NSNumber?
    @NSManaged var author: String?
    @NSManaged var content: String?
    @NSManaged var coverImage: String?
    @NSManaged var dateModification: Date?
    @NSManaged var expireDate: Date?
    @NSManaged var id: NSNumber?
    @NSManaged var isOnline: NSNumber?
    @NSManaged var publishdate: Date?
    @NSManaged var title: String?
    @NSManaged var url: String?

}
