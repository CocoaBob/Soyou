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
    
    class func importData(data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (Product?) {
        var product: Product? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            
            guard let id = data["id"] as? NSNumber else { return }
            
            product = Product.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
            if product == nil {
                product = Product.MR_createEntityInContext(context)
            }
            
            if let product = product {
                product.id = id
                if let value = data["dateModification"] as? String {
                    let newDateModification = self.dateFormatter.dateFromString(value)
                    if isComplete {
                        product.appIsUpdated = NSNumber(bool: true)
                    } else {
                        if newDateModification != product.dateModification {
                            product.appIsUpdated = NSNumber(bool: false) // Needs to be updated
                        }
                    }
                    product.dateModification = newDateModification
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
                if let value = data["categories"] as? String {
                    product.categories = value
                }
                if let value = data["order"] as? NSNumber {
                    product.order = value
                }
            }
        }
        
        if let context = context {
            importDataClosure(context)
        } else {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                importDataClosure(localContext)
            })
        }
        
        return product
    }
    
    class func importDatas(datas: [NSDictionary]?, _ isComplete: Bool) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                for data in datas {
                    Product.importData(data, isComplete, localContext)
                }
            })
        }
    }
}
