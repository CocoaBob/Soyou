//
//  Region.swift
//  iPrices
//
//  Created by CocoaBob on 29/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

import Foundation
import CoreData


class Region: BaseModel {
    
    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext?) -> (Region?) {
        var region: Region? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            region = Region.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
            if region == nil {
                region = Region.MR_createEntityInContext(context)
            }
            
            if let region = region {
                region.id = id
                if let value = data["code"] as? String {
                    region.code = value
                }
                if let value = data["currency"] as? String {
                    region.currency = value
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
        
        return region
    }
    
    class func importDatas(datas: [NSDictionary]?) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                for data in datas {
                    Region.importData(data, localContext)
                }
            })
        }
    }
}
