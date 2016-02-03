//
//  User+CoreDataProperties.swift
//  Soyou
//
//  Created by CocoaBob on 25/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var username: String?
    @NSManaged var gender: String?
    @NSManaged var matricule: NSNumber?
    @NSManaged var roleCode: String?
    @NSManaged var region: String?

}
