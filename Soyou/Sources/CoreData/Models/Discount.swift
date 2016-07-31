//
//  Discount.swift
//  Soyou
//
//  Created by CocoaBob on 26/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData

// For NSFetchedResultsController to distinguish FavoriteDiscount and Discount
// @NSManaged var appIsFavorite: NSNumber?

// To remember if the item is liked
// @NSManaged var appIsLiked: NSNumber?

// To mark if the item modification date is updated, needs to be updated
// @NSManaged var appIsUpdated: NSNumber?

class Discount: NSManagedObject {
    
    class func importData(data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (Discount?) {
        var discount: Discount? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            let request = Discount.MR_requestFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
            request.includesSubentities = false
            discount = Discount.MR_executeFetchRequestAndReturnFirstObject(request, inContext: context)
            if discount == nil {
                discount = Discount.MR_createEntityInContext(context)
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
    
    class func importDatas(datas: [NSDictionary]?, _ isOverridden: Bool, _ isComplete: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                if let completion = completion { completion(nil, FmtError(0, nil)) }
                return
            }
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                // Delete old data
                if isOverridden {
                    let request = Discount.MR_requestAllWithPredicate(FmtPredicate("1==1"), inContext: localContext)
                    request.includesSubentities = false
                    if let results = Discount.MR_executeFetchRequest(request, inContext: localContext) {
                        for discount in results {
                            discount.MR_deleteEntityInContext(localContext)
                        }
                    }
                }
                // Import new data
                for data in datas {
                    Discount.importData(data, isComplete, localContext)
                }
            }, completion: { (responseObject, error) -> Void in
                if let completion = completion { completion(responseObject, error) }
            })
        } else {
            if let completion = completion { completion(nil, FmtError(0, nil)) }
        }
    }
    
    // Favorite
    func relatedFavoriteDiscount(context: NSManagedObjectContext?) -> FavoriteDiscount? {
        if let newsID = self.id {
            if let context = context {
                return FavoriteDiscount.MR_findFirstByAttribute("id", withValue: newsID, inContext: context)
            } else {
                return FavoriteDiscount.MR_findFirstByAttribute("id", withValue: newsID)
            }
        }
        return nil
    }
    
    func isFavorite() -> Bool {
        var returnValue = false
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if self is FavoriteDiscount {
                returnValue = true
            } else {
                if let _ = self.MR_inContext(localContext)?.relatedFavoriteDiscount(localContext) {
                    returnValue = true
                }
            }
        })
        
        return returnValue
    }
    
    class func toggleFavorite(discountID: NSNumber, completion: DataClosure?) {
        // Find the favorite discount
        let favoriteDiscount: FavoriteDiscount? = FavoriteDiscount.MR_findFirstByAttribute("id", withValue: discountID)
        
        // Was favorite?
        let wasFavorite = favoriteDiscount != nil
        
        // Update local data only when response is received
        DataManager.shared.favoriteDiscount(discountID, wasFavorite: wasFavorite) { responseObject, error in
            if error != nil {
                return
            }
            
            self.updateFavorite(discountID, isFavorite: !wasFavorite)
            
            // Completion
            if let completion = completion {
                completion(responseObject)
            }
        }
    }
    
    // Create/Update FavoriteDiscount, or delete FavoriteDiscount
    class func updateFavorite(discountID: NSNumber, isFavorite: Bool) {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            let request = Discount.MR_requestFirstByAttribute("id", withValue: discountID, inContext: localContext)
            request.includesSubentities = false
            let originalDiscount: Discount? = Discount.MR_executeFetchRequestAndReturnFirstObject(request, inContext: localContext)
            let favoriteDiscount: FavoriteDiscount? = FavoriteDiscount.MR_findFirstByAttribute("id", withValue: discountID, inContext: localContext)
            var localFavoriteDiscount = favoriteDiscount?.MR_inContext(localContext)
            if isFavorite {
                if localFavoriteDiscount == nil {
                    localFavoriteDiscount = FavoriteDiscount.MR_createEntityInContext(localContext)
                    if let localDiscount = originalDiscount?.MR_inContext(localContext) {
                        localFavoriteDiscount?.id = localDiscount.id
                        localFavoriteDiscount?.author = localDiscount.author
                        localFavoriteDiscount?.title = localDiscount.title
                        localFavoriteDiscount?.coverImage = localDiscount.coverImage
                        localFavoriteDiscount?.publishdate = localDiscount.publishdate
                        localFavoriteDiscount?.dateModification = localDiscount.dateModification
                        
                        localFavoriteDiscount?.content = localDiscount.content
                        localFavoriteDiscount?.isOnline = localDiscount.isOnline
                        localFavoriteDiscount?.url = localDiscount.url
                        
                        localFavoriteDiscount?.appIsUpdated = localDiscount.appIsUpdated
                        localFavoriteDiscount?.appIsFavorite = NSNumber(bool: true)
                    }
                }
                localFavoriteDiscount?.dateFavorite = NSDate()
            } else {
                localFavoriteDiscount?.MR_deleteEntityInContext(localContext)
            }
        })
    }
}
