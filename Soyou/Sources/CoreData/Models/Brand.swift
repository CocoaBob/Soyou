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
            brand?.id = id
        }
        
        if let brand = brand {
            brand.label = data["label"] as? String
            brand.imageUrl = data["imageUrl"] as? String
            brand.extra = data["extra"] as? String
            brand.order = data["order"] as? NSNumber
            brand.categories = data["categories"] as? NSArray
        }
        
        return brand
    }
    
    class func importDatas(datas: [NSDictionary]?, _ deleteNonExisting: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                if let completion = completion { completion(nil, FmtError(0, nil)) }
                return
            }
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                var ids = [NSNumber]()
                
                // Import new data
                for data in datas {
                    if let brand = Brand.importData(data, localContext) {
                        ids.append(brand.id!)
                    }
                }
                
                // Delete non existing items
                Brand.MR_deleteAllMatchingPredicate(FmtPredicate("NOT (id IN %@)", ids), inContext: localContext)
                
                }, completion: { (responseObject, error) -> Void in
                    if let completion = completion { completion(responseObject, error) }
            })
        } else {
            if let completion = completion { completion(nil, FmtError(0, nil)) }
        }
    }
}
