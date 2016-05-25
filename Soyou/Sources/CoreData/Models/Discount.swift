//
//  Discount.swift
//  Soyou
//
//  Created by CocoaBob on 26/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Discount: NSManagedObject {
    
    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext?) -> (Discount?) {
        var discount: Discount? = nil
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }

            discount = Discount.MR_createEntityInContext(context)
            if let discount = discount {
                if let value = data["publishdate"] as? String {
                    discount.publishdate = Cons.utcDateFormatter.dateFromString(value)
                }
                if let value = data["dateModification"] as? String {
                    discount.dateModification = Cons.utcDateFormatter.dateFromString(value)
                }
                if let value = data["expireDate"] as? String {
                    discount.expireDate = Cons.utcDateFormatter.dateFromString(value)
                }
                discount.author = data["author"] as? String
                discount.content = data["content"] as? String
                discount.coverImage = data["coverImage"] as? String
                discount.id = data["id"] as? NSNumber
                discount.isOnline = data["isOnline"] as? NSNumber
                discount.title = data["title"] as? String
                discount.url = data["url"] as? String
            }
        }
        
        if let context = context {
            importDataClosure(context)
        } else {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                importDataClosure(localContext)
            })
        }
        
        return discount
    }
    
    class func importDatas(datas: [NSDictionary]?, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                if let completion = completion { completion(nil, FmtError(0, nil)) }
                return
            }
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                // Delete old data
                Discount.MR_deleteAllMatchingPredicate(FmtPredicate("1==1"), inContext: localContext)
                // Import new data
                for data in datas {
                    Discount.importData(data, localContext)
                }
            }, completion: { (responseObject, error) -> Void in
                if let completion = completion { completion(responseObject, error) }
            })
        } else {
            if let completion = completion { completion(nil, FmtError(0, nil)) }
        }
    }
}
