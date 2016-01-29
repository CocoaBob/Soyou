//
//  Store+CoreDataProperties.swift
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

extension Store {

    @NSManaged var title: String?
    @NSManaged var division: String?
    @NSManaged var address: String?
    @NSManaged var zipcode: String?
    @NSManaged var city: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var brandId: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var country: String?

}
