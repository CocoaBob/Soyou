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
    
    @discardableResult override class func importData(_ data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (FavoriteDiscount?) {
        var discount: FavoriteDiscount? = nil
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            discount = FavoriteDiscount.mr_findFirst(with: FmtPredicate("id == %@", id), in: context)
            if discount == nil {
                discount = FavoriteDiscount.mr_createEntity(in: context)
                discount?.id = id
            }
            
            if let discount = discount {
                if let value = data["publishdate"] as? String {
                    discount.publishdate = Cons.utcDateFormatter.date(from: value)
                }
                if let value = data["dateModification"] as? String {
                    let newDateModification = Cons.utcDateFormatter.date(from: value)
                    if isComplete {
                        discount.appIsUpdated = NSNumber(value: true as Bool)
                    } else {
                        if newDateModification != discount.dateModification {
                            discount.appIsUpdated = NSNumber(value: false as Bool) // Needs to be updated
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
                    discount.expireDate = Cons.utcDateFormatter.date(from: value)
                }
                discount.appIsFavorite = NSNumber(value: true as Bool)
            }
        }
        
        if let context = context {
            importDataClosure(context)
        } else {
            MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                importDataClosure(localContext)
            })
        }
        
        return discount
    }
    
    override class func importDatas(_ datas: [NSDictionary]?, _ isOverridden: Bool, _ isComplete: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                completion?(nil, FmtError(0, nil))
                return
            }
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                // Import new data
                for data in datas {
                    FavoriteDiscount.importData(data, isComplete, localContext)
                }
            }, completion: { (responseObject, error) -> Void in
                completion?(responseObject, error as NSError?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
    
    class func updateWithData(_ data: [NSDictionary], _ completion: CompletionClosure?) {
        // Create a dictionary of all favorite discounts
        var favoriteIDs = [NSNumber]()
        var favoriteDates = [NSNumber: Date]()
        for dict in data {
            if let discountID = dict["id"] as? NSNumber, let dateModification = dict["dateModification"] as? String {
                favoriteIDs.append(discountID)
                favoriteDates[discountID] = Cons.utcDateFormatter.date(from: dateModification)
            }
        }
        
        MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
            // Filter all existing ones, delete remotely deleted ones.
            if let allFavoritesDiscounts = FavoriteDiscount.mr_findAll(in: localContext) as? [FavoriteDiscount] {
                for favoriteDiscount in allFavoritesDiscounts {
                    if let discountID = favoriteDiscount.id, let index = favoriteIDs.index(of: discountID) {
                        favoriteIDs.remove(at: index)
                    } else {
                        favoriteDiscount.mr_deleteEntity(in: localContext)
                    }
                }
            }
            
            // Request non-existing ones
            if !favoriteIDs.isEmpty {
                DataManager.shared.requestDiscounts(favoriteIDs, { responseObject, error in
                    if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                        FavoriteDiscount.importDatas(data, false, false, { (responseObject, error) -> () in
                            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                                // Update favorite dates
                                if let allFavoritesDiscounts = FavoriteDiscount.mr_findAll(in: localContext) as? [FavoriteDiscount] {
                                    for favoriteDiscount in allFavoritesDiscounts {
                                        if let discountID = favoriteDiscount.id {
                                            favoriteDiscount.dateFavorite = favoriteDates[discountID]
                                        }
                                    }
                                }
                                completion?(responseObject, error)
                            })
                        })
                    } else {
                        completion?(nil, FmtError(0, nil))
                    }
                })
            } else {
                completion?(nil, FmtError(0, nil))
            }
        })
    }
    
    class func deleteAll() {
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            FavoriteDiscount.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
        })
    }
    
    func relatedDiscount(_ context: NSManagedObjectContext?) -> Discount? {
        if let dicsountID = self.id {
            if let context = context {
                let request = Discount.mr_requestFirst(with: FmtPredicate("id == %@", dicsountID), in: context)
                request.includesSubentities = false
                return Discount.mr_executeFetchRequestAndReturnFirstObject(request, in: context)
            } else {
                let request = Discount.mr_requestFirst(with: FmtPredicate("id == %@", dicsountID))
                request.includesSubentities = false
                return Discount.mr_executeFetchRequestAndReturnFirstObject(request)
            }
        }
        return nil
    }

}
