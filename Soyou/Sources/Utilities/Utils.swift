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

// MARK: Share
extension Utils {
    
    class func shareItems(items: [AnyObject], completion: (() -> Void)?) {
        guard let keyWindow = UIApplication.sharedApplication().keyWindow else { return }
        let activityView = UIActivityViewController(activityItems: items, applicationActivities: [WeChatSessionActivity(), WeChatMomentsActivity()])
        activityView.excludedActivityTypes = SharingProvider.excludedActivityTypes
        let rootVC = keyWindow.rootViewController
        if let presentedVC = rootVC?.presentedViewController {
            presentedVC.presentViewController(activityView, animated: true, completion: completion)
        } else {
            rootVC?.presentViewController(activityView, animated: true, completion: completion)
        }
    }
    
    class func shareApp() {
        guard let keyWindow = UIApplication.sharedApplication().keyWindow else { return }
        MBProgressHUD.showLoader(keyWindow)
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let image = UIImage(named: "img_share_icon"), url = NSURL(string: "https://itunes.apple.com/us/app/apple-store/id1028389463?mt=8") {
                Utils.shareItems(
                    [image, NSLocalizedString("user_vc_feedback_alert_share_title"), NSLocalizedString("user_vc_feedback_alert_share_description"), url],
                    completion: { () -> Void in
                    MBProgressHUD.hideLoader(keyWindow)
                })
            }
        }
    }
}

// MARK: Send feedback email and MFMailComposeViewControllerDelegate
extension Utils: MFMailComposeViewControllerDelegate {
    
    func sendFeedbackEmail(fromViewController: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            // Prepare info
            var appVersion  = ""
            if let shortVersionString = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString" as String) as? String {
                appVersion  += shortVersionString
            }
            if let version = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String {
                appVersion  += "(\(version))"
            }
            let appLanguage = NSLocale.preferredLanguages().first ?? "Unknown"
            let device = UIDevice.currentDevice()
            let deviceName = device.name ?? "Unknown"
            let deviceModel = device.model ?? "Unknown"
            let deviceSystemName = device.systemName ?? "Unknown"
            let deviceSystemVersion = device.systemVersion ?? "Unknown"
            let deviceUUID = device.identifierForVendor?.UUIDString ?? "Unknown"
            let screenSize = NSStringFromCGSize(UIScreen.mainScreen().bounds.size)
            let screenScale = "\(UIScreen.mainScreen().scale)"
            
            // Get device machine name http://stackoverflow.com/a/25380129/886215
            var sysInfo: [CChar] = Array(count: sizeof(utsname), repeatedValue: 0)
            let machine = sysInfo.withUnsafeMutableBufferPointer { (inout ptr: UnsafeMutableBufferPointer<CChar>) -> String in
                uname(UnsafeMutablePointer<utsname>(ptr.baseAddress))
                let machinePtr = ptr.baseAddress.advancedBy(Int(_SYS_NAMELEN * 4))
                var buf: [CChar] = Array<CChar>(count: Int(_SYS_NAMELEN) + 1, repeatedValue: 0)
                return buf.withUnsafeMutableBufferPointer({ (inout bufPtr: UnsafeMutableBufferPointer<CChar>) -> String in
                    strncpy(bufPtr.baseAddress, machinePtr, Int(_SYS_NAMELEN))
                    return String.fromCString(bufPtr.baseAddress)!
                })
            }
            
            // Prepare data
            let diagnosticString =
                "AppVersion : \(appVersion)\n" +
                "AppLanguage : \(appLanguage)\n" +
                "DeviceName : \(deviceName)\n" +
                "DeviceModel : \(deviceModel)\n" +
                "DeviceType : \(machine)\n" +
                "DeviceSystemName : \(deviceSystemName)\n" +
                "DeviceSystemVersion : \(deviceSystemVersion)\n" +
                "DeviceUUID : \(deviceUUID)\n" +
                "ScreenSize : \(screenSize)\n" +
                "ScreenScale : \(screenScale)\n"
            
            // Send email
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setSubject(NSLocalizedString("user_vc_feedback_mail_title"))
            mailComposeViewController.setMessageBody(NSLocalizedString("user_vc_feedback_mail_message_body"), isHTML: true)
            mailComposeViewController.setToRecipients(["contact@soyou.io"])
            if let diagnosticData = diagnosticString.dataUsingEncoding(NSUTF8StringEncoding) {
                mailComposeViewController.addAttachmentData(diagnosticData, mimeType: "TEXT/XML", fileName: "DiagnosticData.txt")
            }
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
