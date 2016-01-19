//
//  CurrencyRate+CoreDataProperties.swift
//  iPrices
//
//  Created by chenglian on 16/1/19.
//  Copyright © 2016年 iPrices. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CurrencyRate {

    @NSManaged var sourceCode: String?
    @NSManaged var targetCode: String?
    @NSManaged var rate: NSNumber?
    @NSManaged var updatedAt: NSDate?

}
