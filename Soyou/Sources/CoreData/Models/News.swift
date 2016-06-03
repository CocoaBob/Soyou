//
//  News.swift
//  Soyou
//
//  Created by CocoaBob on 18/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

import Foundation
import CoreData

class News: NSManagedObject {

    class func importData(data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (News?) {
        var news: News? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            news = News.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
            if news == nil {
                news = News.MR_createEntityInContext(context)
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
                    News.MR_deleteAllMatchingPredicate(FmtPredicate("1==1"), inContext: localContext)
                }
                // Import new data
                for data in datas {
                    News.importData(data, isComplete, localContext)
                }
            }, completion: { (responseObject, error) -> Void in
                if let completion = completion { completion(responseObject, error) }
            })
        } else {
            if let completion = completion { completion(nil, FmtError(0, nil)) }
        }
    }
    
    // Favorite
    func relatedFavoriteNews(context: NSManagedObjectContext?) -> FavoriteNews? {
        if let newsID = self.id {
            if let context = context {
                return FavoriteNews.MR_findFirstByAttribute("id", withValue: newsID, inContext: context)
            } else {
                return FavoriteNews.MR_findFirstByAttribute("id", withValue: newsID)
            }
        }
        return nil
    }
    
    func isFavorite() -> Bool {
        var returnValue = false
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if self is FavoriteNews {
                returnValue = true
            } else {
                if let _ = self.MR_inContext(localContext)?.relatedFavoriteNews(localContext) {
                    returnValue = true
                }
            }
        })
        
        return returnValue
    }
    
    class func toggleFavorite(newsID: NSNumber, completion: DataClosure?) {
        // Find the original news and favorite news
        let originalNews: News? = News.MR_findFirstByAttribute("id", withValue: newsID)
        let favoriteNews: FavoriteNews? = FavoriteNews.MR_findFirstByAttribute("id", withValue: newsID)
        
        // Was favorite?
        let wasFavorite = favoriteNews != nil
        
        // Update local data only when response is received
        DataManager.shared.favoriteNews(newsID, wasFavorite: wasFavorite) { responseObject, error in
            if error != nil {
                return
            }
            
            // Create/Update FavoriteNews, or delete FavoriteNews
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                var localFavoriteNews = favoriteNews?.MR_inContext(localContext)
                if wasFavorite {
                    localFavoriteNews?.MR_deleteEntityInContext(localContext)
                } else {
                    if localFavoriteNews == nil {
                        localFavoriteNews = FavoriteNews.MR_createEntityInContext(localContext)
                        if let localNews = originalNews?.MR_inContext(localContext) {
                            localFavoriteNews?.id = localNews.id
                            localFavoriteNews?.author = localNews.author
                            localFavoriteNews?.title = localNews.title
                            localFavoriteNews?.image = localNews.image
                            localFavoriteNews?.datePublication = localNews.datePublication
                            localFavoriteNews?.dateModification = localNews.dateModification
                            
                            localFavoriteNews?.content = localNews.content
                            localFavoriteNews?.isOnline = localNews.isOnline
                            localFavoriteNews?.url = localNews.url
                            
                            localFavoriteNews?.appIsLiked = localNews.appIsLiked
                            localFavoriteNews?.appIsUpdated = localNews.appIsUpdated
                        }
                    }
                    localFavoriteNews?.dateFavorite = NSDate()
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
            // Find original news and favorite news
            var originalNews: News?
            var favoriteNews: FavoriteNews?
            if self is FavoriteNews {
                if let news = self as? FavoriteNews {
                    favoriteNews = news
                    originalNews = news.MR_inContext(localContext)?.relatedNews(localContext)
                }
            } else {
                originalNews = self
                favoriteNews = self.MR_inContext(localContext)?.relatedFavoriteNews(localContext)
            }
            
            // If any one of them is true, set both to true
            if let isLiked = originalNews?.appIsLiked {
                if isLiked.boolValue {
                    favoriteNews?.appIsLiked = isLiked
                    returnValue = true
                }
            }
            if let isLiked = favoriteNews?.appIsLiked {
                if isLiked.boolValue {
                    originalNews?.appIsLiked = isLiked
                    returnValue = true
                }
            }
        })
        return returnValue
    }
    
    func toggleLike(completion: DataClosure?) {
        var _wasLiked: Bool?
        var _newsID: NSNumber?
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            let localSelf = self.MR_inContext(localContext)
            _newsID = localSelf?.id
            _wasLiked = localSelf?.isLiked()
        })
        guard let wasLiked = _wasLiked else { return }
        guard let newsID = _newsID else { return }
        
        // Send request to server, then update local data after receving response
        DataManager.shared.likeNews(newsID, wasLiked: wasLiked) { responseObject, error in
            guard let responseObject = responseObject as? [String: AnyObject] else { return }
            guard let data = responseObject["data"] else { return }
            
            // Remember if it's liked or not
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                // Find original news and favorite news
                var originalNews: News?
                var favoriteNews: FavoriteNews?
                if self is FavoriteNews {
                    if let news = self as? FavoriteNews {
                        favoriteNews = news.MR_inContext(localContext)
                        originalNews = news.MR_inContext(localContext)?.relatedNews(localContext)
                    }
                } else {
                    originalNews = self.MR_inContext(localContext)
                    favoriteNews = self.MR_inContext(localContext)?.relatedFavoriteNews(localContext)
                }
                
                originalNews?.appIsLiked = NSNumber(bool: !wasLiked)
                favoriteNews?.appIsLiked = NSNumber(bool: !wasLiked)
            })
            
            if let completion = completion {
                completion(data)
            }
        }
    }
}
