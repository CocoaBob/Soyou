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
    
    func isFavorite() -> Bool {
        var returnValue = false
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let _ = self.MR_inContext(localContext)?.relatedFavoriteProduct(localContext) {
                returnValue = true
            }
        })
        return returnValue
    }
    
    class func importData(data: NSDictionary?, _ checkExisting: Bool, _ context: NSManagedObjectContext?) -> (Product?) {
        var product: Product? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            
            guard let id = data["id"] as? NSNumber else { return }
            
            if checkExisting {
                product = Product.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
            }
            if product == nil {
                product = Product.MR_createEntityInContext(context)
                product?.id = id
            }
            
            if let product = product {
                product.categories = data["categories"] as? String
                product.brandId = data["brandId"] as? NSNumber
                product.dimension = data["dimension"] as? String
                product.images = data["images"] as? NSArray
                product.likeNumber = data["likeNumber"] as? NSNumber
                product.prices = data["prices"] as? NSArray
                product.appPricesCount = (product.prices as? NSArray)?.count ?? 0
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
        
        if let context = context {
            importDataClosure(context)
        } else {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                importDataClosure(localContext)
            })
        }
        
        return product
    }
    
    class func importDatas(datas: [NSDictionary]?, _ checkExisting: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            MagicalRecord.saveWithBlock({ (localContext) -> Void in
                for data in datas {
                    Product.importData(data, checkExisting, localContext)
                }
                
                }, completion: { (_, _) -> Void in
                    if let completion = completion { completion(nil, nil) }
            })
        } else {
            if let completion = completion { completion(nil, nil) }
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
    
    func toggleFavorite(completion: DataClosure?) {
        // Product ID
        var selfProductID: NSNumber?
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            selfProductID = self.MR_inContext(localContext)?.id
        })
        guard let productID = selfProductID else { return }
        
        // Find the favorite product
        var favoriteProduct: FavoriteProduct?
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            favoriteProduct = FavoriteProduct.MR_findFirstByAttribute("id", withValue: productID, inContext: localContext)
        })
        
        // Was favorite?
        let wasFavorite = favoriteProduct != nil
        
        // Update local data only when response is received
        DataManager.shared.favoriteProduct(productID, wasFavorite: wasFavorite) { responseObject, error in
            if error != nil {
                return
            }
            
            // Create/Update FavoriteProduct, or delete FavoriteProduct
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                var localFavoriteProduct = favoriteProduct?.MR_inContext(localContext)
                if wasFavorite {
                    favoriteProduct?.MR_deleteEntityInContext(localContext)
                } else {
                    if localFavoriteProduct == nil {
                        localFavoriteProduct = FavoriteProduct.MR_createEntityInContext(localContext)
                        localFavoriteProduct?.id = productID
                    }
                    localFavoriteProduct?.dateFavorite = NSDate()
                }
            })
            // Completion
            if let completion = completion {
                completion(responseObject)
            }
        }
    }
    
    class func normalized(text: String?) -> String {
        if let text = text {
            return " " + text.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet).joinWithSeparator("").lowercaseString
        } else {
            return ""
        }
    }
    
    func relatedFavoriteProduct(context: NSManagedObjectContext?) -> FavoriteProduct? {
        if let productID = self.id {
            if let context = context {
                return FavoriteProduct.MR_findFirstByAttribute("id", withValue: productID, inContext: context)
            } else {
                return FavoriteProduct.MR_findFirstByAttribute("id", withValue: productID)
            }
        }
        return nil
    }
}
