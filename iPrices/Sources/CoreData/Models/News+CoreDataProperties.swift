//
//  News+CoreDataProperties.swift
//  iPrices
//
//  Created by CocoaBob on 19/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension News {

    @NSManaged var author: String?
    @NSManaged var content: String?
    @NSManaged var datePublication: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var image: String?
    @NSManaged var title: String?
    @NSManaged var version: String?
    @NSManaged var dateModification: NSDate?
    @NSManaged var isOnline: NSNumber?
    @NSManaged var url: String?

}
