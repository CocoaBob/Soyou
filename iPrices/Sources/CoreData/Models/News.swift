//
//  News.swift
//  iPrices
//
//  Created by CocoaBob on 18/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

import Foundation
import CoreData

enum NewsIsMore: Int {
    case False = 0, True, Loading
}

class News: NSManagedObject {
    
    static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    } ()

    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext) -> (News?) {
        guard let data = data else {
            return nil
        }
        
        guard let id = data["id"] as? NSNumber else {
            return nil
        }
        
        var news: News? = News.MR_findFirstWithPredicate(FmtPredicate("id == %@ && (isMore == nil || isMore == %@)", id, NSNumber(integer: NewsIsMore.False.rawValue)), inContext: context)
        if news == nil {
            news = News.MR_createEntityInContext(context)
        }
        
        if let news = news {
            news.id = NSNumber(int: id.intValue)
            if let datePublication = data["datePublication"] as? String {
                news.datePublication = News.dateFormatter.dateFromString(datePublication)
            }
            if let dateModification = data["dateModification"] as? String {
                news.dateModification = News.dateFormatter.dateFromString(dateModification)
            }
            if let author = data["author"] as? String {
                news.author = author
            }
            if let title = data["title"] as? String {
                news.title = title
            }
            if let image = data["image"] as? String {
                news.image = image
            }
            if let version = data["version"] as? String {
                news.version = version
            }
            if let content = data["content"] as? String {
                news.content = content
            }
            if let author = data["author"] as? String {
                news.author = author
            }
            if let isOnline = data["isOnline"] as? String {
                news.isOnline = Int(isOnline)
            }
            if let url = data["url"] as? String {
                news.url = url
            }
        }
        
        return news
    }
    
    class func importDatas(datas: [NSDictionary]?) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                // Prepare data
                let lastMoreItem = News.MR_findFirstWithPredicate(FmtPredicate("isMore != nil && isMore != %@", NSNumber(integer: NewsIsMore.False.rawValue)), inContext: localContext);
                var firstNewsOlderThanMore: News? = nil;
                if let lastMoreItem = lastMoreItem {
                    firstNewsOlderThanMore = News.MR_findFirstWithPredicate(FmtPredicate("datePublication < %@", lastMoreItem.datePublication!), sortedBy: "datePublication", ascending: false, inContext: localContext)
                }
                let lastNewestNews = News.MR_findFirstOrderedByAttribute("datePublication", ascending: false, inContext: localContext)
                
                // Import new datas
                var oldestNewNews: News? = nil
                var newestNewNews: News? = nil
                
                for data in datas {
                    let news = News.importData(data, localContext)
                    
                    // The 1st and last new news
                    if let news = news {
                        if oldestNewNews == nil || news.datePublication! < oldestNewNews!.datePublication! {
                            oldestNewNews = news;
                        }
                        if newestNewNews == nil || news.datePublication! > newestNewNews!.datePublication! {
                            newestNewNews = news;
                        }
                    }
                }
                
                // Update the more item
                if let oldestNewNews = oldestNewNews, let newestNewNews = newestNewNews, let lastNewestNews = lastNewestNews {
                    // [Old][New]
                    // [Old[New]Old]
                    // Change nothing
                    
                    // [New[]Old]
                    if let lastMoreItem = lastMoreItem {
                        if (oldestNewNews.datePublication! < lastMoreItem.datePublication! &&
                            newestNewNews.datePublication! > lastMoreItem.datePublication!) {
                                lastMoreItem.MR_deleteEntityInContext(localContext)
                                return
                        }
                    }
                    
                    let createMoreItem: (News)->() = {(news: News) in
                        let newMoreItem = News.MR_createEntityInContext(localContext)
                        newMoreItem.id = news.id
                        newMoreItem.datePublication = NSDate(timeIntervalSince1970: (news.datePublication!.timeIntervalSince1970-1.0))
                        newMoreItem.isMore = NSNumber(integer: NewsIsMore.True.rawValue)
                    }
                    
                    // [New][More][Old]
                    if (oldestNewNews.datePublication! > lastNewestNews.datePublication!) {
                        createMoreItem(oldestNewNews)
                    }
                    // [Old][New][More][Old]
                    if let firstNewsAfterMore = firstNewsOlderThanMore {
                        if (oldestNewNews.datePublication! > firstNewsAfterMore.datePublication!) {
                            if lastMoreItem.id != oldestNewNews.id {
                                lastMoreItem.MR_deleteEntityInContext(localContext)
                                createMoreItem(oldestNewNews)
                            }
                        }
                    }
                }
            })
        }
    }
    
}
