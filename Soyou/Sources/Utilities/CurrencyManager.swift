//
//  CurrencyManager.swift
//  Soyou
//
//  Created by chenglian on 16/1/21.
//  Copyright © 2016年 Soyou. All rights reserved.
//

import Foundation

class CurrencyManager {
    
    static let currencyLanguageDict: [String:String] = [
        "EUR":"en",
        "QAR":"ar",
        "VND":"vi",
        "CAD":"en", // fr
        "DKK":"kl", // da
        "ARS":"es",
        "GBP":"en", // cy, kw, gd
        "PHP":"en", // fil, es
        "PLN":"en", // pl
        "MMK":"my",
        "SGD":"en", // ta, ms_Latn, zh_Hans
        "BRL":"pt",
        "JPY":"ja",
        "RUB":"ru", // en, sah, os
        "SEK":"en", // se
        "USD":"en", // es, chr, haw
        "NZD":"en",
        "TWD":"zh", // zh_Hant
        "UYU":"es", // es
        "HKD":"en", // zh_Hans, zh_Hant
        "MXN":"es",
        "UZS":"uz", // uz_Latn, uz_Latn
        "MOP":"en", // pt, zh_Hans, zh_Hant
        "INR":"en", // bn, as, kn, ml, bo, pa_Guru, ta, ne, or, brx, te, ur, hi, kok, gu, mr, ks_Arab,
        "KRW":"ko",
        "NOK":"en", // nn, se, nb
        "IDR":"id",
        "CHF":"en", // it, de, rm, wae, fr, gsw
        "THB":"th",
        "CNY":"zh",
        "CLP":"es",
        "COP":"es",
        "AUD":"en",
        "PKR":"en" // ur, pa_Arab
    ]
    
    static let shared = CurrencyManager()
    
    var allCurrencyRates: [CurrencyRate]?
    
    let displayLocale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleLanguageCode:NSBundle.mainBundle().preferredLocalizations.first ?? "en_US"]))
    var countryLocales = [String: NSLocale]()
    var currencyLocales = [String: NSLocale]()
    var displayLocaleCurrencyFormatter: NSNumberFormatter?
    var currencyFormatters = [String: NSNumberFormatter]()
    var currencyFormattersNoUnit = [String: NSNumberFormatter]()
    
    var _userCurrency: String?
    var userCurrency: String {
        get {
            if _userCurrency == nil {
                if let storedUserCurrency = NSUserDefaults.standardUserDefaults().stringForKey(Cons.App.userCurrency) {
                    _userCurrency = (storedUserCurrency == "") ? "CNY" : storedUserCurrency
                } else {
                    _userCurrency = "CNY"
                }
            }
            return _userCurrency!
        }
        set {
            _userCurrency = newValue
            if _userCurrency == "" {
                _userCurrency = "CNY"
            }
            NSUserDefaults.standardUserDefaults().setObject(_userCurrency, forKey: Cons.App.userCurrency)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var _userCurrencyName: String?
    var userCurrencyName: String {
        get {
            if _userCurrencyName == nil {
                _userCurrencyName = self.currencyNameFromCurrencyCode(self.userCurrency) ?? NSLocalizedString("currency_unknown")
            }
            return _userCurrencyName!
        }
    }

    private func parseCurrencyRate(data: NSDictionary, time: String) -> NSDictionary? {
        if let name = data["Name"] as? String {
            let codes = name.characters.split {$0 == "/"}.map(String.init)
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
        if self.allCurrencyRates == nil || self.allCurrencyRates!.isEmpty {
            self.allCurrencyRates = CurrencyRate.MR_findAll() as? [CurrencyRate]
        }
        return self.allCurrencyRates
    }
    
    func rateFromSourceCode(sourceCode: String) -> CurrencyRate? {
        guard let currencyRates = self.currencyRates() else { return nil }
        for rate in currencyRates {
            if let code = rate.sourceCode {
                if sourceCode.caseInsensitiveCompare(code) == .OrderedSame {
                    return rate
                }
            }
        }
        return nil
    }
    
    var _allCurrencyCodes: [String]?
    func allCurrencyCodes() -> [String] {
        if _allCurrencyCodes == nil {
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
            _allCurrencyCodes = Array(allCurrencies)
        }
        return _allCurrencyCodes!
    }
    
    var _allCurrencyCountryPairs: [String:String]?
    func allCurrencyCountryPairs() -> [String:String] {
        if _allCurrencyCountryPairs == nil {
            // Collect distinct currencies
            var currencyCountryDict = [String:String]()
            MagicalRecord.saveWithBlockAndWait { (localContext) -> Void in
                if let allRegions = Region.MR_findAllInContext(localContext) as? [Region] {
                    for region in allRegions {
                        if let currency = region.currency, country = region.code {
                            if currency.uppercaseString == "EUR" {
                                currencyCountryDict["EUR"] = "EU"
                            } else if currency.uppercaseString == "DKK" {
                                currencyCountryDict["DKK"] = "DK"
                            } else if currency.uppercaseString == "CHF" {
                                currencyCountryDict["CHF"] = "CH"
                            } else if currency.uppercaseString == "USD" {
                                currencyCountryDict["USD"] = "US"
                            } else if currency.uppercaseString == "INR" {
                                currencyCountryDict["INR"] = "IN"
                            } else {
                                currencyCountryDict[currency] = country
                            }
                        }
                    }
                }
            }
            
            _allCurrencyCountryPairs = currencyCountryDict
        }
        return _allCurrencyCountryPairs!
    }
    
    func updateCurrencyRates(targetCurrencyCode: String, _ completion: CompletionClosure?) {
        // Reset data
        _userCurrency = nil
        _userCurrencyName = nil
        _allCurrencyCodes = nil
        self.allCurrencyRates = nil
        
        // Prepare request
        var currencyChanges = [NSDictionary]()
        for currency in self.allCurrencyCodes() {
            let dict = NSMutableDictionary()
            dict.setObject(currency, forKey: "sourceCode")
            dict.setObject(targetCurrencyCode, forKey: "targetCode")
            currencyChanges.append(dict)
        }
        
        DataManager.shared.requestCurrencyChanges(currencyChanges) { responseObject, error in
            if let responseObject = responseObject,
                query = responseObject["query"] as? NSDictionary,
                cnt = query["count"] as? Int,
                time = query["created"] as? String,
                results = query["results"] as? NSDictionary,
                rate = results["rate"] {
                if cnt > 0 {
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
                                currencyRates.append(currency)
                            }
                        }
                    }
                    
                    CurrencyRate.importDatas(currencyRates, completion)
                } else {
                    if let completion = completion { completion(responseObject, error) }
                }
            } else {
                if let completion = completion { completion(responseObject, error) }
            }
        }
    }
    
    func userCurrencyFromCurrency(countryCode: String?, price: NSNumber) -> NSNumber? {
        if let countryCode = countryCode,
            currencyCode = self.currencyCode(countryCode),
            rate = self.rateFromSourceCode(currencyCode),
            rateValue = rate.rate?.doubleValue {
                var referencePrice = price.doubleValue * rateValue
                if currencyCode != self.userCurrency {
                    referencePrice *= 1.05
                }
                return NSNumber(double: referencePrice)
        }
        return nil
    }
    
    func cheapestFormattedPriceInUserCurrency(pricesData: NSData?) -> String? {
        var items: [NSDictionary]?
        if let objectData = pricesData, let object = Utils.decrypt(objectData) as? [[String: AnyObject]] {
            items = object
        }
        var cheapestPrice: NSNumber?
        if let items = items {
            for item in items {
                if let countryCode = item["country"] as? String,
                    price = item["price"] as? NSNumber,
                    priceInUserCurrency = self.userCurrencyFromCurrency(countryCode, price: price) {
                        if cheapestPrice == nil || cheapestPrice!.doubleValue > priceInUserCurrency.doubleValue {
                            cheapestPrice = priceInUserCurrency
                        }
                }
            }
        }
        
        if let price = cheapestPrice {
            return self.formattedPrice(price, self.userCurrency, true)
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
    
    // currencyCode = EUR/GBP/CNY/JPY/USD...
    func currencyLocale(currencyCode: String) -> NSLocale {
        if let locale = self.currencyLocales[currencyCode] {
            return locale
        } else {
            var components = [String: String]()
            components[NSLocaleCurrencyCode] = currencyCode
            if let languageCode = CurrencyManager.currencyLanguageDict[currencyCode] {
                components[NSLocaleLanguageCode] = languageCode
            }
            let currencyLocale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents(components))
            self.currencyLocales[currencyCode] = currencyLocale
            return currencyLocale
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
    
    // Currency Code -> Currency Name, eg: CNY -> China Yuan/人民币
    func currencyNameFromCurrencyCode(countryCode: String) -> String? {
        let currencyLocale = self.currencyLocale(countryCode)
        return self.displayLocale.displayNameForKey(NSLocaleCurrencyCode, value: currencyLocale.objectForKey(NSLocaleCurrencyCode) ?? "")
    }
    
    func formattedPrice(price: NSNumber, _ currencyCode: String?, _ withUnit: Bool) -> String {
        var formatter: NSNumberFormatter?
        
        if let currencyCode = currencyCode {
            if let currencyFormatter = withUnit ? self.currencyFormatters[currencyCode] : self.currencyFormattersNoUnit[currencyCode] {
                formatter = currencyFormatter
            } else {
                formatter = NSNumberFormatter()
                formatter!.numberStyle = .CurrencyStyle
                formatter!.maximumFractionDigits = 0
                var components = [String: String]()
                components[NSLocaleCurrencyCode] = currencyCode
                if let languageCode = CurrencyManager.currencyLanguageDict[currencyCode] {
                    components[NSLocaleLanguageCode] = languageCode
                }
                formatter!.locale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents(components))
                if withUnit {
                    self.currencyFormatters[currencyCode] = formatter
                } else {
                    formatter!.positiveFormat = formatter!
                        .positiveFormat
                        .stringByReplacingOccurrencesOfString("¤", withString: "")
                        .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    self.currencyFormattersNoUnit[currencyCode] = formatter
                }
            }
        } else {
            if let displayLocaleCurrencyFormatter = self.displayLocaleCurrencyFormatter {
                formatter = displayLocaleCurrencyFormatter
            } else {
                formatter = NSNumberFormatter()
                formatter!.numberStyle = .CurrencyStyle
                formatter!.maximumFractionDigits = 0
                formatter!.locale = self.currencyLocale(self.userCurrency)
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
