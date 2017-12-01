//
//  CurrencyRate.swift
//  Soyou
//
//  Created by chenglian on 16/1/19.
//  Copyright © 2016年 Soyou. All rights reserved.
//

import Foundation
import CoreData


class CurrencyRate: NSManagedObject {
    
    
    @discardableResult class func importData(_ data: NSDictionary?, _ context: NSManagedObjectContext) -> (CurrencyRate?) {
        guard let data = data else {
            return nil
        }
        
        guard let sourceCode = data["sourceCode"] as? String else {
            return nil
        }
        
        guard let targetCode = data["targetCode"] as? String else {
            return nil
        }
        
        var currencyRate: CurrencyRate? = CurrencyRate.mr_findFirst(with: FmtPredicate("sourceCode == %@ && targetCode == %@", sourceCode, targetCode), in: context)
        if currencyRate == nil {
            currencyRate = CurrencyRate.mr_createEntity(in: context)
        }
        
        if let currencyRate = currencyRate {
            currencyRate.sourceCode = sourceCode
            currencyRate.targetCode = targetCode
            if let value = data["rate"] as? Double {
                currencyRate.rate = NSNumber(value: value)
            } else {
                currencyRate.rate = NSNumber(value: 1.0)
            }
        }
        
        return currencyRate
    }
    
    class func importDatas(_ datas: [NSDictionary]?, _ completion: CompletionClosure?) {
        if let datas = datas {
            // In case response is incorrect, we can't delete all exsiting data
            if datas.isEmpty {
                completion?(nil, FmtError(0, nil))
                return
            }
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                // Delete old data
                CurrencyRate.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
                // Import new data
                for data in datas {
                    CurrencyRate.importData(data, localContext)
                }
            }, completion: { (responseObject, error) -> Void in
                completion?(responseObject, error as NSError?)
            })
        } else {
            completion?(nil, FmtError(0, nil))
        }
    }
}
