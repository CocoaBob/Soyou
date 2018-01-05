//
//  User+CoreDataProperties.swift
//  Soyou
//
//  Created by CocoaBob on 23/04/16.
//  Copyright © 2016 Soyou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var gender: String?
    @NSManaged var id: NSNumber?
    @NSManaged var matricule: NSNumber?
    @NSManaged var region: String?
    @NSManaged var roleCode: String?
    @NSManaged var username: String?
    @NSManaged var avatar: String?

}
