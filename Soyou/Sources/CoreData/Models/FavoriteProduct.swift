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
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            FavoriteProduct.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
        })
    }
    
    class func updateWithData(_ data: [NSDictionary], _ completion: CompletionClosure?) {
        // Create a dictionary of all favorite news
        var favoriteIDs = [NSNumber]()
        var favoriteDates = [NSNumber: Date]()
        for dict in data {
            if let newsID = dict["id"] as? NSNumber, let dateModification = dict["dateModification"] as? String {
                favoriteIDs.append(newsID)
                favoriteDates[newsID] = Cons.utcDateFormatter.date(from: dateModification)
            }
        }
        
        // Filter all existing ones, delete remotely deleted ones.
        MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
            if let allFavoriteProducts = FavoriteProduct.mr_findAll(in: localContext) as? [FavoriteProduct] {
                for favoriteProduct in allFavoriteProducts {
                    if let newsID = favoriteProduct.id, let index = favoriteIDs.index(of: newsID) {
                        favoriteProduct.dateFavorite = favoriteDates[newsID]
                        favoriteIDs.remove(at: index)
                    } else {
                        favoriteProduct.mr_deleteEntity(in: localContext)
                    }
                }
            }
            
            // Import all new product favorites
            for productID in favoriteIDs {
                let favoriteProduct = FavoriteProduct.mr_createEntity(in: localContext)
                favoriteProduct?.id = productID
                favoriteProduct?.dateFavorite = favoriteDates[productID]
            }
            
            // Completion
            completion?(nil, FmtError(0, nil))
        })
    }
}
