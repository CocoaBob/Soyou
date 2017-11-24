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
            MagicalRecord.save(blockAndWait: { (diskContext) in
                if let _ = self.mr_(in: ramContext)?.relatedFavoriteProduct(diskContext) {
                    returnValue = true
                }
            })
        })
        return returnValue
    }
    
    func importData(_ data: NSDictionary?) {
        guard let data = data else { return }
        self.id = data["id"] as? NSNumber
        if let sku = data["sku"] as? String {
            self.sku = Utils.encrypt(sku as AnyObject)
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
    
    @discardableResult class func importData(_ data: NSDictionary?, _ context: NSManagedObjectContext?) -> (Product?) {
        var product: Product? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            
            guard let id = data["id"] as? NSNumber else { return }
            
            product = Product.mr_findFirst(with: FmtPredicate("id == %@", id), in: context)
            if product == nil {
                product = Product.mr_createEntity(in: context)
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
                
                searchText = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if searchText.isEmpty {
                    product.appSearchText = nil
                } else {
                    product.appSearchText = searchText
                }
            }
        }
        
        if let context = context {
            importDataClosure(context)
        } else {
            MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) -> Void in
                importDataClosure(localContext)
            })
        }
        
        return product
    }
    
    class func importDatas(_ datas: [NSDictionary]?, _ completion: CompletionClosure?) {
        if let datas = datas {
            MagicalRecord.save(blockAndWait: { (localContext) in
                for data in datas {
                    Product.importData(data, localContext)
                }
            })
            if let completion = completion { completion(nil, nil) }
        } else {
            if let completion = completion { completion(nil, FmtError(0, nil)) }
        }
    }
    
    class func productsWithData(_ datas: [NSDictionary]?) -> [Product]? {
        if let datas = datas {
            var products = [Product]()
            for data in datas {
                if let product = Product.mr_createEntity(in: DataManager.shared.memoryContext()) {
                    product.importData(data)
                    products.append(product)
                }
            }
            return products
        }
        return nil
    }
    
    func doLike(_ completion: ((NSNumber, NSNumber)->())?) {
        self.managedObjectContext?.runBlockAndWait({ (memoryContext: NSManagedObjectContext!) -> Void in
            if let memoryProduct = self.mr_(in: memoryContext) {
                MagicalRecord.save(blockAndWait: { (diskContext: NSManagedObjectContext!) -> Void in
                    guard let productID = memoryProduct.id else { return }
                    guard let diskProduct = Product.mr_findFirst(byAttribute: "id", withValue: productID, in: diskContext) else { return }
                    let appWasLiked = diskProduct.appIsLiked != nil && diskProduct.appIsLiked!.boolValue
                    // Update only when response is received
                    DataManager.shared.likeProduct(diskProduct.id!, wasLiked: appWasLiked) { responseObject, error in
                        guard let responseObject = responseObject as? [String: AnyObject] else { return }
                        guard let likeNumber = responseObject["data"] as? NSNumber else { return }
                        let isLiked = NSNumber(value: !appWasLiked)
                        // Remember if it's liked or not
                        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) -> Void in
                            if let diskProduct = diskProduct.mr_(in: localContext) {
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
    
    func toggleFavorite(_ completion: DataClosure?) {
        // Product ID
        var selfProductID: NSNumber?
        self.managedObjectContext?.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            selfProductID = self.mr_(in: localContext)?.id
        })
        guard let productID = selfProductID else { return }
        
        // Find the favorite product
        var favoriteProduct: FavoriteProduct?
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) -> Void in
            favoriteProduct = FavoriteProduct.mr_findFirst(byAttribute: "id", withValue: productID, in: localContext)
        })
        
        // Was favorite?
        let wasFavorite = favoriteProduct != nil
        
        // Update local data only when response is received
        DataManager.shared.favoriteProduct(productID, wasFavorite: wasFavorite) { responseObject, error in
            if error != nil {
                return
            }
            
            // Create/Update FavoriteProduct, or delete FavoriteProduct
            MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) -> Void in
                var localFavoriteProduct = favoriteProduct?.mr_(in: localContext)
                if wasFavorite {
                    favoriteProduct?.mr_deleteEntity(in: localContext)
                } else {
                    if localFavoriteProduct == nil {
                        localFavoriteProduct = FavoriteProduct.mr_createEntity(in: localContext)
                        localFavoriteProduct?.id = productID
                    }
                    localFavoriteProduct?.dateFavorite = Date()
                }
            })
            // Completion
            if let completion = completion {
                completion(responseObject)
            }
        }
    }
    
    // Remove all characters that are not alphabets/syllabaries/ideographs/digits
    class func normalizedSearchText(_ text: String?) -> String {
        if let text = text {
            return " " + text.components(separatedBy: (CharacterSet.alphanumerics as CharacterSet).inverted).joined(separator: "").lowercased()
        } else {
            return ""
        }
    }
    
    func relatedFavoriteProduct(_ context: NSManagedObjectContext?) -> FavoriteProduct? {
        if let productID = self.id {
            if let context = context {
                return FavoriteProduct.mr_findFirst(byAttribute: "id", withValue: productID, in: context)
            } else {
                return FavoriteProduct.mr_findFirst(byAttribute: "id", withValue: productID)
            }
        }
        return nil
    }
}
