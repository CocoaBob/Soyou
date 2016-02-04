//
//  Region.swift
//  Soyou
//
//  Created by CocoaBob on 29/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Region: BaseModel {
    
    class func importData(data: NSDictionary?, _ index: Int, _ context: NSManagedObjectContext?) -> (Region?) {
        var region: Region? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            
            region = Region.MR_createEntityInContext(context)
            if let region = region {
                region.appOrder = NSNumber(integer: index)
                if let value = data["code"] as? String {
                    region.code = value
                } else {
                    region.code = nil
                }
                if let value = data["currency"] as? String {
                    region.currency = value
                } else {
                    region.currency = nil
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
                // Delete all regions
                if let regions = Region.MR_findAllInContext(localContext) as? [Region] {
                    for region in regions {
                        region.MR_deleteEntityInContext(localContext)
                    }
                }
                // Save new regions in order
                for (index, data) in datas.enumerate() {
                    Region.importData(data, index, localContext)
                }
            })
        }
    }
}
