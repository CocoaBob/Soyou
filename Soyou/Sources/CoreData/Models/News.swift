//
//  News.swift
//  Soyou
//
//  Created by CocoaBob on 18/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

import Foundation
import CoreData

// For NSFetchedResultsController to distinguish FavoriteNews and News
// @NSManaged var appIsFavorite: NSNumber?

// To remember if the item is liked
// @NSManaged var appIsLiked: NSNumber?

// To mark if the item modification date is updated, needs to be updated
// @NSManaged var appIsUpdated: NSNumber?

class News: NSManagedObject {

    @discardableResult class func importData(_ data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (News?) {
        var news: News? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            let request = News.mr_requestFirst(with: FmtPredicate("id == %@", id), in: context)
            request.includesSubentities = false
            news = News.mr_executeFetchRequestAndReturnFirstObject(request, in: context)
            if news == nil {
                news = News.mr_createEntity(in: context)
                news?.id = id
            }
            
            if let news = news {
                if let value = data["datePublication"] as? String {
                    news.datePublication = Cons.utcDateFormatter.date(from: value)
                }
                if let value = data["dateModification"] as? String {
                    let newDateModification = Cons.utcDateFormatter.date(from: value)
                    if isComplete {
                        news.appIsUpdated = NSNumber(value: true as Bool)
                    } else {
                        if newDateModification != news.dateModification {
                            news.appIsUpdated = NSNumber(value: false as Bool) // Needs to be updated
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
            MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                importDataClosure(localContext)
            })
        }
        
        return news
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
                    let request = News.mr_requestAll(with: FmtPredicate("1==1"), in: localContext)
                    request.includesSubentities = false
                    if let results = News.mr_executeFetchRequest(request, in: localContext) {
                        for news in results {
                            news.mr_deleteEntity(in: localContext)
                        }
                    }
                }
                // Import new data
                for data in datas {
                    News.importData(data, isComplete, localContext)
                }
            }, completion: { (responseObject, error) -> Void in
                completion?(responseObject as AnyObject?, error as Error?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
    
    // Favorite
    func relatedFavoriteNews(_ context: NSManagedObjectContext?) -> FavoriteNews? {
        if let newsID = self.id {
            if let context = context {
                return FavoriteNews.mr_findFirst(byAttribute: "id", withValue: newsID, in: context)
            } else {
                return FavoriteNews.mr_findFirst(byAttribute: "id", withValue: newsID)
            }
        }
        return nil
    }
    
    func isFavorite() -> Bool {
        var returnValue = false
        
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            if self is FavoriteNews {
                returnValue = true
            } else {
                if let _ = self.mr_(in: localContext)?.relatedFavoriteNews(localContext) {
                    returnValue = true
                }
            }
        })
        
        return returnValue
    }
    
    class func toggleFavorite(_ newsID: Int, completion: DataClosure?) {
        // Find the favorite news
        let favoriteNews: FavoriteNews? = FavoriteNews.mr_findFirst(byAttribute: "id", withValue: newsID)
        
        // Was favorite?
        let wasFavorite = favoriteNews != nil
        
        // Update local data only when response is received
        DataManager.shared.favoriteNews(newsID, wasFavorite: wasFavorite) { responseObject, error in
            if error != nil {
                return
            }
            
            self.updateFavorite(newsID, isFavorite: !wasFavorite)
            
            // Completion
            completion?(responseObject)
        }
    }
    
    // Create/Update FavoriteNews, or delete FavoriteNews
    class func updateFavorite(_ newsID: Int, isFavorite: Bool) {
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            let request = News.mr_requestFirst(byAttribute: "id", withValue: newsID, in: localContext)
            request.includesSubentities = false
            let originalNews: News? = News.mr_executeFetchRequestAndReturnFirstObject(request, in: localContext)
            let favoriteNews: FavoriteNews? = FavoriteNews.mr_findFirst(byAttribute: "id", withValue: newsID, in: localContext)
            var localFavoriteNews = favoriteNews?.mr_(in: localContext)
            if isFavorite {
                if localFavoriteNews == nil {
                    localFavoriteNews = FavoriteNews.mr_createEntity(in: localContext)
                    if let localNews = originalNews?.mr_(in: localContext) {
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
                        localFavoriteNews?.appIsFavorite = NSNumber(value: true)
                    }
                }
                localFavoriteNews?.dateFavorite = Date()
            } else {
                localFavoriteNews?.mr_deleteEntity(in: localContext)
            }
        })
    }
    
    // Like
    func isLiked() -> Bool {
        var returnValue = false
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            // Find original news and favorite news
            var originalNews: News?
            var favoriteNews: FavoriteNews?
            if self is FavoriteNews {
                if let news = self as? FavoriteNews {
                    favoriteNews = news
                    originalNews = news.mr_(in: localContext)?.relatedNews(localContext)
                }
            } else {
                originalNews = self
                favoriteNews = self.mr_(in: localContext)?.relatedFavoriteNews(localContext)
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
    
    func toggleLike(_ completion: DataClosure?) {
        var _wasLiked: Bool?
        var _newsID: Int?
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            let localSelf = self.mr_(in: localContext)
            _newsID = localSelf?.id as? Int
            _wasLiked = localSelf?.isLiked()
        })
        guard let wasLiked = _wasLiked else { return }
        guard let newsID = _newsID else { return }
        
        // Send request to server, then update local data after receving response
        DataManager.shared.likeNews(newsID, wasLiked: wasLiked) { responseObject, error in
            guard let responseObject = responseObject as? [String: AnyObject] else { return }
            guard let data = responseObject["data"] else { return }
            
            // Remember if it's liked or not
            MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                // Find original news and favorite news
                var originalNews: News?
                var favoriteNews: FavoriteNews?
                if self is FavoriteNews {
                    if let news = self as? FavoriteNews {
                        favoriteNews = news.mr_(in: localContext)
                        originalNews = news.mr_(in: localContext)?.relatedNews(localContext)
                    }
                } else {
                    originalNews = self.mr_(in: localContext)
                    favoriteNews = self.mr_(in: localContext)?.relatedFavoriteNews(localContext)
                }
                
                originalNews?.appIsLiked = NSNumber(value: !wasLiked)
                favoriteNews?.appIsLiked = NSNumber(value: !wasLiked)
                favoriteNews?.appIsFavorite = NSNumber(value: true)
            })
            
            completion?(data)
        }
    }
}
