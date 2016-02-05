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
                product?.id = id
            }
            
            if let product = product {
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
                
                // Categories only exist in the check phase
                if !isComplete {
                    product.categories = data["categories"] as? String
                } else {
                    product.brandId = data["brandId"] as? NSNumber
                    product.dimension = data["dimension"] as? String
                    product.images = data["images"] as? NSArray
                    product.likeNumber = data["likeNumber"] as? NSNumber
                    product.prices = data["prices"] as? NSArray
                    product.order = data["order"] as? NSNumber
                    
                    product.brandLabel = data["brandLabel"] as? String
                    product.descriptions = data["descriptions"] as? String
                    product.keywords = data["keywords"] as? String
                    product.reference = data["reference"] as? String
                    product.surname = data["surname"] as? String
                    product.title = data["title"] as? String
                    
                    var searchText = ""
                    searchText += normalized(product.brandLabel)
                    searchText += product.descriptions ?? ""
                    searchText += normalized(product.keywords)
                    searchText += normalized(product.reference)
                    searchText += normalized(product.surname)
                    searchText += normalized(product.title)
                    
                    searchText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if searchText.characters.count > 0 {
                        product.appSearchText = searchText
                    } else {
                        product.appSearchText = nil
                    }
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
    
    class func normalized(text: String?) -> String {
        if let text = text {
            return " " + text.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet).joinWithSeparator("").lowercaseString
        } else {
            return ""
        }
    }
}
