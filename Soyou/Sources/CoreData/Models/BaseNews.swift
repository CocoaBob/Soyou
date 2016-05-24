//
//  BaseNews.swift
//  Soyou
//
//  Created by CocoaBob on 27/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class BaseNews: NSManagedObject {
    
    func isFavorite() -> Bool {
        var returnValue = false
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if self is FavoriteNews {
                returnValue = true
            } else {
                if let news = self as? News, _ = news.MR_inContext(localContext)?.relatedFavoriteNews(localContext) {
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
                if let news = self as? News {
                    originalNews = news
                    favoriteNews = news.MR_inContext(localContext)?.relatedFavoriteNews(localContext)
                }
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
                    if let news = self as? News {
                        originalNews = news.MR_inContext(localContext)
                        favoriteNews = news.MR_inContext(localContext)?.relatedFavoriteNews(localContext)
                    }
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
