//
//  Product.swift
//  Soyou
//
//  Created by CocoaBob on 06/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
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
                
                var searchText = ""
                
                if let value = data["brandId"] as? NSNumber {
                    product.brandId = value
                }
                if let value = data["brandLabel"] as? String {
                    product.brandLabel = value
                    searchText += normalized(value)
                }
                if let value = data["descriptions"] as? String {
                    product.descriptions = value
                    searchText += normalized(value)
                }
                if let value = data["dimension"] as? String {
                    product.dimension = value
                }
                if let value = data["images"] as? NSArray {
                    product.images = value
                }
                if let value = data["keywords"] as? String {
                    product.keywords = value
                    searchText += normalized(value)
                }
                if let value = data["likeNumber"] as? NSNumber {
                    product.likeNumber = value
                }
                if let value = data["prices"] as? NSArray {
                    product.prices = value
                }
                if let value = data["reference"] as? String {
                    product.reference = value
                    searchText += normalized(value)
                }
                if let value = data["surname"] as? String {
                    product.surname = value
                    searchText += normalized(value)
                }
                if let value = data["title"] as? String {
                    product.title = value
                    searchText += normalized(value)
                }
                if let value = data["categories"] as? String {
                    product.categories = value
                }
                if let value = data["order"] as? NSNumber {
                    product.order = value
                }
                product.appSearchText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
    
    func doLike(completion: DataClosure?) {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localProduct = self.MR_inContext(localContext) {
                let appWasLiked = localProduct.appIsLiked != nil && localProduct.appIsLiked!.boolValue
                // Update only when response is received
                DataManager.shared.likeProduct(localProduct.id!, wasLiked: appWasLiked) { responseObject, error in
                    guard let data = responseObject?["data"] else { return }
                    
                    // Remember if it's liked or not
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        if let localProduct = self.MR_inContext(localContext) {
                            localProduct.appIsLiked = NSNumber(bool: !appWasLiked)
                        }
                    })
                    // Completion
                    if let completion = completion {
                        completion(data)
                    }
                }
            }
        })
    }
    
    func doFavorite(completion: DataClosure?) {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localProduct = self.MR_inContext(localContext) {
                let appIsFavorite = localProduct.appIsFavorite != nil && localProduct.appIsFavorite!.boolValue
                // Update only when response is received
                DataManager.shared.favoriteProduct(localProduct.id!, isFavorite: appIsFavorite) { responseObject, error in
                    // Remember if it's liked or not
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        if let localProduct = self.MR_inContext(localContext) {
                            localProduct.appIsFavorite = NSNumber(bool: !appIsFavorite)
                        }
                    })
                    // Completion
                    if let completion = completion {
                        completion(responseObject)
                    }
                }
            }
        })
    }
    
    class func normalized(text: String) -> String {
        return " " + text.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet).joinWithSeparator("").lowercaseString
    }
}
