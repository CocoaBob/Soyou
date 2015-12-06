//
//  Product.swift
//  iPrices
//
//  Created by CocoaBob on 06/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

import Foundation
import CoreData


class Product: BaseModel {
    
    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext) -> (Product?) {
        guard let data = data else {
            return nil
        }
        
        guard let id = data["id"] as? NSNumber else {
            return nil
        }
        
        var product: Product? = Product.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
        if product == nil {
            product = Product.MR_createEntityInContext(context)
        }
        
        if let product = product {
            product.id = id
            if let dateModification = data["dateModification"] as? String {
                product.dateModification = self.dateFormatter.dateFromString(dateModification)
            }
            if let value = data["brandId"] as? NSNumber {
                product.brandId = value
            }
            if let value = data["brandLabel"] as? String {
                product.brandLabel = value
            }
            if let value = data["collectionId"] as? NSNumber {
                product.collectionId = value
            }
            if let value = data["collectionLabel"] as? String {
                product.collectionLabel = value
            }
            if let value = data["descriptions"] as? String {
                product.descriptions = value
            }
            if let value = data["images"] as? String {
                // TODO: Serialize array to data
                product.images = value.dataUsingEncoding(NSUTF8StringEncoding)
            }
            if let value = data["keywords"] as? String {
                product.keywords = value
            }
            if let value = data["likeNumber"] as? NSNumber {
                product.likeNumber = value
            }
            if let value = data["prices"] as? String {
                // TODO: Serialize array to data
                product.prices = value.dataUsingEncoding(NSUTF8StringEncoding)
            }
            if let value = data["reference"] as? String {
                product.reference = value
            }
            if let value = data["rubricId"] as? NSNumber {
                product.rubricId = value
            }
            if let value = data["surname"] as? String {
                product.surname = value
            }
            if let value = data["title"] as? String {
                product.title = value
            }
        }
        
        return product
    }
    
    class func importDatas(datas: [NSDictionary]?, _ triggeredMoreItemID: NSNumber?) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                for data in datas {
                    Product.importData(data, localContext)
                }
            })
        }
    }
}
