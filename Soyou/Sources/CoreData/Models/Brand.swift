//
//  Brand.swift
//  Soyou
//
//  Created by CocoaBob on 12/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Brand: NSManagedObject {

    
    @discardableResult class func importData(_ data: NSDictionary?, _ context: NSManagedObjectContext) -> (Brand?) {
        guard let data = data else {
            return nil
        }
        
        guard let id = data["id"] as? NSNumber else {
            return nil
        }
        
        var brand: Brand? = Brand.mr_findFirst(with: FmtPredicate("id == %@", id), in: context)
        if brand == nil {
            brand = Brand.mr_createEntity(in: context)
            brand?.id = id
        }
        
        if let brand = brand {
            brand.label = data["label"] as? String
            brand.imageUrl = data["imageUrl"] as? String
            brand.extra = data["extra"] as? String
            brand.order = data["order"] as? NSNumber
            brand.categories = data["categories"] as? NSArray
            brand.brandIndex = data["brandIndex"] as? String
            brand.isHot = data["isHot"] as? NSNumber
        }
        
        return brand
    }
    
    class func importDatas(_ datas: [NSDictionary]?, _ deleteNonExisting: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                completion?(nil, FmtError(0, nil))
                return
            }
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                var ids = [NSNumber]()
                
                // Import new data
                for data in datas {
                    if let brand = Brand.importData(data, localContext) {
                        ids.append(brand.id!)
                    }
                }
                
                // Delete non existing items
                Brand.mr_deleteAll(matching: FmtPredicate("NOT (id IN %@)", ids), in: localContext)
                
                }, completion: { (responseObject, error) -> Void in
                    completion?(responseObject, error as NSError?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
}
