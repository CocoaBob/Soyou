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
    
    @discardableResult class func importData(_ data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (Discount?) {
        var discount: Discount? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            let request = Discount.mr_requestFirst(with: FmtPredicate("id == %@", id), in: context)
            request.includesSubentities = false
            discount = Discount.mr_executeFetchRequestAndReturnFirstObject(request, in: context)
            if discount == nil {
                discount = Discount.mr_createEntity(in: context)
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
    
    class func importDatas(_ datas: [NSDictionary]?, _ deleteAll: Bool, _ isComplete: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                completion?(nil, FmtError(0, nil))
                return
            }
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                // Delete old data
                if deleteAll {
                    let request = Discount.mr_requestAll(with: FmtPredicate("1==1"), in: localContext)
                    request.includesSubentities = false
                    if let results = Discount.mr_executeFetchRequest(request, in: localContext) {
                        for discount in results {
                            discount.mr_deleteEntity(in: localContext)
                        }
                    }
                }
                // Import new data
                for data in datas {
                    Discount.importData(data, isComplete, localContext)
                }
            }, completion: { (responseObject, error) -> Void in
                completion?(responseObject, error as Error?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
    
    // Favorite
    func relatedFavoriteDiscount(_ context: NSManagedObjectContext?) -> FavoriteDiscount? {
        if let newsID = self.id {
            if let context = context {
                return FavoriteDiscount.mr_findFirst(byAttribute: "id", withValue: newsID, in: context)
            } else {
                return FavoriteDiscount.mr_findFirst(byAttribute: "id", withValue: newsID)
            }
        }
        return nil
    }
    
    func isFavorite() -> Bool {
        var returnValue = false
        
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            if self is FavoriteDiscount {
                returnValue = true
            } else {
                if let _ = self.mr_(in: localContext)?.relatedFavoriteDiscount(localContext) {
                    returnValue = true
                }
            }
        })
        
        return returnValue
    }
    
    class func toggleFavorite(_ discountID: Int, completion: DataClosure?) {
        // Find the favorite discount
        let favoriteDiscount: FavoriteDiscount? = FavoriteDiscount.mr_findFirst(byAttribute: "id", withValue: discountID)
        
        // Was favorite?
        let wasFavorite = favoriteDiscount != nil
        
        // Update local data only when response is received
        DataManager.shared.favoriteDiscount(discountID, wasFavorite: wasFavorite) { responseObject, error in
            if error != nil {
                return
            }
            
            self.updateFavorite(discountID, isFavorite: !wasFavorite)
            
            // Completion
            completion?(responseObject)
        }
    }
    
    // Create/Update FavoriteDiscount, or delete FavoriteDiscount
    class func updateFavorite(_ discountID: Int, isFavorite: Bool) {
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            let request = Discount.mr_requestFirst(byAttribute: "id", withValue: discountID, in: localContext)
            request.includesSubentities = false
            let originalDiscount: Discount? = Discount.mr_executeFetchRequestAndReturnFirstObject(request, in: localContext)
            let favoriteDiscount: FavoriteDiscount? = FavoriteDiscount.mr_findFirst(byAttribute: "id", withValue: discountID, in: localContext)
            var localFavoriteDiscount = favoriteDiscount?.mr_(in: localContext)
            if isFavorite {
                if localFavoriteDiscount == nil {
                    localFavoriteDiscount = FavoriteDiscount.mr_createEntity(in: localContext)
                    if let localDiscount = originalDiscount?.mr_(in: localContext) {
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
                        localFavoriteDiscount?.appIsFavorite = NSNumber(value: true)
                    }
                }
                localFavoriteDiscount?.dateFavorite = Date()
            } else {
                localFavoriteDiscount?.mr_deleteEntity(in: localContext)
            }
        })
    }
}
