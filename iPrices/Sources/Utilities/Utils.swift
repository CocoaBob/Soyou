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
    
    func openAppStorePage() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/apple-store/id375380948?mt=8")!)
    }
    
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
}

// MARK: MFMailComposeViewControllerDelegate
extension Utils: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(viewController: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        viewController.dismissSelf()
    }
}
