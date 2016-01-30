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
    
    var allCurrencyRates: [CurrencyRate]?
    
    let displayLocale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleLanguageCode:NSBundle.mainBundle().preferredLocalizations.first ?? "en_US"]))
    var displayLocaleCurrencyFormatter: NSNumberFormatter?
    var currencyFormatters = [String:NSNumberFormatter]()
    var currencyFormattersNoUnit = [String:NSNumberFormatter]()
    
    var CurrencyCode: [String:String] = [
        "CN":"CNY",
        "DE":"EUR",
        "FR":"EUR",
        "IT":"EUR",
        "ES":"EUR",
        "SG":"SGD",
        "GB":"GBP",
        "HK":"HKD",
        "JP":"JPY",
        "US":"USD"]
    
    var LanguageCode: [String:String] = [
        "CN":"zh_CN",
        "DE":"de_DE",
        "FR":"fr_FR",
        "IT":"it_IT",
        "ES":"es_ES",
        "SG":"en_SG",
        "GB":"en_GB",
        "HK":"en_HK",
        "JP":"jp_JP",
        "US":"en_US"]
    
    let currencies = [
        ["sourceCode": "USD", "targetCode":"CNY"],
        ["sourceCode": "EUR", "targetCode":"CNY"],
        ["sourceCode": "JPY", "targetCode":"CNY"],
        ["sourceCode": "GBP", "targetCode":"CNY"],
        ["sourceCode": "HKD", "targetCode":"CNY"],
        ["sourceCode": "SGD", "targetCode":"CNY"],
        ["sourceCode": "CNY", "targetCode":"CNY"]
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
    
    func currencyRates() -> [CurrencyRate]? {
        if self.allCurrencyRates == nil || self.allCurrencyRates!.count == 0 {
            self.allCurrencyRates = CurrencyRate.MR_findAll() as? [CurrencyRate]
        }
        return self.allCurrencyRates
    }
    
    func rateFromSourceCode(sourceCode: String) -> CurrencyRate? {
        guard let currencyRates = self.currencyRates() else { return nil }
        for rate in currencyRates {
            if let code = rate.sourceCode {
                if sourceCode.caseInsensitiveCompare(code) == .OrderedSame{
                    return rate
                }
            }
        }
        return nil
    }
    
    func updateCurrencyRates() {
        DataManager.shared.requestCurrencies(currencies) { responseObject, error in
            if let responseObject = responseObject,
                query = responseObject["query"] as? NSDictionary,
                count = query["count"] as? Int,
                time = query["created"] as? String,
                results = query["results"] as? NSDictionary,
                rate = results["rate"] {
                    if count > 0 {
                        var currencyRates = [NSDictionary]()
                        if count == 1 { // rate is a dictionary
                            if let currency = self.parseCurrencyRate(rate as! NSDictionary, time: time) {
                                currencyRates.append(currency);
                            }
                        } else { // rate is a array
                            for r in rate as! NSArray {
                                if let currency = self.parseCurrencyRate(r as! NSDictionary, time: time) {
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
    
    func equivalentCNYFromCurrency(countryCode: String?, price: NSNumber) -> NSNumber? {
        if let countryCode = countryCode, currencyCode = CurrencyCode[countryCode], rate = self.rateFromSourceCode(currencyCode) {
            return NSNumber(double: price.doubleValue * (rate.rate?.doubleValue ?? 1))
        }
        return nil
    }
    
    func cheapestFormattedPriceInCHY(items: [NSDictionary]?) -> String? {
        var cheapestPriceCNY: NSNumber?
        if let items = items {
            for item in items {
                if let country = item["country"] as? String,
                    price = item["price"] as? NSNumber,
                    countryCode = CountryCode[country],
                    priceCNY = self.equivalentCNYFromCurrency(countryCode, price: price) {
                        if cheapestPriceCNY == nil || cheapestPriceCNY!.doubleValue > priceCNY.doubleValue {
                            cheapestPriceCNY = priceCNY
                        }
                }
            }
        }
        
        if let price = cheapestPriceCNY {
            return self.formattedPrice(price, "zh_CN", true)
        } else {
            return NSLocalizedString("product_prices_vc_unavailable")
        }
    }
    
    func countryName(countryCode: String) -> String? {
        return self.displayLocale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
    }
    
    func currencyName(countryCode: String) -> String? {
        let locale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode:countryCode]))
        return self.displayLocale.displayNameForKey(NSLocaleCurrencyCode, value: locale.objectForKey(NSLocaleCurrencyCode) ?? "")
    }
    
    func formattedPrice(price: NSNumber, _ languageCode: String?, _ withUnit: Bool?) -> String {
        var formatter: NSNumberFormatter?
        
        if let languageCode = languageCode {
            let hasUnit = (withUnit != nil && withUnit!)
            if let currencyFormatter = hasUnit ? self.currencyFormatters[languageCode] : self.currencyFormattersNoUnit[languageCode] {
                formatter = currencyFormatter
            } else {
                formatter = NSNumberFormatter()
                formatter!.numberStyle = .CurrencyStyle
                formatter!.maximumFractionDigits = 0
                formatter!.locale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleLanguageCode:languageCode]))
                if hasUnit {
                    self.currencyFormatters[languageCode] = formatter
                } else {
                    formatter!.positiveFormat = formatter!
                        .positiveFormat
                        .stringByReplacingOccurrencesOfString("¤", withString: "")
                        .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    self.currencyFormattersNoUnit[languageCode] = formatter
                }
            }
        } else {
            if let displayLocaleCurrencyFormatter = displayLocaleCurrencyFormatter {
                formatter = displayLocaleCurrencyFormatter
            } else {
                formatter = NSNumberFormatter()
                formatter!.numberStyle = .CurrencyStyle
                formatter!.maximumFractionDigits = 0
                formatter!.locale = self.displayLocale
                formatter!.positiveFormat = formatter!
                    .positiveFormat
                    .stringByReplacingOccurrencesOfString("¤", withString: "")
                    .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                self.displayLocaleCurrencyFormatter = formatter
            }
        }
        
        return formatter?.stringFromNumber(price) ?? "\(price)"
    }
}


