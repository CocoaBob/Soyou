//
//  SettingsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 19/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class SettingsViewController: SimpleTableViewController {
    
    @IBOutlet var imgViewAvatar: UIImageView!
    
    var cacheSize: Double = 0
    
    private var locationManager: CLLocationManager?
    private var registerPushNotificationTimer: NSTimer?
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = true
        
        // UIViewController
        self.title = NSLocalizedString("settings_vc_title")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(UIViewController.dismissSelf))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Register notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsViewController.applicationWillResignActiveNotification), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsViewController.applicationDidBecomeActiveNotification), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Unregister notification
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
}

// MARK: Build hierarchy
extension SettingsViewController {
    
    override func rebuildTable() {
        let application = UIApplication.sharedApplication()
        // Gether info about Push Notifications
        let registeredTypes = application.currentUserNotificationSettings()?.types
        let isRegisteredForNotifications = application.isRegisteredForRemoteNotifications()
        var notificationTypes = [String]()
        if registeredTypes?.contains(UIUserNotificationType.Badge) == true {
            notificationTypes.append(NSLocalizedString("settings_vc_cell_notification_badge"))
        }
        if registeredTypes?.contains(UIUserNotificationType.Sound) == true {
            notificationTypes.append(NSLocalizedString("settings_vc_cell_notification_sound"))
        }
        if registeredTypes?.contains(UIUserNotificationType.Alert) == true {
            notificationTypes.append(NSLocalizedString("settings_vc_cell_notification_banner"))
        }
        let notificationTypesString = notificationTypes.joinWithSeparator(",")
        var notificationSubTitle = isRegisteredForNotifications ? NSLocalizedString("settings_vc_cell_notification_enabled") : NSLocalizedString("settings_vc_cell_notification_not_enabled")
        if isRegisteredForNotifications && notificationTypes.count != 3 {
            notificationSubTitle = notificationTypesString
        }
        // Create datasource
        self.sections = [
            Section(
                rows: [
                    Row(type: .LeftTitleRightDetail,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("settings_vc_cell_currency")),
                        subTitle: Text(text: CurrencyManager.shared.userCurrencyName),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeMyCurrency()
                    }),
                    Row(type: .LeftTitleRightDetail,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("settings_vc_cell_language")),
                        subTitle: Text(text: CurrencyManager.shared.languageName(NSLocale.preferredLanguages().first ?? "")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeLanguage()
                    })
                ]
            ),
            Section(
                rows: [
                    Row(type: .LeftTitleRightDetail,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator, selectionStyle: .Default),
                        title: Text(text: NSLocalizedString("settings_vc_cell_notification")),
                        subTitle: Text(text: notificationSubTitle),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.registerPushNotification()
                    }),
                    Row(type: .LeftTitleRightDetail,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator, selectionStyle: .Default),
                        title: Text(text: NSLocalizedString("settings_vc_cell_localization")),
                        subTitle: Text(text: self.locationServiceStatus()),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.requestLocationServicePermission()
                    })
                ]
            ),
            Section(
                rows: [
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("settings_vc_cell_intro")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            IntroViewController.shared.showIntroView()
                    }),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("settings_vc_cell_about")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showAbout()
                    }),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("settings_vc_cell_credits")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showCredits()
                    }),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("settings_vc_cell_feedback")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.sendFeedback()
                    }),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("settings_vc_cell_analyze_network")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.analyzeNetwork()
                    }),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("settings_vc_cell_review")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.review()
                    }),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("settings_vc_cell_share")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.share()
                    }),
                ]
            ),
            Section(
                rows: [
                    Row(type: .CenterTitle,
                        cell: Cell(height: 44, accessoryType: .None),
                        title: Text(text: NSLocalizedString("settings_vc_cell_clear_cache")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.clearCache()
                    })
                ]
            )
        ]
    }
}

// MARK: Cell actions
extension SettingsViewController {
    
    func showAbout() {
        let simpleViewController = SimpleTableViewController(tableStyle: .Plain)
        // UI
        simpleViewController.title = NSLocalizedString("settings_vc_cell_about")
        let _ = simpleViewController.view
        simpleViewController.tableView.separatorStyle = .None
        // Data
        var title = "\n" + NSLocalizedString("app_about_title")
        if let shortVersionString = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString" as String) as? String {
            title += " v" + shortVersionString
        }
        if let version = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String {
            title += "(\(version))"
        }
        simpleViewController.sections = [
            Section(
                rows: [
                    Row(type: .IconTitleContent,
                        cell: Cell(accessoryType: .None),
                        title: Text(text: title, font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 17), color: UIColor.darkGrayColor()),
                        subTitle: Text(text: NSLocalizedString("app_about_content") + "\n", font: UIFont.systemFontOfSize(16), color: UIColor.grayColor())
                    )
                ]
            )
        ]
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func showCredits() {
        let simpleViewController = SimpleTableViewController(tableStyle: .Plain)
        // UI
        simpleViewController.title = NSLocalizedString("settings_vc_cell_credits")
        // Data
        simpleViewController.sections = [
            Section(
                rows: [
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_jiyun"),
                        title: Text(text: "\nJiyun", font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGrayColor()),
                        subTitle: Text(text: "General Developer", font: UIFont.systemFontOfSize(13), color: UIColor.grayColor())
                    ),
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_cocoabob"),
                        title: Text(text: "\nCocoaBob", font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGrayColor()),
                        subTitle: Text(text: "iOS Developer", font: UIFont.systemFontOfSize(13), color: UIColor.grayColor())
                    ),
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_chenglian"),
                        title: Text(text: "\nChenglian", font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGrayColor()),
                        subTitle: Text(text: "Creative Director", font: UIFont.systemFontOfSize(13), color: UIColor.grayColor())
                    ),
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_niuniu"),
                        title: Text(text: "\nNiuniu", font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGrayColor()),
                        subTitle: Text(text: "Villain Creature", font: UIFont.systemFontOfSize(13), color: UIColor.grayColor())
                    )
                ]
            )
        ]
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func sendFeedback() {
        MBProgressHUD.showLoader(self.view)
        Utils.shared.sendFeedbackEmail(self, attachments: ["SystemDiagnostic.zip": Utils.compressData("SystemDiagnostic.txt", Utils.systemDiagnosticData())])
        MBProgressHUD.hideLoader(self.view)
    }
    
    func analyzeNetwork() {
        Utils.shared.sendDiagnosticReport(self)
    }
    
    func review() {
        Utils.openAppStorePage()
    }
    
    func share() {
        Utils.shareApp()
    }
    
    func changeLanguage() {
        var currentLanguageSelection: String?
        let simpleViewController = SimpleTableViewController(tableStyle: .Plain)
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: simpleViewController, action: #selector(SimpleTableViewController.doneAction))
        simpleViewController.navigationItem.rightBarButtonItem?.enabled = false
        simpleViewController.title = NSLocalizedString("settings_vc_cell_language")
        // Data
        let langCode = [("zh-Hans", "CN"), ("en-US", "GB")]
        // Prepare rows
        var rows = [Row]()
        for (langCode, countryCode) in langCode {
            let row = Row(type: .IconTitle,
                cell: Cell(height: 44, tintColor: UIColor(white: 0.15, alpha: 1), accessoryType: .None),
                image: UIImage(flagImageWithCountryCode: countryCode),
                title: Text(text: CurrencyManager.shared.languageName(langCode) ?? ""),
                userInfo: ["language":langCode],
                didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                    let row = simpleViewController.sections[indexPath.section].rows[indexPath.row]
                    simpleViewController.navigationItem.rightBarButtonItem?.enabled = (row.title?.text != currentLanguageSelection)
                    if simpleViewController.updateSelectionCheckmark(indexPath) {
                        var rowsToReload = [indexPath]
                        if let selectedIndexPath = simpleViewController.selectedIndexPath {
                            rowsToReload.append(selectedIndexPath)
                        }
                        simpleViewController.tableView.beginUpdates()
                        simpleViewController.tableView.reloadRowsAtIndexPaths(rowsToReload, withRowAnimation: .Fade)
                        simpleViewController.tableView.endUpdates()
                    }
            })
            rows.append(row)
        }
        simpleViewController.sections = [
            Section(
                rows: rows
            )
        ]
        if let currentLanguageCode = NSLocale.preferredLanguages().first {
            let selectedRow = currentLanguageCode.hasPrefix("zh") ? 0 : 1
            simpleViewController.selectedIndexPath = NSIndexPath(forRow: selectedRow, inSection: 0)
            currentLanguageSelection = simpleViewController.sections.first?.rows[selectedRow].title?.text
            simpleViewController.updateSelectionCheckmark(simpleViewController.selectedIndexPath!)
        }
        
        // Handler
        simpleViewController.completion = { () -> () in
            if let selectedIndexPath = simpleViewController.selectedIndexPath,
                rows = simpleViewController.sections.first?.rows {
                    let row = rows[selectedIndexPath.row]
                    if let userInfo = row.userInfo,
                        regionCode = userInfo["language"] as? String {
                            // Set language
                            UserDefaults.setObject([regionCode], forKey: "AppleLanguages")
                            
                        let alertView = SCLAlertView()
                        alertView.addButton(NSLocalizedString("settings_vc_cell_language_set_done")) { () -> Void in
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        alertView.showSuccess(UIApplication.sharedApplication().keyWindow?.rootViewController?.toppestViewController(),
                                              title: NSLocalizedString("settings_vc_cell_language_set_title"),
                                              subTitle: NSLocalizedString("settings_vc_cell_language_set_subtitle"),
                                              closeButtonTitle: nil,
                                              duration: 0.0)
                    }
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func changeMyCurrency() {
        let simpleViewController = SimpleTableViewController(tableStyle: .Plain)
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: simpleViewController, action: #selector(SimpleTableViewController.doneAction))
        simpleViewController.navigationItem.rightBarButtonItem?.enabled = false
        simpleViewController.title = NSLocalizedString("settings_vc_cell_choose_currency")
        // Data
        var rows = [Row]()
        let allCurrencyCountryPairs = CurrencyManager.shared.allCurrencyCountryPairs()
        let allCurrencyCodes = CurrencyManager.shared.allCurrencyCodes()
        var allCurrencyNameCodePairs = [String:String]()
        for currencyCode in allCurrencyCodes {
            if let currencyName = CurrencyManager.shared.currencyNameFromCurrencyCode(currencyCode) {
                allCurrencyNameCodePairs[currencyName] = currencyCode
            }
        }
        var sortedCurrencyNames: [String] = allCurrencyNameCodePairs.map { $0.0 }
        sortedCurrencyNames.sortInPlace {
            $0.compare($1, options: [.CaseInsensitiveSearch, .DiacriticInsensitiveSearch], locale: CurrencyManager.shared.displayLocale) == .OrderedAscending
        }
        
        for currencyName in sortedCurrencyNames {
            var countryCode: String?
            if let currencyCode = allCurrencyNameCodePairs[currencyName] {
                countryCode = allCurrencyCountryPairs[currencyCode]
            }
            var image: UIImage?
            if let countryCode = countryCode {
                if countryCode == "EU" {
                    image = UIImage(flagImageForSpecialFlag: "EU")
                } else {
                    image = UIImage(flagImageWithCountryCode: countryCode)
                }
            }
            let row = Row(type: .IconTitle,
                cell: Cell(height: 44, tintColor: UIColor(white: 0.15, alpha: 1), accessoryType: .None),
                image: image,
                title: Text(text: currencyName),
                didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                    let selectedCurrencyName = sortedCurrencyNames[indexPath.row]
                    simpleViewController.navigationItem.rightBarButtonItem?.enabled = (selectedCurrencyName != CurrencyManager.shared.userCurrencyName)
                    if simpleViewController.updateSelectionCheckmark(indexPath) {
                        var rowsToReload = [indexPath]
                        if let selectedIndexPath = simpleViewController.selectedIndexPath {
                            rowsToReload.append(selectedIndexPath)
                        }
                        simpleViewController.tableView.beginUpdates()
                        simpleViewController.tableView.reloadRowsAtIndexPaths(rowsToReload, withRowAnimation: .Fade)
                        simpleViewController.tableView.endUpdates()
                    }
            })
            rows.append(row)
        }
        simpleViewController.sections = [
            Section(
                rows: rows
            )
        ]
        
        if let index = sortedCurrencyNames.indexOf(CurrencyManager.shared.userCurrencyName) {
            simpleViewController.selectedIndexPath = NSIndexPath(forRow: index, inSection: 0)
            simpleViewController.updateSelectionCheckmark(simpleViewController.selectedIndexPath!)
        }
        // Handler
        simpleViewController.completion = { () -> () in
            if let selectedIndexPath = simpleViewController.selectedIndexPath {
                guard let selectedCurrencyCode = allCurrencyNameCodePairs[sortedCurrencyNames[selectedIndexPath.row]] else {
                    return
                }
                
                // Set user currency
                MBProgressHUD.showLoader(nil)
                CurrencyManager.shared.updateCurrencyRates(selectedCurrencyCode) { (responseObject, error) -> () in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        MBProgressHUD.hideLoader(nil)
                        if let error = error {
                            DataManager.showRequestFailedAlert(error)
                        } else {
                            simpleViewController.navigationController?.popViewControllerAnimated(true)
                            CurrencyManager.shared.userCurrency = selectedCurrencyCode ?? ""
                        }
                    })
                }
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func openSettings() {
        if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func clearCache() {
        self.updateCacheSize(nil)
        
        // Delete cached NSURL responses
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        // Delete disk caches
        SDImageCache.sharedImageCache().clearDiskOnCompletion { () -> Void in
            self.calculateCacheSize()
        }
    }
}

// MARK: Request permissions
extension SettingsViewController {
    
    func registerPushNotification() {
        self.registerPushNotificationTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(SettingsViewController.finishedRequestingNotifications), userInfo: nil, repeats: false)
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil))
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func applicationWillResignActiveNotification() {
        self.registerPushNotificationTimer?.invalidate()
    }
    
    func applicationDidBecomeActiveNotification() {
        self.refreshUI()
    }
    
    func finishedRequestingNotifications() {
        self.registerPushNotificationTimer?.invalidate()
        self.openSettings()
    }
    
    func requestLocationServicePermission() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.requestWhenInUseAuthorization()
        } else {
            self.openSettings()
        }
    }
}

// MARK: Routines
extension SettingsViewController {
    
    func updateCacheSize(cacheSize: Double?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // Size in string
            let strSize = cacheSize != nil ? FmtString("%.2f MB", cacheSize! / 1048576.0) : "..."
            
            // Update table
            var row = self.sections[3].rows[0]
            row.title?.text = cacheSize != nil ? (NSLocalizedString("settings_vc_cell_clear_cache") + " (" + strSize + ")") : NSLocalizedString("settings_vc_cell_clearing_cache")
            self.sections[3].rows = [row]
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 3)], withRowAnimation: .Fade)
        })
    }
    
    func calculateCacheSize() {
        // NSURLCache
        self.cacheSize = Double(NSURLCache.sharedURLCache().currentDiskUsage)
        
        // SDImageCache
        SDImageCache.sharedImageCache().calculateSizeWithCompletionBlock { (fileCount, totalSize) -> Void in
            self.cacheSize += Double(totalSize)
            self.updateCacheSize(self.cacheSize)
        }
    }
    
    func refreshUI() {
        // Reload table in case UserInfo is updated
        rebuildTable()
        self.tableView.reloadData()
        
        // Update cache size
        self.calculateCacheSize()
    }
}

// MARK: Location Service
extension SettingsViewController: CLLocationManagerDelegate {
    
    func locationServiceStatus() -> String {
        return NSLocalizedString((CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) ? "settings_vc_cell_localization_enabled" : "settings_vc_cell_localization_not_enabled")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.rebuildTable()
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: .Fade)
        }
    }
}
