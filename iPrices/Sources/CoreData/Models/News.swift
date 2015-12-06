//
//  News.swift
//  iPrices
//
//  Created by CocoaBob on 18/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

import Foundation
import CoreData

class News: BaseModel {

    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext) -> (News?) {
        guard let data = data else {
            return nil
        }
        
        guard let id = data["id"] as? NSNumber else {
            return nil
        }
        
        var news: News? = News.MR_findFirstWithPredicate(FmtPredicate("id == %@ && (isMore == nil || isMore == false)", id), inContext: context)
        if news == nil {
            news = News.MR_createEntityInContext(context)
        }
        
        if let news = news {
            news.id = id
            if let value = data["datePublication"] as? String {
                news.datePublication = self.dateFormatter.dateFromString(value)
            }
            if let value = data["dateModification"] as? String {
                news.dateModification = self.dateFormatter.dateFromString(value)
            }
            if let value = data["author"] as? String {
                news.author = value
            }
            if let value = data["title"] as? String {
                news.title = value
            }
            if let value = data["image"] as? String {
                news.image = value
            }
            if let value = data["content"] as? String {
                news.content = value
            }
            if let value = data["author"] as? String {
                news.author = value
            }
            if let value = data["isOnline"] as? NSNumber {
                news.isOnline = value
            }
            if let value = data["url"] as? String {
                news.url = value
            }
        }
        
        return news
    }
    
    class func importDatas(datas: [NSDictionary]?, _ triggeredMoreItemID: NSNumber?) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                // Prepare data
                let newestNews = News.MR_findFirstOrderedByAttribute("datePublication", ascending: false, inContext: localContext)
                let moreItems = News.MR_findAllSortedBy("datePublication", ascending: false, withPredicate: FmtPredicate("isMore == true"), inContext: localContext)
                
                
                // Prepare sections
                var allSections = [NSDate]()
                if let newestNews = newestNews {
                    var lastBeginDate = newestNews.datePublication!
                    for i in 0..<moreItems.count {
                        let moreItem = moreItems[i] as! News
                        allSections += [lastBeginDate]
                        
                        // Find the news after the more button
                        if let newsAfterMoreItem = News.MR_findFirstWithPredicate(
                            FmtPredicate("datePublication < %@ && (isMore == nil || isMore == false)", moreItem.datePublication!),
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
                    let news = News.importData(data, localContext)
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
                            guard let _ = News.MR_findFirstWithPredicate(FmtPredicate("isMore == true && id == %@",oldestNewNews.id!), inContext: localContext) else {
                                let newMoreItem = News.MR_createEntityInContext(localContext)
                                newMoreItem.id = oldestNewNews.id
                                newMoreItem.datePublication = oldestNewNews.datePublication
                                newMoreItem.isMore = NSNumber(bool: true)
                                continue
                            }
                        }
                    }
                }
            })
        }
    }
    
}
