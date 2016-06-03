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
    
    override class func importData(data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (FavoriteDiscount?) {
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
    
    override class func importDatas(datas: [NSDictionary]?, _ isOverridden: Bool, _ isComplete: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                if let completion = completion { completion(nil, FmtError(0, nil)) }
                return
            }
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                // Import new data
                for data in datas {
                    FavoriteDiscount.importData(data, isComplete, localContext)
                }
            }, completion: { (responseObject, error) -> Void in
                if let completion = completion { completion(responseObject, error) }
            })
        } else {
            if let completion = completion { completion(nil, FmtError(0, nil)) }
        }
    }
    
    class func updateWithData(data: [NSDictionary], _ completion: CompletionClosure?) {
        // Create a dictionary of all favorite discounts
        var favoriteIDs = [NSNumber]()
        var favoriteDates = [NSNumber: NSDate]()
        for dict in data {
            if let discountID = dict["id"] as? NSNumber, dateModification = dict["dateModification"] as? String {
                favoriteIDs.append(discountID)
                favoriteDates[discountID] = Cons.utcDateFormatter.dateFromString(dateModification)
            }
        }
        
        MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
            // Filter all existing ones, delete remotely deleted ones.
            if let allFavoritesDiscounts = FavoriteDiscount.MR_findAllInContext(localContext) as? [FavoriteDiscount] {
                for favoriteDiscount in allFavoritesDiscounts {
                    if let discountID = favoriteDiscount.id, index = favoriteIDs.indexOf(discountID) {
                        favoriteIDs.removeAtIndex(index)
                    } else {
                        favoriteDiscount.MR_deleteEntityInContext(localContext)
                    }
                }
            }
            
            // Request non-existing ones
            if !favoriteIDs.isEmpty {
                DataManager.shared.requestDiscounts(favoriteIDs, { responseObject, error in
                    if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                        FavoriteDiscount.importDatas(data, false, false, { (responseObject, error) -> () in
                            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                                // Update favorite dates
                                if let allFavoritesDiscounts = FavoriteDiscount.MR_findAllInContext(localContext) as? [FavoriteDiscount] {
                                    for favoriteDiscount in allFavoritesDiscounts {
                                        if let discountID = favoriteDiscount.id {
                                            favoriteDiscount.dateFavorite = favoriteDates[discountID]
                                        }
                                    }
                                }
                                if let completion = completion { completion(responseObject, error) }
                            })
                        })
                    } else {
                        if let completion = completion { completion(nil, FmtError(0, nil)) }
                    }
                })
            } else {
                if let completion = completion { completion(nil, FmtError(0, nil)) }
            }
        })
    }
    
    class func deleteAll() {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            FavoriteDiscount.MR_deleteAllMatchingPredicate(FmtPredicate("1==1"), inContext: localContext)
        })
    }
    
    func relatedDiscount(context: NSManagedObjectContext?) -> Discount? {
        if let dicsountID = self.id {
            if let context = context {
                return Discount.MR_findFirstByAttribute("id", withValue: dicsountID, inContext: context)
            } else {
                return Discount.MR_findFirstByAttribute("id", withValue: dicsountID)
            }
        }
        return nil
    }

}
