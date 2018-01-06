//
//  Region.swift
//  Soyou
//
//  Created by CocoaBob on 29/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Region: NSManagedObject {
    
    @discardableResult class func importData(_ data: NSDictionary?, _ index: Int, _ context: NSManagedObjectContext?) -> (Region?) {
        var region: Region? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            
            region = Region.mr_createEntity(in: context)
            if let region = region {
                region.appOrder = NSNumber(value: index as Int)
                region.code = data["code"] as? String
                region.currency = data["currency"] as? String
            }
        }
        
        if let context = context {
            importDataClosure(context)
        } else {
            MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) -> Void in
                importDataClosure(localContext)
            })
        }
        
        return region
    }
    
    class func importDatas(_ datas: [NSDictionary]?, _ completion: CompletionClosure?) {
        if let datas = datas {
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) -> Void in
                // Delete all regions
                Region.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
                
                // Save new regions in order
                for (index, data) in datas.enumerated() {
                    Region.importData(data, index, localContext)
                }
                
                }, completion: { (responseObject, error) -> Void in
                    completion?(responseObject as AnyObject?, error as Error?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
}
