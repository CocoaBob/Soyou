//
//  FavoriteNews.swift
//  Soyou
//
//  Created by CocoaBob on 27/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData

// FavoriteNews must contains all the data of the original news to show the Favorites News list.
// Because we can't create the corresponding original news directly
// otherwise it's to complex to maintain the News list.

class FavoriteNews: BaseNews {

    class func importData(data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (FavoriteNews?) {
        var news: FavoriteNews? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            news = FavoriteNews.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
            if news == nil {
                news = FavoriteNews.MR_createEntityInContext(context)
                news?.id = id
            }
            
            if let news = news {
                if let value = data["datePublication"] as? String {
                    news.datePublication = Cons.utcDateFormatter.dateFromString(value)
                }
                if let value = data["dateModification"] as? String {
                    let newDateModification = Cons.utcDateFormatter.dateFromString(value)
                    if isComplete {
                        news.appIsUpdated = NSNumber(bool: true)
                    } else {
                        if newDateModification != news.dateModification {
                            news.appIsUpdated = NSNumber(bool: false) // Needs to be updated
                        }
                    }
                    news.dateModification = newDateModification
                }
                if !isComplete {
                    news.author = data["author"] as? String
                    news.title = data["title"] as? String
                    news.image = data["image"] as? String
                } else {
                    news.content = data["content"] as? String
                    news.isOnline = data["isOnline"] as? NSNumber
                    news.url = data["url"] as? String
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
        
        return news
    }
    
    class func importDatas(datas: [NSDictionary]?, _ isComplete: Bool, _ triggeredMoreItemID: NSNumber?, _ completion: CompletionClosure?) {
        if let datas = datas {
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                for data in datas {
                    FavoriteNews.importData(data, isComplete, localContext)
                }
                
                }, completion: { (responseObject, error) -> Void in
                    if let completion = completion { completion(responseObject, error) }
            })
        } else {
            if let completion = completion { completion(nil, FmtError(0, nil)) }
        }
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
            if let allFavoritesNews = FavoriteNews.MR_findAllInContext(localContext) as? [FavoriteNews] {
                for favoriteNews in allFavoritesNews {
                    if let newsID = favoriteNews.id, _ = favoriteIDs.indexOf(newsID) {
                    } else {
                        favoriteNews.MR_deleteEntityInContext(localContext)
                    }
                }
            }
            
            // Request non-existing ones
            if !favoriteIDs.isEmpty {
                DataManager.shared.requestNews(favoriteIDs, { responseObject, error in
                    if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                        FavoriteNews.importDatas(data, false, nil, { (responseObject, error) -> () in
                            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                                // Update favorite dates
                                if let allFavoritesNews = FavoriteNews.MR_findAllInContext(localContext) as? [FavoriteNews] {
                                    for favoriteNews in allFavoritesNews {
                                        if let newsID = favoriteNews.id {
                                            favoriteNews.dateFavorite = favoriteDates[newsID]
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
            FavoriteNews.MR_deleteAllMatchingPredicate(FmtPredicate("1==1"), inContext: localContext)
        })
    }
    
    func relatedNews(context: NSManagedObjectContext?) -> News? {
        if let newsID = self.id {
            if let context = context {
                return News.MR_findFirstByAttribute("id", withValue: newsID, inContext: context)
            } else {
                return News.MR_findFirstByAttribute("id", withValue: newsID)
            }
        }
        return nil
    }
}
