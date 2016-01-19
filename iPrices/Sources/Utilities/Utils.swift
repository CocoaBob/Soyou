//
//  Utils.swift
//  iPrices
//
//  Created by chenglian on 16/1/4.
//  Copyright © 2016年 iPrices. All rights reserved.
//

import Foundation

class Utils {
    static let shared = Utils()
    
    let currencies = [
        ["sourceCode": "USD", "targetCode":"CNY"]
    ]
    
    func logAnalytic(target: Int16, action: Int16, data: String) {
        // TODO create analytic dictionary
        //        let analytic:NSDictionary = [
        //            "target": target as String,
        //            "action": action,
        //            "data": data,
        //            "operatedAt": NSDate()
        //        ]
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            // TO uncommente this line
            //Analytic.importData(analytic, localContext)
        })
    }
    
    func updateCurrencyRate(){
        
        DataManager.shared.requestCurrencies(currencies) { (data: AnyObject?) -> () in
//            if let data = data as! NSDictionary{
//                if let results = data["rate"] as NSArray {
//                    
//                }
//            }
        }
        
//        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
//            CurrencyRate.importDatas(rates, false)
//        })
    }
}
