//
//  Brand.swift
//  iPrices
//
//  Created by CocoaBob on 12/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
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
            }
            if let value = data["imageUrl"] as? String {
                brand.imageUrl = value
            }
            if let value = data["extra"] as? String {
                brand.extra = value
            }
            if let value = data["type"] as? String {
                brand.type = value
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
                for brand in Brand.MR_findAllWithPredicate(FmtPredicate("NOT (id IN %@)", newIDs), inContext: localContext) {
                    brand.MR_deleteEntityInContext(localContext)
                }
            })
        }
    }
}
