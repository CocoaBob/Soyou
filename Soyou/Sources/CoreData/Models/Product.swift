//
//  Product.swift
//  Soyou
//
//  Created by CocoaBob on 06/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Product: NSManagedObject {
    
    func isFavorite() -> Bool {
        var returnValue = false
        
        self.managedObjectContext?.runBlockAndWait({ (ramContext: NSManagedObjectContext!) -> Void in
            MagicalRecord.saveWithBlockAndWait({ (diskContext) in
                if let _ = self.MR_inContext(ramContext)?.relatedFavoriteProduct(diskContext) {
                    returnValue = true
                }
            })
        })
        return returnValue
    }
    
    func importData(data: NSDictionary?) {
        guard let data = data else { return }
        self.id = data["id"] as? NSNumber
        if let sku = data["sku"] as? String {
            self.sku = Utils.encrypt(sku)
        } else {
            self.sku = nil
        }
        self.categories = data["categories"] as? String
        self.brandId = data["brandId"] as? NSNumber
        self.dimension = data["dimension"] as? String
        self.images = data["images"] as? NSArray
        self.likeNumber = data["likeNumber"] as? NSNumber
        if let prices = data["prices"] as? NSArray {
            self.prices = Utils.encrypt(prices)
        } else {
            self.prices = nil
        }
        self.order = data["order"] as? NSNumber
        
        self.brandLabel = data["brandLabel"] as? String
        self.descriptions = data["descriptions"] as? String
        self.keywords = data["keywords"] as? String
        self.reference = data["reference"] as? String
        self.surname = data["surname"] as? String
        self.title = data["title"] as? String
    }
    
    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext?) -> (Product?) {
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
                product.importData(data)
                
                // Prepare for searching
                var searchText = ""
                searchText += normalizedSearchText(product.brandLabel)
                searchText += product.descriptions ?? ""
                searchText += normalizedSearchText(product.keywords)
                searchText += normalizedSearchText(product.reference)
                searchText += normalizedSearchText(product.surname)
                searchText += normalizedSearchText(product.title)
                
                searchText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if searchText.characters.isEmpty {
                    product.appSearchText = nil
                } else {
                    product.appSearchText = searchText
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
    
    class func importDatas(datas: [NSDictionary]?, _ completion: CompletionClosure?) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext) in
                for data in datas {
                    Product.importData(data, localContext)
                }
            })
            if let completion = completion { completion(nil, nil) }
        } else {
            if let completion = completion { completion(nil, FmtError(0, nil)) }
        }
    }
    
    class func productsWithData(datas: [NSDictionary]?) -> [Product]? {
        if let datas = datas {
            var products = [Product]()
            for data in datas {
                if let product = Product.MR_createEntityInContext(DataManager.shared.memoryContext()) {
                    product.importData(data)
                    products.append(product)
                }
            }
            return products
        }
        return nil
    }
    
    func doLike(completion: ((NSNumber, NSNumber)->())?) {
        self.managedObjectContext?.runBlockAndWait({ (memoryContext: NSManagedObjectContext!) -> Void in
            if let memoryProduct = self.MR_inContext(memoryContext) {
                MagicalRecord.saveWithBlockAndWait({ (diskContext: NSManagedObjectContext!) -> Void in
                    guard let productID = memoryProduct.id else { return }
                    guard let diskProduct = Product.MR_findFirstByAttribute("id", withValue: productID, inContext: diskContext) else { return }
                    let appWasLiked = diskProduct.appIsLiked != nil && diskProduct.appIsLiked!.boolValue
                    // Update only when response is received
                    DataManager.shared.likeProduct(diskProduct.id!, wasLiked: appWasLiked) { responseObject, error in
                        guard let responseObject = responseObject as? [String: AnyObject] else { return }
                        guard let likeNumber = responseObject["data"] as? NSNumber else { return }
                        let isLiked = NSNumber(bool: !appWasLiked)
                        // Remember if it's liked or not
                        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                            if let diskProduct = diskProduct.MR_inContext(localContext) {
                                diskProduct.appIsLiked = isLiked
                            }
                        })
                        // Completion
                        if let completion = completion {
                            completion(likeNumber, isLiked)
                        }
                    }
                })
            }
        })
    }
    
    func toggleFavorite(completion: DataClosure?) {
        // Product ID
        var selfProductID: NSNumber?
        self.managedObjectContext?.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
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
    
    // Remove all characters that are not alphabets/syllabaries/ideographs/digits
    class func normalizedSearchText(text: String?) -> String {
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
