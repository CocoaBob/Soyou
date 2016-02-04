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
        }

        if let analytic = analytic {
            if let value = data["data"] as? String {
                analytic.data = value
            } else {
                analytic.data = nil
            }
            if let value = data["target"] as? NSNumber {
                analytic.target = value
            } else {
                analytic.target = nil
            }
            if let value = data["action"] as? NSNumber {
                analytic.action = value
            } else {
                analytic.action = nil
            }
            if let value = data["operatedAt"] as? NSDate {
                analytic.operatedAt = value
            } else {
                analytic.operatedAt = nil
            }
        }
        
        return analytic
    }
    
    class func importDatas(datas: [NSDictionary]?, _ deleteNonExisting: Bool) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
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
            })
        }
    }
}



