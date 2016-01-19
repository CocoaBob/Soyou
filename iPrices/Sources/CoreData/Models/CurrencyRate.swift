//
//  CurrencyRate.swift
//  iPrices
//
//  Created by chenglian on 16/1/19.
//  Copyright © 2016年 iPrices. All rights reserved.
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
                
            if let value = data["rate"] as? NSNumber {
                currencyRate.rate = value
            }
            if let value = data["updatedAt"] as? NSDate {
                currencyRate.updatedAt = value
            }
        }
        
        return currencyRate
    }
    
    class func importDatas(datas: [NSDictionary]?, _ deleteNonExisting: Bool) {
        if let datas = datas {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                
                // Import new data
                for data in datas {
                    CurrencyRate.importData(data, localContext)
                }
            })
        }
    }
}