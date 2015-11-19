//
//  News.swift
//  iPrices
//
//  Created by CocoaBob on 18/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

import Foundation
import CoreData


class News: NSManagedObject {
    
    static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    } ()

    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext) -> News? {
        guard let data = data else {
            return nil
        }
        
        guard let id = data["id"] as? NSNumber else {
            return nil
        }
        
        var news: News? = News.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
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
    
}
