//
//  Store.swift
//  iPrices
//
//  Created by CocoaBob on 29/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

import Foundation
import CoreData


class Store: BaseModel {
    
    class func importData(data: NSDictionary?, _ isComplete: Bool, _ context: NSManagedObjectContext?) -> (Store?) {
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
                if let value = data["dateModification"] as? String {
                    let newDateModification = self.dateFormatter.dateFromString(value)
                    if isComplete {
                        store.appIsUpdated = NSNumber(bool: true)
                    } else {
                        if newDateModification != store.dateModification {
                            store.appIsUpdated = NSNumber(bool: false) // Needs to be updated
                        }
                    }
                    store.dateModification = newDateModification
                }
                if let value = data["title"] as? String {
                    store.title = value
                }
                if let value = data["division"] as? String {
                    store.division = value
                }
                if let value = data["address"] as? String {
                    store.address = value
                }
                if let value = data["zipcode"] as? String {
                    store.zipcode = value
                }
                if let value = data["city"] as? String {
                    store.city = value
                }
                if let value = data["country"] as? String {
                    store.country = value
                }
                if let value = data["phoneNumber"] as? String {
                    store.phoneNumber = value
                }
                if let value = data["longitude"] as? NSNumber {
                    store.longitude = value
                }
                if let value = data["latitude"] as? NSNumber {
                    store.latitude = value
                }
                if let value = data["brandId"] as? NSNumber {
                    store.brandId = value
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
    
    class func importDatas(datas: [NSDictionary]?, _ isComplete: Bool, _ triggeredMoreItemID: NSNumber?) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                for data in datas {
                    Store.importData(data, isComplete, localContext)
                }
            })
        }
    }
}
