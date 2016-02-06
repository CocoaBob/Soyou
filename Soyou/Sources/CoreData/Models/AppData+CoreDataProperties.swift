//
//  AppData+CoreDataProperties.swift
//  Soyou
//
//  Created by CocoaBob on 06/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AppData {

    @NSManaged var key: String?
    @NSManaged var value: String?

}
