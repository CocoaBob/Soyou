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
        var discount: FavoriteDiscount? = nil
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            discount = FavoriteDiscount.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
            if discount == nil {
                discount = FavoriteDiscount.MR_createEntityInContext(context)
                discount?.id = id
            }
            
            if let discount = discount {
                if let value = data["publishdate"] as? String {
                    discount.publishdate = Cons.utcDateFormatter.dateFromString(value)
                }
                if let value = data["dateModification"] as? String {
                    let newDateModification = Cons.utcDateFormatter.dateFromString(value)
                    if isComplete {
                        discount.appIsUpdated = NSNumber(bool: true)
                    } else {
                        if newDateModification != discount.dateModification {
                            discount.appIsUpdated = NSNumber(bool: false) // Needs to be updated
                        }
                    }
                    discount.dateModification = newDateModification
                }
                if !isComplete {
                    discount.author = data["author"] as? String
                    discount.title = data["title"] as? String
                    discount.coverImage = data["coverImage"] as? String
                } else {
                    discount.content = data["content"] as? String
                    discount.isOnline = data["isOnline"] as? NSNumber
                    discount.url = data["url"] as? String
                }
                if let value = data["expireDate"] as? String {
                    discount.expireDate = Cons.utcDateFormatter.dateFromString(value)
                }
                discount.appIsFavorite = NSNumber(bool: true)
            }
        }
        
        if let context = context {
            importDataClosure(context)
        } else {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                importDataClosure(localContext)
            })
        }
        
        return discount
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
                let request = Discount.MR_requestFirstWithPredicate(FmtPredicate("id == %@", dicsountID), inContext: context)
                request.includesSubentities = false
                return Discount.MR_executeFetchRequestAndReturnFirstObject(request, inContext: context)
            } else {
                let request = Discount.MR_requestFirstWithPredicate(FmtPredicate("id == %@", dicsountID))
                request.includesSubentities = false
                return Discount.MR_executeFetchRequestAndReturnFirstObject(request)
            }
        }
        return nil
    }

}
