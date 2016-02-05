//
//  News.swift
//  Soyou
//
//  Created by CocoaBob on 18/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

import Foundation
import CoreData

class News: BaseNews {

    class func importData(data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (News?) {
        var news: News? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            news = News.MR_findFirstWithPredicate(FmtPredicate("id == %@ && (appIsMore == nil || appIsMore == false)", id), inContext: context)
            if news == nil {
                news = News.MR_createEntityInContext(context)
                news?.id = id
            }
            
            if let news = news {
                if let value = data["datePublication"] as? String {
                    news.datePublication = self.dateFormatter.dateFromString(value)
                }
                if let value = data["dateModification"] as? String {
                    let newDateModification = self.dateFormatter.dateFromString(value)
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
    
    class func importDatas(datas: [NSDictionary]?, _ isComplete: Bool, _ triggeredMoreItemID: NSNumber?) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                // Prepare data
                let newestNews = News.MR_findFirstOrderedByAttribute("datePublication", ascending: false, inContext: localContext)
                let moreItems = News.MR_findAllSortedBy("datePublication", ascending: false, withPredicate: FmtPredicate("appIsMore == true"), inContext: localContext) ?? []
                
                
                // Prepare sections
                var allSections = [NSDate]()
                if let newestNews = newestNews {
                    var lastBeginDate = newestNews.datePublication!
                    for i in 0..<moreItems.count {
                        let moreItem = moreItems[i] as! News
                        allSections += [lastBeginDate]
                        
                        // Find the news after the more button
                        if let newsAfterMoreItem = News.MR_findFirstWithPredicate(
                            FmtPredicate("datePublication < %@ && (appIsMore == nil || appIsMore == false)", moreItem.datePublication!),
                            sortedBy: "datePublication",
                            ascending: false,
                            inContext: localContext)
                        {
                            lastBeginDate = newsAfterMoreItem.datePublication!;
                        }
                        
                        // Check if we should remove the more button
                        if triggeredMoreItemID == moreItem.id {
                            moreItem.MR_deleteEntityInContext(localContext)
                        }
                    }
                    allSections += [lastBeginDate]
                }
                
                // Import new datas
                var oldestNewNews: News? = nil
                
                for data in datas {
                    let news = News.importData(data, isComplete, localContext)
                    // The 1st and last new news
                    if let news = news {
                        if oldestNewNews == nil || news.datePublication! < oldestNewNews!.datePublication! {
                            oldestNewNews = news;
                        }
                    }
                }
                
                // Update the more item
                if let oldestNewNews = oldestNewNews {
                    for i in 0..<allSections.count {
                        let sectionDate = allSections[i]
                        // [New]?[Old]
                        if (oldestNewNews.datePublication! > sectionDate) {
                            // Check if a more button already exists
                            guard let _ = News.MR_findFirstWithPredicate(FmtPredicate("appIsMore == true && id == %@",oldestNewNews.id!), inContext: localContext) else {
                                if let newMoreItem = News.MR_createEntityInContext(localContext) {
                                    newMoreItem.id = oldestNewNews.id
                                    newMoreItem.datePublication = oldestNewNews.datePublication
                                    newMoreItem.appIsMore = NSNumber(bool: true)
                                }
                                continue
                            }
                        }
                    }
                }
            })
        }
    }
    
    func relatedFavoriteNews() -> FavoriteNews? {
        if let newsID = self.id {
            return FavoriteNews.MR_findFirstByAttribute("id", withValue: newsID)
        }
        return nil
    }
    
}
