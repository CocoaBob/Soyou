//
//  Brand+CoreDataProperties.swift
//  iPrices
//
//  Created by CocoaBob on 12/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Brand {

    @NSManaged var id: NSNumber?
    @NSManaged var label: String?
    @NSManaged var imageUrl: String?
    @NSManaged var extra: String?
}
