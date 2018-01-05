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

class FavoriteNews: News {

    @discardableResult override class func importData(_ data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (FavoriteNews?) {
        var news: FavoriteNews? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            news = FavoriteNews.mr_findFirst(with: FmtPredicate("id == %@", id), in: context)
            if news == nil {
                news = FavoriteNews.mr_createEntity(in: context)
                news?.id = id as NSNumber
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
                news.appIsFavorite = NSNumber(value: true as Bool)
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
    
    override class func importDatas(_ datas: [NSDictionary]?, _ deleteAll: Bool, _ isComplete: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                completion?(nil, FmtError(0, nil))
                return
            }
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                // Import new data
                for data in datas {
                    FavoriteNews.importData(data, isComplete, localContext)
                }
                
                }, completion: { (responseObject, error) -> Void in
                    completion?(responseObject, error as NSError?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
    
    class func updateWithData(_ data: [NSDictionary], _ completion: CompletionClosure?) {
        // Create a dictionary of all favorite news
        var favoriteIDs = [Int]()
        var favoriteDates = [Int: Date]()
        for dict in data {
            if let newsID = dict["id"] as? Int, let dateModification = dict["dateModification"] as? String {
                favoriteIDs.append(newsID)
                favoriteDates[newsID] = Cons.utcDateFormatter.date(from: dateModification)
            }
        }
        
        MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
            // Filter all existing ones, delete remotely deleted ones.
            if let allFavoritesNews = FavoriteNews.mr_findAll(in: localContext) as? [FavoriteNews] {
                for favoriteNews in allFavoritesNews {
                    if let newsID = favoriteNews.id as? Int, let index = favoriteIDs.index(of: newsID) {
                        favoriteIDs.remove(at: index)
                    } else {
                        favoriteNews.mr_deleteEntity(in: localContext)
                    }
                }
            }
            
            // Request non-existing ones
            if !favoriteIDs.isEmpty {
                DataManager.shared.requestNews(favoriteIDs, { responseObject, error in
                    if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                        FavoriteNews.importDatas(data, false, false, { (responseObject, error) -> () in
                            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                                // Update favorite dates
                                if let allFavoritesNews = FavoriteNews.mr_findAll(in: localContext) as? [FavoriteNews] {
                                    for favoriteNews in allFavoritesNews {
                                        if let newsID = favoriteNews.id as? Int {
                                            favoriteNews.dateFavorite = favoriteDates[newsID]
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
            FavoriteNews.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
        })
    }
    
    func relatedNews(_ context: NSManagedObjectContext?) -> News? {
        if let newsID = self.id {
            if let context = context {
                let request = News.mr_requestFirst(with: FmtPredicate("id == %@", newsID), in: context)
                request.includesSubentities = false
                return News.mr_executeFetchRequestAndReturnFirstObject(request, in: context)
            } else {
                let request = News.mr_requestFirst(with: FmtPredicate("id == %@", newsID))
                request.includesSubentities = false
                return News.mr_executeFetchRequestAndReturnFirstObject(request)
            }
        }
        return nil
    }
}
