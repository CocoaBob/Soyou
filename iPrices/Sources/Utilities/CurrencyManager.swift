//
//  CurrencyManager.swift
//  iPrices
//
//  Created by chenglian on 16/1/21.
//  Copyright © 2016年 iPrices. All rights reserved.
//

import Foundation

class CurrencyManager {
    static let shared = CurrencyManager()
    
    let currencies = [
        ["sourceCode": "USD", "targetCode":"CNY"],
        ["sourceCode": "EUR", "targetCode":"CNY"],
        ["sourceCode": "JPY", "targetCode":"CNY"],
        ["sourceCode": "GBP", "targetCode":"CNY"],
        ["sourceCode": "HKD", "targetCode":"CNY"],
        ["sourceCode": "SGD", "targetCode":"CNY"]
    ]

    private func parseCurrencyRate(data: NSDictionary, time: String) -> NSDictionary? {
        if let name = data["Name"] as? String{
            let codes = name.characters.split{$0 == "/"}.map(String.init)
            let result: NSDictionary = [
                "rate": (data["Rate"] as? String)!,
                "updatedAt": time,
                "sourceCode": codes[0],
                "targetCode": codes[1]
            ]
            
            return result
        }
        
        return nil
    }
    
    func fetchCurrencyRates() -> [CurrencyRate]{
        return CurrencyRate.MR_findAll() as! [CurrencyRate]
    }
    
    func updateCurrencyRates(){
        
        DataManager.shared.requestCurrencies(currencies) { (responseObject: AnyObject?) -> () in
            if let count = responseObject!["count"] as? Int {
                if count > 0 {
                    if let results = responseObject?["results"], let rate = results!["rate"]{
                        let time = responseObject?["created"] as! String
                        var currencyRates = [NSDictionary]()
                        if count == 1 { // rate is a dictionary
                            if let currency = self.parseCurrencyRate(rate as! NSDictionary, time: time){
                                currencyRates.append(currency);
                            }
                        }else{ // rate is a array
                            for r in rate as! NSArray {
                                if let currency = self.parseCurrencyRate(r as! NSDictionary, time: time){
                                    currencyRates.append(currency);
                                }
                            }
                        }
                        
                        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                            CurrencyRate.importDatas(currencyRates, false)
                        })
                    }
                }
            }
        }
    }
}


