//
//  News+CoreDataProperties.swift
//  iPrices
//
//  Created by CocoaBob on 20/11/15.
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
    @NSManaged var dateModification: NSDate?
    @NSManaged var datePublication: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var image: String?
    @NSManaged var isLiked: NSNumber?
    @NSManaged var isOnline: NSNumber?
    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var isMore: NSNumber?
    @NSManaged var likeNumber: NSNumber?

}
