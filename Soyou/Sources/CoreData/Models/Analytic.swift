//
//  Analytic.swift
//  Soyou
//
//  Created by chenglian on 16/1/4.
//  Copyright © 2016年 Soyou. All rights reserved.
//


import Foundation
import CoreData


class Analytic: BaseModel {
    
    
    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext) -> (Analytic?) {
        guard let data = data else {
            return nil
        }
        
        guard let id = data["id"] as? NSNumber else {
            return nil
        }
        
        var analytic: Analytic? = Analytic.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
        if analytic == nil {
            analytic = Analytic.MR_createEntityInContext(context)
            analytic?.id = id
        }

        if let analytic = analytic {
            analytic.data = data["data"] as? String
            analytic.target = data["target"] as? NSNumber
            analytic.action = data["action"] as? NSNumber
            analytic.operatedAt = data["operatedAt"] as? NSDate
        }
        
        return analytic
    }
    
    class func importDatas(datas: [NSDictionary]?, _ deleteNonExisting: Bool, _ completion: CompletionClosure?) {
        if let datas = datas {
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                var ids = [NSNumber]()
                
                // Import new data
                for data in datas {
                    if let analytic = Analytic.importData(data, localContext) {
                        ids.append(analytic.id!)
                    }
                }
                
                // Delete non existing items
                if let analytics = Analytic.MR_findAllWithPredicate(FmtPredicate("NOT (id IN %@)", ids), inContext: localContext) {
                    for analytic in analytics {
                        analytic.MR_deleteEntityInContext(localContext)
                    }
                }
                
                }, completion: { (_, _) -> Void in
                    if let completion = completion { completion(nil, nil) }
            })
        }
    }
}



