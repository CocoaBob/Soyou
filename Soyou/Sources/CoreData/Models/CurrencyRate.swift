//
//  CurrencyRate.swift
//  Soyou
//
//  Created by chenglian on 16/1/19.
//  Copyright © 2016年 Soyou. All rights reserved.
//

import Foundation
import CoreData

class CurrencyRate: BaseModel {
    
    
    class func importData(data: NSDictionary?, _ context: NSManagedObjectContext) -> (CurrencyRate?) {
        guard let data = data else {
            return nil
        }
        
        guard let sourceCode = data["sourceCode"] as? String else {
            return nil
        }
        
        guard let targetCode = data["targetCode"] as? String else {
            return nil
        }
        
        var currencyRate: CurrencyRate? = CurrencyRate.MR_findFirstWithPredicate(FmtPredicate("sourceCode == %@ && targetCode == %@", sourceCode, targetCode), inContext: context)
        if currencyRate == nil {
            currencyRate = CurrencyRate.MR_createEntityInContext(context)
        }
        
        if let currencyRate = currencyRate {
            currencyRate.sourceCode = sourceCode
            currencyRate.targetCode = targetCode
            currencyRate.updatedAt = data["updatedAt"] as? NSDate
            if let value = data["rate"] as? String, let doubleValue = Double(value) {
                currencyRate.rate = NSNumber(double: doubleValue)
            } else {
                currencyRate.rate = NSNumber(double: 1)
            }
        }
        
        return currencyRate
    }
    
    class func importDatas(datas: [NSDictionary]?, _ completion: CompletionClosure?) {
        if let datas = datas {
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                
                // Import new data
                for data in datas {
                    CurrencyRate.importData(data, localContext)
                }

                }, completion: { (_, _) -> Void in
                    if let completion = completion { completion(nil, nil) }
            })
        }
    }
}