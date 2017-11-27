//
//  Analytic.swift
//  Soyou
//
//  Created by chenglian on 16/1/4.
//  Copyright © 2016年 Soyou. All rights reserved.
//


import Foundation
import CoreData


class Analytic: NSManagedObject {
    
    
    @discardableResult class func importData(_ data: NSDictionary?, _ context: NSManagedObjectContext) -> (Analytic?) {
        guard let data = data else {
            return nil
        }
        
        guard let id = data["id"] as? NSNumber else {
            return nil
        }
        
        var analytic: Analytic? = Analytic.mr_findFirst(with: FmtPredicate("id == %@", id), in: context)
        if analytic == nil {
            analytic = Analytic.mr_createEntity(in: context)
            analytic?.id = id
        }

        if let analytic = analytic {
            analytic.data = data["data"] as? String
            analytic.target = data["target"] as? NSNumber
            analytic.action = data["action"] as? NSNumber
            analytic.operatedAt = data["operatedAt"] as? Date
        }
        
        return analytic
    }
    
    class func importDatas(_ datas: [NSDictionary]?, _ deleteNonExisting: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                completion?(nil, FmtError(0, nil))
                return
            }
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                var ids = [NSNumber]()
                
                // Import new data
                for data in datas {
                    if let analytic = Analytic.importData(data, localContext) {
                        ids.append(analytic.id!)
                    }
                }
                
                // Delete non existing items
                Analytic.mr_deleteAll(matching: FmtPredicate("NOT (id IN %@)", ids), in: localContext)
                
                }, completion: { (responseObject, error) -> Void in
                    completion?(responseObject, error as NSError?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
}
