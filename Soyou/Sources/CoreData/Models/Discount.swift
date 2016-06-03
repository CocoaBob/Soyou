//
//  Discount.swift
//  Soyou
//
//  Created by CocoaBob on 26/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Discount: NSManagedObject {
    
    class func importData(data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (Discount?) {
        var discount: Discount? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }

            discount = Discount.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
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
    
    class func importDatas(datas: [NSDictionary]?, _ isComplete: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                if let completion = completion { completion(nil, FmtError(0, nil)) }
                return
            }
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                // Delete old data
                Discount.MR_deleteAllMatchingPredicate(FmtPredicate("1==1"), inContext: localContext)
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
        // Find the original discount and favorite discount
        let originalDiscount: Discount? = Discount.MR_findFirstByAttribute("id", withValue: discountID)
        let favoriteDiscount: FavoriteDiscount? = FavoriteDiscount.MR_findFirstByAttribute("id", withValue: discountID)
        
        // Was favorite?
        let wasFavorite = favoriteDiscount != nil
        
        // Update local data only when response is received
        DataManager.shared.favoriteDiscount(discountID, wasFavorite: wasFavorite) { responseObject, error in
            if error != nil {
                return
            }
            
            // Create/Update FavoriteDiscount, or delete FavoriteDiscount
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                var localFavoriteDiscount = favoriteDiscount?.MR_inContext(localContext)
                if wasFavorite {
                    localFavoriteDiscount?.MR_deleteEntityInContext(localContext)
                } else {
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
                            
                            localFavoriteDiscount?.appIsLiked = localDiscount.appIsLiked
                            localFavoriteDiscount?.appIsUpdated = localDiscount.appIsUpdated
                        }
                    }
                    localFavoriteDiscount?.dateFavorite = NSDate()
                }
            })
            
            // Completion
            if let completion = completion {
                completion(responseObject)
            }
        }
    }
    
    // Like
    func isLiked() -> Bool {
        var returnValue = false
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            // Find original discount and favorite discount
            var originalDiscount: Discount?
            var favoriteDiscount: FavoriteDiscount?
            if self is FavoriteDiscount {
                if let discount = self as? FavoriteDiscount {
                    favoriteDiscount = discount
                    originalDiscount = discount.MR_inContext(localContext)?.relatedDiscount(localContext)
                }
            } else {
                if let discount = self as? Discount {
                    originalDiscount = discount
                    favoriteDiscount = discount.MR_inContext(localContext)?.relatedFavoriteDiscount(localContext)
                }
            }
            
            // If any one of them is true, set both to true
            if let isLiked = originalDiscount?.appIsLiked {
                if isLiked.boolValue {
                    favoriteDiscount?.appIsLiked = isLiked
                    returnValue = true
                }
            }
            if let isLiked = favoriteDiscount?.appIsLiked {
                if isLiked.boolValue {
                    originalDiscount?.appIsLiked = isLiked
                    returnValue = true
                }
            }
        })
        return returnValue
    }
    
    func toggleLike(completion: DataClosure?) {
        var _wasLiked: Bool?
        var _discountID: NSNumber?
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            let localSelf = self.MR_inContext(localContext)
            _discountID = localSelf?.id
            _wasLiked = localSelf?.isLiked()
        })
        guard let wasLiked = _wasLiked else { return }
        guard let discountID = _discountID else { return }
        
        // Send request to server, then update local data after receving response
        DataManager.shared.likeDiscount(discountID, wasLiked: wasLiked) { responseObject, error in
            guard let responseObject = responseObject as? [String: AnyObject] else { return }
            guard let data = responseObject["data"] else { return }
            
            // Remember if it's liked or not
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                // Find original discount and favorite discount
                var originalDiscount: Discount?
                var favoriteDiscount: FavoriteDiscount?
                if self is FavoriteDiscount {
                    if let discount = self as? FavoriteDiscount {
                        favoriteDiscount = discount.MR_inContext(localContext)
                        originalDiscount = discount.MR_inContext(localContext)?.relatedDiscount(localContext)
                    }
                } else {
                    if let discount = self as? Discount {
                        originalDiscount = discount.MR_inContext(localContext)
                        favoriteDiscount = discount.MR_inContext(localContext)?.relatedFavoriteDiscount(localContext)
                    }
                }
                
                originalDiscount?.appIsLiked = NSNumber(bool: !wasLiked)
                favoriteDiscount?.appIsLiked = NSNumber(bool: !wasLiked)
            })
            
            if let completion = completion {
                completion(data)
            }
        }
    }
}
