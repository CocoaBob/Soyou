//
//  Store.swift
//  Soyou
//
//  Created by CocoaBob on 29/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation
import CoreData


class Store: NSManagedObject {
    
    @discardableResult class func importData(_ data: NSDictionary?, _ context: NSManagedObjectContext?) -> (Store?) {
        var store: Store? = nil
        
        let importDataClosure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
            guard let data = data else { return }
            guard let id = data["id"] as? NSNumber else { return }
            
            store = Store.mr_findFirst(with: FmtPredicate("id == %@", id), in: context)
            if store == nil {
                store = Store.mr_createEntity(in: context)
                store?.id = id
            }
            
            if let store = store {
                store.title = data["title"] as? String
                store.division = data["division"] as? String
                store.address = data["address"] as? String
                store.zipcode = data["zipcode"] as? String
                store.city = data["city"] as? String
                store.country = data["country"] as? String
                store.phoneNumber = data["phoneNumber"] as? String
                store.brandId = data["brandId"] as? NSNumber
                if let longitude = data["longitude"] as? NSNumber,
                    let latitude = data["latitude"] as? NSNumber {
                        store.longitude = longitude
                        store.latitude = latitude
                } else {
                    store.mr_deleteEntity(in: context)
                }
            }
        }
        
        if let context = context {
            importDataClosure(context)
        } else {
            MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                importDataClosure(localContext)
            })
        }
        
        return store
    }
    
    class func importDatas(_ datas: [NSDictionary]?, _ completion: CompletionClosure?) {
        if let datas = datas {
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                for data in datas {
                    Store.importData(data, localContext)
                }
                
            }, completion: { (_, error) -> Void in
                completion?(nil, error as Error?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
}
