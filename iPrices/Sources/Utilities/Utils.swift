//
//  Utils.swift
//  iPrices
//
//  Created by chenglian on 16/1/4.
//  Copyright © 2016年 iPrices. All rights reserved.
//

import Foundation

class Utils: NSObject {
    
    static let shared = Utils()
    
    let displayLocale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleLanguageCode:NSBundle.mainBundle().preferredLocalizations.first ?? "en"]))
        
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
}

// MARK: Open AppStore page
extension Utils {
    
    func openAppStorePage() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/apple-store/id1028389463?mt=8")!)
    }
}

// MARK: Send feedback email and MFMailComposeViewControllerDelegate
extension Utils: MFMailComposeViewControllerDelegate {
    
    func sendFeedbackEmail(fromViewController: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setSubject(NSLocalizedString("user_vc_feedback_mail_title"))
            mailComposeViewController.setMessageBody(NSLocalizedString("user_vc_feedback_mail_message_body"), isHTML: true)
            mailComposeViewController.setToRecipients(["test@test.com"])
            fromViewController.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(viewController: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        viewController.dismissSelf()
    }
}

// MARK: Localised country code and currency name
extension Utils {
    
    func countryName(countryCode: String) -> String? {
        return self.displayLocale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
    }
    
    func currencyName(countryCode: String) -> String? {
        let locale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode:countryCode]))
        return self.displayLocale.displayNameForKey(NSLocaleCurrencyCode, value: locale.objectForKey(NSLocaleCurrencyCode) ?? "")
    }
    
    func formattedPrice(price: NSNumber, _ countryCode: String?, _ withUnit: Bool?) -> String {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        if let countryCode = countryCode {
            currencyFormatter.locale = NSLocale(localeIdentifier: NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode:countryCode]))
        } else {
            currencyFormatter.locale = self.displayLocale
        }
        if countryCode == nil || withUnit == nil || withUnit == false {
            currencyFormatter.positiveFormat = currencyFormatter
                .positiveFormat
                .stringByReplacingOccurrencesOfString("¤", withString: "")
        }
        return currencyFormatter.stringFromNumber(price) ?? "\(price)"
    }
}