//
//  Store.swift
//  Soyou
//
//  Created by CocoaBob on 29/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Store: BaseModel {
    
    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext?) -> (Store?) {
        var store: Store? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            store = Store.MR_findFirstWithPredicate(FmtPredicate("id == %@", id), inContext: context)
            if store == nil {
                store = Store.MR_createEntityInContext(context)
            }
            
            if let store = store {
                store.id = id
                if let value = data["title"] as? String {
                    store.title = value
                } else {
                    store.title = nil
                }
                if let value = data["division"] as? String {
                    store.division = value
                } else {
                    store.division = nil
                }
                if let value = data["address"] as? String {
                    store.address = value
                } else {
                    store.address = nil
                }
                if let value = data["zipcode"] as? String {
                    store.zipcode = value
                } else {
                    store.zipcode = nil
                }
                if let value = data["city"] as? String {
                    store.city = value
                } else {
                    store.city = nil
                }
                if let value = data["country"] as? String {
                    store.country = value
                } else {
                    store.country = nil
                }
                if let value = data["phoneNumber"] as? String {
                    store.phoneNumber = value
                } else {
                    store.phoneNumber = nil
                }
                if let value = data["brandId"] as? NSNumber {
                    store.brandId = value
                } else {
                    store.brandId = nil
                }
                if let longitude = data["longitude"] as? NSNumber,
                    latitude = data["latitude"] as? NSNumber {
                        store.longitude = longitude
                        store.latitude = latitude
                } else {
                    store.MR_deleteEntityInContext(context)
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
        
        return store
    }
    
    class func importDatas(datas: [NSDictionary]?) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                for data in datas {
                    Store.importData(data, localContext)
                }
            })
        }
    }
}
