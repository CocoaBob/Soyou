//
//  Circle+CoreDataProperties.swift
//  Soyou
//
//  Created by CocoaBob on 02/01/18.
//  Copyright © 2018 Soyou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Circle {

    @NSManaged var id: String?
    @NSManaged var text: String?
    @NSManaged var images: NSArray?
    @NSManaged var userId: NSNumber?
    @NSManaged var username: String?
    @NSManaged var userProfileUrl: String?
    @NSManaged var createdDate: Date?
    @NSManaged var visibility: NSNumber?
    @NSManaged var comments: NSArray?
    @NSManaged var likes: NSArray?

}
