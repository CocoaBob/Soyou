//
//  Product+CoreDataProperties.swift
//  iPrices
//
//  Created by chenglian on 16/1/31.
//  Copyright © 2016年 iPrices. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Product {

    @NSManaged var appIsFavorite: NSNumber?
    @NSManaged var appIsLiked: NSNumber?
    @NSManaged var appIsUpdated: NSNumber?
    @NSManaged var brandId: NSNumber?
    @NSManaged var brandLabel: String?
    @NSManaged var categories: String?
    @NSManaged var dateModification: NSDate?
    @NSManaged var descriptions: String?
    @NSManaged var id: NSNumber?
    @NSManaged var images: NSObject?
    @NSManaged var keywords: String?
    @NSManaged var likeNumber: NSNumber?
    @NSManaged var order: NSNumber?
    @NSManaged var prices: NSObject?
    @NSManaged var reference: String?
    @NSManaged var surname: String?
    @NSManaged var title: String?

}
