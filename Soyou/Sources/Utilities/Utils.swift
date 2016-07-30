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
        
    func logAnalytic(target: Int, action: Int, data: String) {
        let analytic: NSDictionary = [
            "target": NSNumber(integer: target),
            "action": NSNumber(integer: action),
            "data": data,
            "operatedAt": Cons.utcDateFormatter.stringFromDate(NSDate())
        ]
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            Analytic.importData(analytic, localContext)
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
        if let vc = UIApplication.sharedApplication().keyWindow?.rootViewController?.toppestViewController() {
            let activityView = UIActivityViewController(activityItems: items, applicationActivities: [WeChatSessionActivity(), WeChatMomentsActivity()])
            activityView.excludedActivityTypes = SharingProvider.excludedActivityTypes
            vc.presentViewController(activityView, animated: true, completion: completion)
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

// MARK: Diagnostics
extension Utils {
    
    class func systemDiagnosticData() -> NSData? {
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
        
        return diagnosticString.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    func networkDiagnosticData(completionHandler: ((NSData?)->())?) {
        guard let keyWindow = UIApplication.sharedApplication().keyWindow else {
            if let completionHandler = completionHandler { completionHandler(nil) }
            return
        }
        
        // Add text view
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        textView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        textView.textColor = UIColor.greenColor()
        textView.font = UIFont(name: "Menlo", size: 9)
        textView.contentInset = UIEdgeInsets(top: 72, left: 0, bottom: 56, right: 0)
        textView.editable = false
        textView.selectable = false
        keyWindow.addSubview(textView)
        
        // Constraint
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["textView"] = textView
        textView.translatesAutoresizingMaskIntoConstraints = false
        keyWindow.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[textView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))
        keyWindow.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[textView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))
        textView.setNeedsLayout()
        textView.layoutIfNeeded()
        
        // Show indicator
        if let progressHUD = MBProgressHUD.showLoader(keyWindow) {
            progressHUD.label.text = NSLocalizedString("brands_vc_beedback_waiting_title")
            progressHUD.detailsLabel.text = NSLocalizedString("brands_vc_beedback_waiting_detail")
        }
        
        // Start traceroute
        let outputLogger = QNNOutputLogger() { logs in
            dispatch_async(dispatch_get_main_queue(), {
                textView.text = logs
                textView.scrollRectToVisible(CGRect(x:0, y:textView.contentSize.height, width:1, height:1), animated: false)
            })
        }
        QNNTraceRoute.start("api.soyou.io", output:outputLogger) { records in
            // Remove logs
            textView.removeFromSuperview()
            // Remove indicator
            MBProgressHUD.hideLoader(keyWindow)
            if let completionHandler = completionHandler {
                let result = outputLogger.logs.dataUsingEncoding(NSUTF8StringEncoding)
                completionHandler(result)
            }
        }
    }
    
    func sendDiagnosticReport(fromViewController: UIViewController) {
        let completion = { (testResponseString: String) in
            let testResponseData = testResponseString.dataUsingEncoding(NSUTF8StringEncoding)
            Utils.shared.networkDiagnosticData() { result in
                Utils.shared.sendFeedbackEmail(fromViewController, attachments: [
                    "SystemDiagnostic.zip": Utils.compressData("SystemDiagnostic.txt", Utils.systemDiagnosticData()),
                    "NetworkDiagnostic.zip": Utils.compressData("NetworkDiagnostic.txt", result),
                    "TestResponse.zip": Utils.compressData("TestResponse.txt", testResponseData)])
            }
        }
        RequestManager.shared.requestAllBrands({ (responseObject) in
            completion("\(responseObject)")
        }) { (error) in
            completion("\(error)")
        }
    }
}

// MARK: Compress data
extension Utils {
    
    class func compressData(fileName: String, _ data: NSData?) -> NSData? {
        guard let data = data else { return nil }
        let tempDir = NSTemporaryDirectory() as NSString
        let oldDataPath = tempDir.stringByAppendingPathComponent(fileName)
        let newDataPath = tempDir.stringByAppendingPathComponent("\(arc4random())")
        data.writeToFile(oldDataPath, atomically: true)
        SSZipArchive.createZipFileAtPath(newDataPath, withFilesAtPaths: [oldDataPath])
        return NSData(contentsOfFile: newDataPath)
    }
}


// MARK: Send feedback email and MFMailComposeViewControllerDelegate
extension Utils: MFMailComposeViewControllerDelegate {
    
    func sendFeedbackEmail(fromViewController: UIViewController, attachments: [String: NSData?]?) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setSubject(NSLocalizedString("user_vc_feedback_mail_title"))
            mailComposeViewController.setMessageBody(NSLocalizedString("user_vc_feedback_mail_message_body"), isHTML: true)
            mailComposeViewController.setToRecipients(["contact@soyou.io"])
            if let attachments = attachments {
                for (fileName, fileData) in attachments {
                    if let fileData = fileData {
                        mailComposeViewController.addAttachmentData(fileData, mimeType: "application/octet-stream", fileName: fileName)
                    }
                }
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

// MARK: QNNOutput for traceroute
class QNNOutputLogger: NSObject, QNNOutputDelegate {
    
    var updateHandler: ((String)->())?
    var logs: String = ""
    
    init(_ updateHandler: ((String)->())?) {
        self.updateHandler = updateHandler
    }
    
    func write(line: String) {
        self.logs += line
        if let updateHandler = updateHandler {
            updateHandler(self.logs)
        }
    }
}
