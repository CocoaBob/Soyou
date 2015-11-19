//
//  News+CoreDataProperties.swift
//  iPrices
//
//  Created by CocoaBob on 18/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension News {

    @NSManaged var id: NSNumber?
    @NSManaged var author: String?
    @NSManaged var title: String?
    @NSManaged var image: String?
    @NSManaged var isLoadMore: NSNumber?
    @NSManaged var dateModified: NSDate?
    @NSManaged var datePublication: NSDate?
    @NSManaged var version: String?
    @NSManaged var content: String?

}
