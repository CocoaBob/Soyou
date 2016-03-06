//
//  Utils.swift
//  Soyou
//
//  Created by chenglian on 16/1/4.
//  Copyright © 2016年 Soyou. All rights reserved.
//

import Foundation

class Utils: NSObject {
    
    static let shared = Utils()
        
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
    
    class func openAppStorePage() {
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
            mailComposeViewController.setToRecipients(["contact@soyou.io"])
            fromViewController.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(viewController: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        viewController.dismissSelf()
    }
}

// MARK: Encryption / Decryption
extension Utils {
    
    private class func addRandomPrefix(data: NSData) -> NSData {
        let mutableData = NSMutableData(data: data)
        let randomData = NSData(bytes: [UInt8(arc4random_uniform(256))], length: 1)
        mutableData.appendData(randomData)
        return mutableData
    }
    
    private class func removeRandomPrefix(data: NSData) -> NSData {
        return NSData(bytes: data.bytes, length: data.length - 1)
    }
    
    class func encrypt(object: AnyObject) -> NSData {
        let objectData = NSKeyedArchiver.archivedDataWithRootObject(object)
        return addRandomPrefix(objectData)
    }
    
    class func decrypt(data: NSData) -> AnyObject? {
        let objectData = removeRandomPrefix(data)
        return NSKeyedUnarchiver.unarchiveObjectWithData(objectData)
    }
}