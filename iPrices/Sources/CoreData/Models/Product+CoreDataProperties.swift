//
//  Product+CoreDataProperties.swift
//  iPrices
//
//  Created by CocoaBob on 03/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Product {

    @NSManaged var appIsUpdated: NSNumber?
    @NSManaged var brandId: NSNumber?
    @NSManaged var brandLabel: String?
    @NSManaged var collectionId: NSNumber?
    @NSManaged var collectionLabel: String?
    @NSManaged var dateModification: NSDate?
    @NSManaged var descriptions: String?
    @NSManaged var id: NSNumber?
    @NSManaged var images: NSObject?
    @NSManaged var keywords: String?
    @NSManaged var likeNumber: NSNumber?
    @NSManaged var prices: NSObject?
    @NSManaged var reference: String?
    @NSManaged var rubricId: NSNumber?
    @NSManaged var surname: String?
    @NSManaged var title: String?
    @NSManaged var categories: String?
    @NSManaged var appIsLiked: NSNumber?
    @NSManaged var order: NSNumber?

}
