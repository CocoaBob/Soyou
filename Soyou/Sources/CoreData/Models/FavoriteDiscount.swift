//
//  FavoriteDiscount.swift
//  Soyou
//
//  Created by CocoaBob on 25/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class FavoriteDiscount: Discount {
    
    override class func importData(data: NSDictionary?, _ context: NSManagedObjectContext?) -> (FavoriteDiscount?) {
        var favoriteDiscount: FavoriteDiscount? = nil
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            
            favoriteDiscount = FavoriteDiscount.MR_createEntityInContext(context)
            if let favoriteDiscount = favoriteDiscount {
                if let value = data["publishdate"] as? String {
                    favoriteDiscount.publishdate = Cons.utcDateFormatter.dateFromString(value)
                }
                if let value = data["dateModification"] as? String {
                    favoriteDiscount.dateModification = Cons.utcDateFormatter.dateFromString(value)
                }
                if let value = data["expireDate"] as? String {
                    favoriteDiscount.expireDate = Cons.utcDateFormatter.dateFromString(value)
                }
                favoriteDiscount.author = data["author"] as? String
                favoriteDiscount.content = data["content"] as? String
                favoriteDiscount.coverImage = data["coverImage"] as? String
                favoriteDiscount.id = data["id"] as? NSNumber
                favoriteDiscount.isOnline = data["isOnline"] as? NSNumber
                favoriteDiscount.title = data["title"] as? String
                favoriteDiscount.url = data["url"] as? String
            }
        }
        
        if let context = context {
            importDataClosure(context)
        } else {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                importDataClosure(localContext)
            })
        }
        
        return favoriteDiscount
    }
    
    override class func importDatas(datas: [NSDictionary]?, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                if let completion = completion { completion(nil, FmtError(0, nil)) }
                return
            }
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                // Delete old data
                FavoriteDiscount.MR_deleteAllMatchingPredicate(FmtPredicate("1==1"), inContext: localContext)
                // Import new data
                for data in datas {
                    FavoriteDiscount.importData(data, localContext)
                }
                }, completion: { (responseObject, error) -> Void in
                    if let completion = completion { completion(responseObject, error) }
            })
        } else {
            if let completion = completion { completion(nil, FmtError(0, nil)) }
        }
    }

}
