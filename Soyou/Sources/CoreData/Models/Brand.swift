//
//  Brand.swift
//  Soyou
//
//  Created by CocoaBob on 12/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Brand: BaseModel {

    
    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext) -> (Brand?) {
        guard let data = data else {
            return nil
        }
        
        guard let id = data["id"] as? NSNumber else {
            return nil
        }
        
        var brand: Brand? = Brand.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
        if brand == nil {
            brand = Brand.MR_createEntityInContext(context)
        }
        
        if let brand = brand {
            brand.id = id
            if let value = data["label"] as? String {
                brand.label = value
            } else {
                brand.label = nil
            }
            if let value = data["imageUrl"] as? String {
                brand.imageUrl = value
            } else {
                brand.imageUrl = nil
            }
            if let value = data["extra"] as? String {
                brand.extra = value
            } else {
                brand.extra = nil
            }
            if let value = data["order"] as? NSNumber {
                brand.order = value
            } else {
                brand.order = nil
            }
            if let value = data["categories"] as? NSArray {
                brand.categories = value
            } else {
                brand.categories = nil
            }
        }
        
        return brand
    }
    
    class func importDatas(datas: [NSDictionary]?, _ deleteNonExisting: Bool) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                var newIDs = [NSNumber]()
                
                // Import new data
                for data in datas {
                    if let brand = Brand.importData(data, localContext) {
                        newIDs.append(brand.id!)
                    }
                }
                
                // Delete non existing items
                if let brands = Brand.MR_findAllWithPredicate(FmtPredicate("NOT (id IN %@)", newIDs), inContext: localContext) {
                    for brand in brands {
                        brand.MR_deleteEntityInContext(localContext)
                    }
                }
            })
        }
    }
}
