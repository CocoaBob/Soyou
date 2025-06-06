//
//  News+CoreDataProperties.swift
//  Soyou
//
//  Created by CocoaBob on 03/06/16.
//  Copyright © 2016 Soyou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension News {
    
    @NSManaged var appIsFavorite: NSNumber?
    @NSManaged var appIsLiked: NSNumber?
    @NSManaged var appIsUpdated: NSNumber?
    @NSManaged var author: String?
    @NSManaged var content: String?
    @NSManaged var dateModification: Date?
    @NSManaged var datePublication: Date?
    @NSManaged var expireDate: Date?
    @NSManaged var id: NSNumber?
    @NSManaged var image: String?
    @NSManaged var isOnline: NSNumber?
    @NSManaged var title: String?
    @NSManaged var subtitle: String?
    @NSManaged var url: String?

}
