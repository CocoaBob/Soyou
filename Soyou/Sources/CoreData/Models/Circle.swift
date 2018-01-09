//
//  Circle.swift
//  Soyou
//
//  Created by CocoaBob on 02/01/18.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import CoreData

struct CircleVisibility {
    static let owner    = 1
    static let friends  = 2
    static let everyone = 4
}

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
            if let value = data["createdDate"] as? String {
                circle.createdDate = Cons.utcDateFormatter.date(from: value)
            }
            circle.id = data["id"] as? String
            circle.text = (data["text"] as? String)?.removingPercentEncoding
            circle.images = data["images"] as? NSArray
            circle.userId = data["userId"] as? NSNumber
            circle.username = (data["username"] as? String)?.removingPercentEncoding
            circle.visibility = data["visibility"] as? NSNumber
            circle.userProfileUrl = data["userProfileUrl"] as? String
            circle.comments = data["comments"] as? NSArray
            circle.likes = data["likes"] as? NSArray
        }
        
        return circle
    }
    
    class func importDatas(_ datas: [NSDictionary]?, _ deleteAll: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                completion?(nil, FmtError(0, nil))
                return
            }
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                // Delete old data
                if deleteAll {
                    // Delete non existing items
                    Circle.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
                }
                // Import new data
                for data in datas {
                    Circle.importData(data, localContext)
                }
            }, completion: { (responseObject, error) -> Void in
                completion?(responseObject, error as Error?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
    
    func delete(_ completion: (()->())?) {
        guard let circleID = self.id else {
            return
        }
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            let localCircle = self.mr_(in: localContext)
            localCircle?.mr_deleteEntity(in: localContext)
            completion?()
        })
    }
}
