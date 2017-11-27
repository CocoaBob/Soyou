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
    
    let displayLocale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.languageCode.rawValue:Bundle.main.preferredLocalizations.first ?? "en_US"]))
    var countryLocales = [String: Locale]()
    var currencyLocales = [String: Locale]()
    var displayLocaleCurrencyFormatter: NumberFormatter?
    var currencyFormatters = [String: NumberFormatter]()
    var currencyFormattersNoUnit = [String: NumberFormatter]()
    
    var _userCurrency: String?
    var userCurrency: String {
        get {
            if _userCurrency == nil {
                if let storedUserCurrency = UserDefaults.stringForKey(Cons.App.userCurrency) {
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
            UserDefaults.setObject(_userCurrency, forKey: Cons.App.userCurrency)
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

    fileprivate func parseCurrencyRate(_ data: NSDictionary, time: String) -> NSDictionary? {
        if let name = data["Name"] as? String {
            let codes = name.split {$0 == "/"}.map(String.init)
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
            self.allCurrencyRates = CurrencyRate.mr_findAll() as? [CurrencyRate]
        }
        return self.allCurrencyRates
    }
    
    func rateFromSourceCode(_ sourceCode: String) -> CurrencyRate? {
        guard let currencyRates = self.currencyRates() else { return nil }
        for rate in currencyRates {
            if let code = rate.sourceCode {
                if sourceCode.caseInsensitiveCompare(code) == .orderedSame {
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
            
            MagicalRecord.save(blockAndWait: { (localContext) in
                if let allRegions = Region.mr_findAll(in: localContext) as? [Region] {
                    for region in allRegions {
                        if let currency = region.currency {
                            allCurrencies.insert(currency)
                        }
                    }
                }
            })
            _allCurrencyCodes = Array(allCurrencies)
        }
        return _allCurrencyCodes!
    }
    
    var _allCurrencyCountryPairs: [String:String]?
    func allCurrencyCountryPairs() -> [String:String] {
        if _allCurrencyCountryPairs == nil {
            // Collect distinct currencies
            var currencyCountryDict = [String:String]()
            MagicalRecord.save(blockAndWait: { (localContext) in
                if let allRegions = Region.mr_findAll(in: localContext) as? [Region] {
                    for region in allRegions {
                        if let currency = region.currency, let country = region.code {
                            if currency.uppercased() == "EUR" {
                                currencyCountryDict["EUR"] = "EU"
                            } else if currency.uppercased() == "DKK" {
                                currencyCountryDict["DKK"] = "DK"
                            } else if currency.uppercased() == "CHF" {
                                currencyCountryDict["CHF"] = "CH"
                            } else if currency.uppercased() == "USD" {
                                currencyCountryDict["USD"] = "US"
                            } else if currency.uppercased() == "INR" {
                                currencyCountryDict["INR"] = "IN"
                            } else {
                                currencyCountryDict[currency] = country
                            }
                        }
                    }
                }
            })
            
            _allCurrencyCountryPairs = currencyCountryDict
        }
        return _allCurrencyCountryPairs!
    }
    
    func updateCurrencyRates(_ targetCurrencyCode: String, _ completion: CompletionClosure?) {
        // Reset data
        _userCurrency = nil
        _userCurrencyName = nil
        _allCurrencyCodes = nil
        self.allCurrencyRates = nil
        
        // Prepare request
        var currencyChanges = [NSDictionary]()
        for currency in self.allCurrencyCodes() {
            let dict = NSMutableDictionary()
            dict.setObject(currency, forKey: "sourceCode" as NSCopying)
            dict.setObject(targetCurrencyCode, forKey: "targetCode" as NSCopying)
            currencyChanges.append(dict)
        }
        
        DataManager.shared.requestCurrencyChanges(currencyChanges) { responseObject, error in
            if let currencyRates = responseObject as? [NSDictionary] {
                if currencyRates.count > 0 {
                    CurrencyRate.importDatas(currencyRates, completion)
                } else {
                    if let completion = completion { completion(responseObject, error) }
                }
            } else {
                if let completion = completion { completion(responseObject, error) }
            }
        }
    }
    
    func priceInUserCurrencyFromCurrencyCode(_ currencyCode: String?, price: NSNumber) -> NSNumber? {
        if let currencyCode = currencyCode,
            let rate = self.rateFromSourceCode(currencyCode),
            let rateValue = rate.rate?.doubleValue {
            var referencePrice = price.doubleValue * rateValue
            if currencyCode != self.userCurrency {
                referencePrice *= 1.05
            }
            return NSNumber(value: referencePrice as Double)
        }
        return nil
    }
    
    func priceInUserCurrencyFromCountryCode(_ countryCode: String?, price: NSNumber) -> NSNumber? {
        if let countryCode = countryCode,
            let currencyCode = self.currencyCode(countryCode) {
            return self.priceInUserCurrencyFromCurrencyCode(currencyCode, price: price)
        }
        return nil
    }
    
    func priceInUserCurrencyFromPriceItem(_ item: NSDictionary) -> NSNumber? {
        guard let price = item["price"] as? NSNumber else { return nil }
        let currencyCode = item["currency"] as? String
        let countryCode = item["country"] as? String
        var priceInUserCurrency = self.priceInUserCurrencyFromCurrencyCode(currencyCode, price: price)
        if currencyCode == nil {
            priceInUserCurrency = self.priceInUserCurrencyFromCountryCode(countryCode, price: price)
        }
        return priceInUserCurrency
    }
    
    func cheapestFormattedPriceInUserCurrency(_ pricesData: Data?) -> String? {
        var items: [NSDictionary]?
        if let objectData = pricesData,
            let object = Utils.decrypt(objectData) as? [NSDictionary] {
            items = object
        }
        var cheapestPrice: NSNumber?
        if let items = items {
            for item in items {
                if let priceInUserCurrency = self.priceInUserCurrencyFromPriceItem(item) {
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
    func countryLocale(_ countryCode: String) -> Locale {
        if let locale = self.countryLocales[countryCode] {
            return locale
        } else {
            let countryLocale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue:countryCode]))
            self.countryLocales[countryCode] = countryLocale
            return countryLocale
        }
    }
    
    // currencyCode = EUR/GBP/CNY/JPY/USD...
    func currencyLocale(_ currencyCode: String) -> Locale {
        if let locale = self.currencyLocales[currencyCode] {
            return locale
        } else {
            var components = [String: String]()
            components[NSLocale.Key.currencyCode.rawValue] = currencyCode
            if let languageCode = CurrencyManager.currencyLanguageDict[currencyCode] {
                components[NSLocale.Key.languageCode.rawValue] = languageCode
            }
            let currencyLocale = Locale(identifier: Locale.identifier(fromComponents: components))
            self.currencyLocales[currencyCode] = currencyLocale
            return currencyLocale
        }
    }
    
    // Country Code -> Country Name, eg: CN -> China/中国
    func countryName(_ countryCode: String) -> String? {
        return (self.displayLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
    }
    
    // Country Code -> Language Name, eg: en-US/zh-CN -> English/简体中文
    func languageName(_ languageCode: String) -> String? {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.languageCode.rawValue:languageCode]))
        return (locale as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: languageCode)
    }
    
    // Country Code -> Currency Code, eg: CN -> CNY
    func currencyCode(_ countryCode: String) -> String? {
        let countryLocale = self.countryLocale(countryCode)
        return (countryLocale as NSLocale).object(forKey: NSLocale.Key.currencyCode) as? String
    }
    
    // Country Code -> Currency Name, eg: CN -> China Yuan/人民币
    func currencyNameFromCountryCode(_ countryCode: String) -> String? {
        let countryLocale = self.countryLocale(countryCode)
        return (self.displayLocale as NSLocale).displayName(forKey: NSLocale.Key.currencyCode, value: (countryLocale as NSLocale).object(forKey: NSLocale.Key.currencyCode) ?? "")
    }
    
    // Currency Code -> Currency Name, eg: CNY -> China Yuan/人民币
    func currencyNameFromCurrencyCode(_ countryCode: String) -> String? {
        let currencyLocale = self.currencyLocale(countryCode)
        return (self.displayLocale as NSLocale).displayName(forKey: NSLocale.Key.currencyCode, value: (currencyLocale as NSLocale).object(forKey: NSLocale.Key.currencyCode) ?? "")
    }
    
    func formattedPrice(_ price: NSNumber, _ currencyCode: String?, _ withUnit: Bool) -> String {
        var formatter: NumberFormatter?
        
        if let currencyCode = currencyCode {
            if let currencyFormatter = withUnit ? self.currencyFormatters[currencyCode] : self.currencyFormattersNoUnit[currencyCode] {
                formatter = currencyFormatter
            } else {
                formatter = NumberFormatter()
                formatter!.numberStyle = .currency
                formatter!.maximumFractionDigits = 0
                var components = [String: String]()
                components[NSLocale.Key.currencyCode.rawValue] = currencyCode
                if let languageCode = CurrencyManager.currencyLanguageDict[currencyCode] {
                    components[NSLocale.Key.languageCode.rawValue] = languageCode
                }
                formatter!.locale = Locale(identifier: Locale.identifier(fromComponents: components))
                if withUnit {
                    self.currencyFormatters[currencyCode] = formatter
                } else {
                    formatter!.positiveFormat = formatter!
                        .positiveFormat
                        .replacingOccurrences(of: "¤", with: "")
                        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    self.currencyFormattersNoUnit[currencyCode] = formatter
                }
            }
        } else {
            if let displayLocaleCurrencyFormatter = self.displayLocaleCurrencyFormatter {
                formatter = displayLocaleCurrencyFormatter
            } else {
                formatter = NumberFormatter()
                formatter!.numberStyle = .currency
                formatter!.maximumFractionDigits = 0
                formatter!.locale = self.currencyLocale(self.userCurrency)
                formatter!.positiveFormat = formatter!
                    .positiveFormat
                    .replacingOccurrences(of: "¤", with: "")
                    .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                self.displayLocaleCurrencyFormatter = formatter
            }
        }
        
        return formatter?.string(from: price) ?? "\(price)"
    }
}
