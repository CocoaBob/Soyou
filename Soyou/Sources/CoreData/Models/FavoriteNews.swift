//
//  FavoriteNews.swift
//  Soyou
//
//  Created by CocoaBob on 27/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class FavoriteNews: BaseNews {

    class func importData(data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (FavoriteNews?) {
        var news: FavoriteNews? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            news = FavoriteNews.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
            if news == nil {
                news = FavoriteNews.MR_createEntityInContext(context)
            }
            
            if let news = news {
                news.id = id
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
                for data in datas {
                    FavoriteNews.importData(data, isComplete, localContext)
                }
            })
        }
    }
    
    func relatedNews() -> News? {
        if let newsID = self.id {
            return News.MR_findFirstByAttribute("id", withValue: newsID)
        }
        return nil
    }

}
