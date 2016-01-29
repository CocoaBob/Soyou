//
//  Region+CoreDataProperties.swift
//  iPrices
//
//  Created by CocoaBob on 29/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Region {

    @NSManaged var id: NSNumber?
    @NSManaged var code: String?
    @NSManaged var currency: String?

}
