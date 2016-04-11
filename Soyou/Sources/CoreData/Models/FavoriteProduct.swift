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
    
    class func deleteAll() {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            FavoriteProduct.MR_deleteAllMatchingPredicate(FmtPredicate("1==1"), inContext: localContext)
        })
    }
    
    class func updateWithData(data: [NSDictionary], _ completion: CompletionClosure?) {
        // Create a dictionary of all favorite news
        var favoriteIDs = [NSNumber]()
        var favoriteDates = [NSNumber: NSDate]()
        for dict in data {
            if let newsID = dict["id"] as? NSNumber, dateModification = dict["dateModification"] as? String {
                favoriteIDs.append(newsID)
                favoriteDates[newsID] = Cons.utcDateFormatter.dateFromString(dateModification)
            }
        }
        
        // Filter all existing ones, delete remotely deleted ones.
        MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
            if let allFavoriteProducts = FavoriteProduct.MR_findAllInContext(localContext) as? [FavoriteProduct] {
                for favoriteProduct in allFavoriteProducts {
                    if let newsID = favoriteProduct.id, index = favoriteIDs.indexOf(newsID) {
                        favoriteProduct.dateFavorite = favoriteDates[newsID]
                        favoriteIDs.removeAtIndex(index)
                    } else {
                        favoriteProduct.MR_deleteEntityInContext(localContext)
                    }
                }
            }
            
            // Import all new product favorites
            for productID in favoriteIDs {
                let favoriteProduct = FavoriteProduct.MR_createEntityInContext(localContext)
                favoriteProduct?.id = productID
                favoriteProduct?.dateFavorite = favoriteDates[productID]
            }
            
            // Completion
            if let completion = completion { completion(nil, FmtError(0, nil)) }
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
