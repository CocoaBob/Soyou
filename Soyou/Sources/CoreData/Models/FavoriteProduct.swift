//
//  FavoriteProduct.swift
//  Soyou
//
//  Created by CocoaBob on 07/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class FavoriteProduct: NSManagedObject {
    
    class func updateWithData(data: [NSDictionary]) {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            // Delete all old product favorites
            if let allFavoriteProducts = FavoriteProduct.MR_findAllInContext(localContext) as? [FavoriteProduct] {
                for favoriteProduct in allFavoriteProducts {
                    favoriteProduct.MR_deleteEntityInContext(localContext)
                }
            }
            
            // Import all new product favorites
            for dict in data {
                if let productId = dict["id"] as? NSNumber,
                    dateModification = dict["dateModification"] as? String {
                        let favoriteProduct = FavoriteProduct.MR_createEntityInContext(localContext)
                        favoriteProduct?.id = productId
                        favoriteProduct?.dateFavorite = BaseModel.dateFormatter.dateFromString(dateModification)
                }
            }
        })
    }
    
    func relatedProduct(context: NSManagedObjectContext?) -> Product? {
        if let productID = self.id {
            if let context = context {
                return Product.MR_findFirstByAttribute("id", withValue: productID, inContext: context)
            } else {
                return Product.MR_findFirstByAttribute("id", withValue: productID)
            }
        }
        return nil
    }
}
