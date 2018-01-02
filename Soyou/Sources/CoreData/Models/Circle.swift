//
//  Circle.swift
//  Soyou
//
//  Created by CocoaBob on 02/01/18.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Circle: NSManagedObject {

    
    @discardableResult class func importData(_ data: NSDictionary?, _ context: NSManagedObjectContext) -> (Circle?) {
        guard let data = data else {
            return nil
        }
        
        guard let id = data["id"] as? String else {
            return nil
        }
        
        var circle: Circle? = Circle.mr_findFirst(with: FmtPredicate("id == %@", id), in: context)
        if circle == nil {
            circle = Circle.mr_createEntity(in: context)
            circle?.id = id
        }
        
        if let circle = circle {
            circle.id = data["id"] as? String
            circle.text = data["text"] as? String
            circle.images = data["images"] as? NSObject
            circle.userId = data["userId"] as? NSNumber
            circle.createdDate = data["createdDate"] as? Date
            circle.visibility = data["visibility"] as? NSNumber
            circle.userProfileUrl = data["userProfileUrl"] as? String
            circle.comments = data["comments"] as? NSObject
            circle.likes = data["likes"] as? NSObject
        }
        
        return circle
    }
    
    class func importDatas(_ datas: [NSDictionary]?, _ deleteNonExisting: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                completion?(nil, FmtError(0, nil))
                return
            }
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                var ids = [String]()
                
                // Import new data
                for data in datas {
                    if let circle = Circle.importData(data, localContext) {
                        ids.append(circle.id!)
                    }
                }
                
                // Delete non existing items
                Circle.mr_deleteAll(matching: FmtPredicate("NOT (id IN %@)", ids), in: localContext)
                
            }, completion: { (responseObject, error) -> Void in
                completion?(responseObject, error as NSError?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
}
