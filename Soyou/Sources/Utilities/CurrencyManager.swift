//
//  CurrencyManager.swift
//  Soyou
//
//  Created by chenglian on 16/1/21.
//  Copyright © 2016年 Soyou. All rights reserved.
//

import Foundation

class CurrencyManager {
    
    static let shared = CurrencyManager()
    
    var allCurrencyRates: [CurrencyRate]?
    
    let displayLocale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleLanguageCode:NSBundle.mainBundle().preferredLocalizations.first ?? "en_US"]))
    var countryLocales = [String: NSLocale]()
    var displayLocaleCurrencyFormatter: NSNumberFormatter?
    var currencyFormatters = [String: NSNumberFormatter]()
    var currencyFormattersNoUnit = [String: NSNumberFormatter]()

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
    
    func allCurrencies() -> [String] {
        var allCurrencies = Set<String>()
        MagicalRecord.saveWithBlockAndWait { (localContext) -> Void in
            if let allRegions = Region.MR_findAllInContext(localContext) as? [Region] {
                for region in allRegions {
                    if let currency = region.currency {
                        allCurrencies.insert(currency)
                    }
                }
            }
        }
        return Array(allCurrencies)
    }
    
    func updateCurrencyRates(completion: CompletionClosure?) {
        var currencyChanges = [NSDictionary]()
        for currency in self.allCurrencies() {
            let dict = NSMutableDictionary()
            dict.setObject(currency, forKey: "sourceCode")
            dict.setObject("CNY", forKey: "targetCode")
            currencyChanges.append(dict)
        }
        
        DataManager.shared.requestCurrencyChanges(currencyChanges) { responseObject, error in
            if let responseObject = responseObject,
                query = responseObject["query"] as? NSDictionary,
                count = query["count"] as? Int,
                time = query["created"] as? String,
                results = query["results"] as? NSDictionary,
                rate = results["rate"]
            {
                if count > 0 {
                    var currencyRates = [NSDictionary]()
                    var rates: [NSDictionary]?
                    if let rate = rate as? NSDictionary {
                        rates = [rate]
                    } else if let rate = rate as? [NSDictionary] {
                        rates = rate
                    }
                    if let rates = rates {
                        for rate in rates {
                            if let currency = self.parseCurrencyRate(rate, time: time) {
                                currencyRates.append(currency);
                            }
                        }
                    }
                    
                    CurrencyRate.importDatas(currencyRates, completion)
                } else {
                    if let completion = completion { completion(nil, nil) }
                }
            } else {
                if let completion = completion { completion(nil, nil) }
            }
        }
    }
    
    func referenceCNYFromCurrency(countryCode: String?, price: NSNumber) -> NSNumber? {
        if let countryCode = countryCode,
            currencyCode = self.currencyCode(countryCode),
            rate = self.rateFromSourceCode(currencyCode),
            rateValue = rate.rate?.doubleValue {
                var referencePrice = price.doubleValue * rateValue
                if currencyCode != "CNY" {
                    referencePrice *= 1.05
                }
                return NSNumber(double: referencePrice)
        }
        return nil
    }
    
    func cheapestFormattedPriceInCHY(pricesData: NSData?) -> String? {
        var items: [NSDictionary]?
        if let objectData = pricesData, let object = Utils.decrypt(objectData) as? [[String: AnyObject]] {
            items = object
        }
        var cheapestPriceCNY: NSNumber?
        if let items = items {
            for item in items {
                if let countryCode = item["country"] as? String,
                    price = item["price"] as? NSNumber,
                    priceCNY = self.referenceCNYFromCurrency(countryCode, price: price) {
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
    
    // countryCode = FR/GB/CN/US/etc...
    func countryLocale(countryCode: String) -> NSLocale {
        if let locale = self.countryLocales[countryCode] {
            return locale
        } else {
            let countryLocale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode:countryCode]))
            self.countryLocales[countryCode] = countryLocale
            return countryLocale
        }
    }
    
    // Country Code -> Country Name, eg: CN -> China/中国
    func countryName(countryCode: String) -> String? {
        return self.displayLocale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
    }
    
    // Country Code -> Language Name, eg: en-US/zh-CN -> English/简体中文
    func languageName(languageCode: String) -> String? {
        let locale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleLanguageCode:languageCode]))
        return locale.displayNameForKey(NSLocaleLanguageCode, value: languageCode)
    }
    
    // Country Code -> Currency Code, eg: CN -> CNY
    func currencyCode(countryCode: String) -> String? {
        let countryLocale = self.countryLocale(countryCode)
        return countryLocale.objectForKey(NSLocaleCurrencyCode) as? String
    }
    
    // Country Code -> Currency Name, eg: CN -> China Yuan/人民币
    func currencyName(countryCode: String) -> String? {
        let countryLocale = self.countryLocale(countryCode)
        return self.displayLocale.displayNameForKey(NSLocaleCurrencyCode, value: countryLocale.objectForKey(NSLocaleCurrencyCode) ?? "")
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


