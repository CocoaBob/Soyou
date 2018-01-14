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
        
    func logAnalytic(_ target: Int, action: Int, data: String) {
        let analytic: NSDictionary = [
            "target": NSNumber(value: target as Int),
            "action": NSNumber(value: action as Int),
            "data": data,
            "operatedAt": Cons.utcDateFormatter.string(from: Date())
        ]
        
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            Analytic.importData(analytic, localContext)
        })
    }
}

// MARK: Open AppStore page
extension Utils {
    
    class func openAppStorePage() {
        guard let url = URL(string: "https://itunes.apple.com/us/app/apple-store/id1028389463?mt=8") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly : NSNumber(value: true)], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

// MARK: Share
extension Utils {
    
    class func shareItems(items: [Any], completion: (() -> Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController?.toppestViewController() {
            self.shareItems(from: vc, items: items, completion: completion)
        }
    }
    
    class func shareItems(from vc: UIViewController, items: [Any], completion: (() -> Void)?) {
        let activityView = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.present(activityView, animated: true, completion: completion)
    }
    
    class func shareToWeChat(from vc: UIViewController, items: [UIImage]?, completion: ((Bool) -> Void)?) {
        if UserManager.shared.isWeChatUser {
            self.shareItems(from: vc, items: items ?? [UIImage(named: "img_qr")!]) {
                completion?(true)
            }
        } else {
            let alertController = UIAlertController(title: nil,
                                                    message: NSLocalizedString("needs_wechat_account"),
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("needs_wechat_account_action"),
                                                    style: UIAlertActionStyle.default,
                                                    handler: { (action: UIAlertAction) -> Void in
                                                        // Show the User tab
                                                        if let tabC = vc.tabBarController {
                                                            tabC.selectedViewController = tabC.viewControllers?.last
                                                        }
            }))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_cancel"),
                                                    style: UIAlertActionStyle.cancel,
                                                    handler: nil))
            vc.present(alertController, animated: true, completion: nil)
            completion?(false)
        }
    }
    
    class func shareApp() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        MBProgressHUD.show(keyWindow)
        DispatchQueue.main.async {
            if let image = UIImage(named: "img_share_icon"),
                let url = URL(string: "https://itunes.apple.com/us/app/apple-store/id1028389463?mt=8") {
                Utils.shareItems(
                    items: [image, NSLocalizedString("user_vc_feedback_alert_share_title"), NSLocalizedString("user_vc_feedback_alert_share_description"), url],
                    completion: { () -> Void in
                    MBProgressHUD.hide(keyWindow)
                })
            }
        }
    }
}

// MARK: Diagnostics
extension Utils {
    
    class func systemDiagnosticData() -> Data? {
        // Prepare info
        var appVersion  = ""
        if let shortVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) as? String {
            appVersion  += shortVersionString
        }
        if let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            appVersion  += "(\(version))"
        }
        let appLanguage = Locale.preferredLanguages.first ?? "Unknown"
        let device = UIDevice.current
        let deviceName = device.name
        let deviceModel = device.model
        let deviceSystemName = device.systemName
        let deviceSystemVersion = device.systemVersion
        let deviceUUID = device.identifierForVendor?.uuidString ?? "Unknown"
        let screenSize = NSStringFromCGSize(UIScreen.main.bounds.size)
        let screenScale = "\(UIScreen.main.scale)"
        
        // Get device machine name http://stackoverflow.com/questions/26028918
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let machine = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)

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
        
        return diagnosticString.data(using: String.Encoding.utf8)
    }
    
    func sendDiagnosticReport(_ fromViewController: UIViewController) {
        let completion = { (testResponseString: String) in
            let testResponseData = testResponseString.data(using: String.Encoding.utf8)
            Utils.shared.sendFeedbackEmail(fromViewController, attachments: [
                "SystemDiagnostic.zip": Utils.compressData("SystemDiagnostic.txt", Utils.systemDiagnosticData()),
                "TestResponse.zip": Utils.compressData("TestResponse.txt", testResponseData)])
        }
        RequestManager.shared.requestAllBrands({ (responseObject) in
            completion("\(String(describing: responseObject))")
        }) { (error) in
            completion("\(String(describing: error))")
        }
    }
}

// MARK: Compress data
extension Utils {
    
    class func compressData(_ fileName: String, _ data: Data?) -> Data? {
        guard let data = data else { return nil }
        let tempDir = NSTemporaryDirectory() as NSString
        let oldDataPath = tempDir.appendingPathComponent(fileName)
        let newDataPath = tempDir.appendingPathComponent("\(arc4random())")
        try? data.write(to: URL(fileURLWithPath: oldDataPath), options: [.atomic])
        SSZipArchive.createZipFile(atPath: newDataPath, withFilesAtPaths: [oldDataPath])
        return (try? Data(contentsOf: URL(fileURLWithPath: newDataPath)))
    }
}


// MARK: Send feedback email and MFMailComposeViewControllerDelegate
extension Utils: MFMailComposeViewControllerDelegate {
    
    func sendFeedbackEmail(_ fromViewController: UIViewController, attachments: [String: Data?]?) {
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
            fromViewController.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ viewController: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        viewController.dismissSelf()
    }
}

// MARK: Encryption / Decryption
extension Utils {
    
    fileprivate class func addRandomPrefix(_ data: Data) -> Data {
        var mutableData = NSData(data: data) as Data
        let randomData = Data(bytes: UnsafePointer<UInt8>([UInt8(arc4random_uniform(256))]), count: 1)
        mutableData.append(randomData)
        return mutableData
    }
    
    fileprivate class func removeRandomPrefix(_ data: Data) -> Data {
        return data.subdata(in: 0..<data.count - 1)
    }
    
    class func encrypt(_ object: AnyObject) -> Data {
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        return addRandomPrefix(objectData)
    }
    
    class func decrypt(_ data: Data) -> AnyObject? {
        let objectData = removeRandomPrefix(data)
        let object = NSKeyedUnarchiver.unarchiveObject(with: objectData)
        return object as AnyObject?
    }
}
