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
    static let author    = 1
    static let friends  = 2
    static let everyone = 4
}

class Circle: NSManagedObject {
    
    class func deleteAll() {
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            Circle.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
        })
    }

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
            let text = data["text"] as? String
            circle.text = text?.removingPercentEncoding ?? text
            circle.images = data["images"] as? NSArray
            circle.userId = data["userId"] as? NSNumber
            let username = data["username"] as? String
            circle.username = username?.removingPercentEncoding ?? username
            circle.visibility = data["visibility"] as? NSNumber
            circle.userProfileUrl = data["userProfileUrl"] as? String
            circle.commentCount = data["commentCount"] as? NSNumber
            circle.likeCount = data["likeCount"] as? NSNumber
            circle.userBadges = data["userBadges"] as? NSArray
        }
        
        return circle
    }
    
    class func importDatas(_ datas: [NSDictionary]?, _ deleteAll: Bool, _ context: NSManagedObjectContext, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                completion?(nil, FmtError(0, nil))
                return
            }
            context.mr_save({ (localContext) in
                // Delete old data
                if deleteAll {
                    // Delete non existing items
                    Circle.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
                }
                // Import new data
                for data in datas {
                    Circle.importData(data, localContext)
                }
            }, completion: { (responseObject, error) in
                completion?(responseObject, error as Error?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
    
    func delete(_ completion: (()->())?) {
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            let localCircle = self.mr_(in: localContext)
            localCircle?.mr_deleteEntity(in: localContext)
            completion?()
        })
    }
}
