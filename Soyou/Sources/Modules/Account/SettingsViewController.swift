//
//  SettingsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 19/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class SettingsViewController: SimpleTableViewController {
    
    var cacheSize: Double = 0
    
    fileprivate var locationManager: CLLocationManager?
    fileprivate var registerPushNotificationTimer: Timer?
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = true
        
        // UIViewController
        self.title = NSLocalizedString("settings_vc_title")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIViewController.dismissSelf))
        
        // Setup STG mode toggling gesture
        let doubleDoubleGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(SettingsViewController.toggleSTGMode))
        doubleDoubleGesture.numberOfTapsRequired = 10
        doubleDoubleGesture.numberOfTouchesRequired = 2
        self.tableView.addGestureRecognizer(doubleDoubleGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Register notification
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.applicationWillResignActiveNotification), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.applicationDidBecomeActiveNotification), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Unregister notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
}

// MARK: Build hierarchy
extension SettingsViewController {
    
    override func rebuildTable() {
        let application = UIApplication.shared
        // Gether info about Push Notifications
        let registeredTypes = application.currentUserNotificationSettings?.types
        let isRegisteredForNotifications = application.isRegisteredForRemoteNotifications
        var notificationTypes = [String]()
        if registeredTypes?.contains(UIUserNotificationType.badge) == true {
            notificationTypes.append(NSLocalizedString("settings_vc_cell_notification_badge"))
        }
        if registeredTypes?.contains(UIUserNotificationType.sound) == true {
            notificationTypes.append(NSLocalizedString("settings_vc_cell_notification_sound"))
        }
        if registeredTypes?.contains(UIUserNotificationType.alert) == true {
            notificationTypes.append(NSLocalizedString("settings_vc_cell_notification_banner"))
        }
        let notificationTypesString = notificationTypes.joined(separator: ",")
        var notificationSubTitle = isRegisteredForNotifications ? NSLocalizedString("settings_vc_cell_notification_enabled") : NSLocalizedString("settings_vc_cell_notification_not_enabled")
        if isRegisteredForNotifications && notificationTypes.count != 3 {
            notificationSubTitle = notificationTypesString
        }
        // Create DataSource
        var sections = [Section]()
        // Regions
        sections.append(Section(
            rows: [
                Row(type: .LeftTitleRightDetail,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                    title: Text(text: NSLocalizedString("settings_vc_cell_currency")),
                    subTitle: Text(text: CurrencyManager.shared.userCurrencyName),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.changeMyCurrency()
                }),
                Row(type: .LeftTitleRightDetail,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                    title: Text(text: NSLocalizedString("settings_vc_cell_language")),
                    subTitle: Text(text: CurrencyManager.shared.languageName(Locale.preferredLanguages.first ?? "")),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.changeLanguage()
                })
            ]
        ))
        // System Settings
        sections.append(Section(
            rows: [
                Row(type: .LeftTitleRightDetail,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator, selectionStyle: .default),
                    title: Text(text: NSLocalizedString("settings_vc_cell_notification")),
                    subTitle: Text(text: notificationSubTitle),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.registerPushNotification()
                }),
                Row(type: .LeftTitleRightDetail,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator, selectionStyle: .default),
                    title: Text(text: NSLocalizedString("settings_vc_cell_localization")),
                    subTitle: Text(text: self.locationServiceStatus()),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.requestLocationServicePermission()
                })
            ]
        ))
        // MISC
        sections.append(Section(
            rows: [
                Row(type: .LeftTitle,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                    title: Text(text: NSLocalizedString("settings_vc_cell_intro")),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        IntroViewController.shared.showIntroView()
                }),
                Row(type: .LeftTitle,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                    title: Text(text: NSLocalizedString("settings_vc_cell_about")),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.showAbout()
                }),
                Row(type: .LeftTitle,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                    title: Text(text: NSLocalizedString("settings_vc_cell_credits")),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.showCredits()
                }),
                Row(type: .LeftTitle,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                    title: Text(text: NSLocalizedString("settings_vc_cell_feedback")),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.sendFeedback()
                }),
//                Row(type: .LeftTitle,
//                    cell: Cell(height: 44, accessoryType: .disclosureIndicator),
//                    title: Text(text: NSLocalizedString("settings_vc_cell_analyze_network")),
//                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
//                        self.analyzeNetwork()
//                }),
                Row(type: .LeftTitle,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                    title: Text(text: NSLocalizedString("settings_vc_cell_review")),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.review()
                }),
                Row(type: .LeftTitle,
                    cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                    title: Text(text: NSLocalizedString("settings_vc_cell_share")),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.shareURL()
                }),
                ]
        ))
        // Clear Cache
        sections.append(Section(
            rows: [
                Row(type: .CenterTitle,
                    cell: Cell(height: 44, accessoryType: .none),
                    title: Text(text: NSLocalizedString("settings_vc_cell_clear_cache")),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.clearCache()
                })
            ]
        ))
        // Testing
        if Utils.isSTGMode() {
            sections.append(Section(
                rows: [
                    Row(type: .CenterTitle,
                        cell: Cell(height: 44, accessoryType: .none),
                        title: Text(text: "Test new version"),
                        didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            Utils.shared.showNewVersionAvailable()
                    })
                ]
            ))
        }
        // Apply DataSource
        self.sections = sections
    }
}

// MARK: Cell actions
extension SettingsViewController {
    
    func showAbout() {
        let simpleViewController = SimpleTableViewController(tableStyle: .grouped)
        // UI
        simpleViewController.title = NSLocalizedString("settings_vc_cell_about")
        let _ = simpleViewController.view
        simpleViewController.tableView.separatorStyle = .none
        // Data
        var title = "\n" + NSLocalizedString("app_about_title")
        if let shortVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) as? String {
            title += " v" + shortVersionString
        }
        if let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            title += "(\(version))"
        }
        simpleViewController.sections = [
            Section(
                rows: [
                    Row(type: .IconTitleContent,
                        cell: Cell(accessoryType: .none),
                        title: Text(text: title, font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 17), color: UIColor.darkGray),
                        subTitle: Text(text: NSLocalizedString("app_about_content") + "\n", font: UIFont.systemFont(ofSize: 16), color: UIColor.gray)
                    )
                ]
            )
        ]
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func showCredits() {
        let simpleViewController = SimpleTableViewController(tableStyle: .grouped)
        // UI
        simpleViewController.title = NSLocalizedString("settings_vc_cell_credits")
        // Data
        simpleViewController.sections = [
            Section(
                rows: [
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), accessoryType: .none),
                        image: UIImage(named: "img_credits_jiyun"),
                        title: Text(text: "\nJiyun", font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGray),
                        subTitle: Text(text: "General Developer", font: UIFont.systemFont(ofSize: 13), color: UIColor.gray)
                    ),
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), accessoryType: .none),
                        image: UIImage(named: "img_credits_cocoabob"),
                        title: Text(text: "\nCocoaBob", font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGray),
                        subTitle: Text(text: "iOS Developer", font: UIFont.systemFont(ofSize: 13), color: UIColor.gray)
                    ),
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), accessoryType: .none),
                        image: UIImage(named: "img_credits_chenglian"),
                        title: Text(text: "\nChenglian", font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGray),
                        subTitle: Text(text: "Creative Director", font: UIFont.systemFont(ofSize: 13), color: UIColor.gray)
                    ),
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, separatorInset: UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0), accessoryType: .none),
                        image: UIImage(named: "img_credits_niuniu"),
                        title: Text(text: "\nNiuniu", font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGray),
                        subTitle: Text(text: "Villain Creature", font: UIFont.systemFont(ofSize: 13), color: UIColor.gray)
                    )
                ]
            )
        ]
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func sendFeedback() {
        MBProgressHUD.show(self.view)
        Utils.shared.sendFeedbackEmail(self, attachments: ["SystemDiagnostic.zip": Utils.compressData("SystemDiagnostic.txt", Utils.systemDiagnosticData())])
        MBProgressHUD.hide(self.view)
    }
    
    func analyzeNetwork() {
        Utils.shared.sendDiagnosticReport(self)
    }
    
    func review() {
        Utils.openAppStorePage()
    }
    
    func shareURL() {
        Utils.shareApp()
    }
    
    func changeLanguage() {
        var currentLanguageSelection: String?
        let simpleViewController = SimpleTableViewController(tableStyle: .grouped)
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: simpleViewController, action: #selector(SimpleTableViewController.doneAction))
        simpleViewController.navigationItem.rightBarButtonItem?.isEnabled = false
        simpleViewController.title = NSLocalizedString("settings_vc_cell_language")
        // Data
        let langCode = [("zh-Hans", "CN"), ("en-US", "GB")]
        // Prepare rows
        var rows = [Row]()
        for (langCode, countryCode) in langCode {
            let row = Row(type: .IconTitle,
                          cell: Cell(height: 44, tintColor: UIColor(white: 0.15, alpha: 1), accessoryType: .none),
                          image: Flag(countryCode: countryCode)?.image(style: .roundedRect),
                          title: Text(text: CurrencyManager.shared.languageName(langCode) ?? ""),
                          userInfo: ["language":langCode],
                          didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            let row = simpleViewController.sections[indexPath.section].rows[indexPath.row]
                            simpleViewController.navigationItem.rightBarButtonItem?.isEnabled = (row.title?.text != currentLanguageSelection)
                            if simpleViewController.updateSelectionCheckmark(indexPath) {
                                var rowsToReload = [indexPath]
                                if let selectedIndexPath = simpleViewController.selectedIndexPath {
                                    rowsToReload.append(selectedIndexPath)
                                }
                                simpleViewController.tableView.beginUpdates()
                                simpleViewController.tableView.reloadRows(at: rowsToReload, with: .fade)
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
        if let currentLanguageCode = Locale.preferredLanguages.first {
            let selectedRow = currentLanguageCode.hasPrefix("zh") ? 0 : 1
            simpleViewController.selectedIndexPath = IndexPath(row: selectedRow, section: 0)
            currentLanguageSelection = simpleViewController.sections.first?.rows[selectedRow].title?.text
            simpleViewController.updateSelectionCheckmark(simpleViewController.selectedIndexPath!)
        }
        
        // Handler
        simpleViewController.completion = { () -> () in
            if let selectedIndexPath = simpleViewController.selectedIndexPath,
                let rows = simpleViewController.sections.first?.rows {
                    let row = rows[selectedIndexPath.row]
                    if let userInfo = row.userInfo,
                        let regionCode = userInfo["language"] as? String {
                        // Set language
                        UserDefaults.setObject([regionCode], forKey: "AppleLanguages")
                        UIAlertController.presentAlert(from: self,
                                                       title: NSLocalizedString("settings_vc_cell_language_set_title"),
                                                       message: NSLocalizedString("settings_vc_cell_language_set_subtitle"),
                                                       UIAlertAction(title: NSLocalizedString("settings_vc_cell_language_set_done"),
                                                                     style: UIAlertActionStyle.default,
                                                                     handler: { (action: UIAlertAction) -> Void in
                                                                        self.navigationController?.popViewController(animated: true)
                                                       }))
                    }
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func changeMyCurrency() {
        let simpleViewController = SimpleTableViewController(tableStyle: .grouped)
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: simpleViewController, action: #selector(SimpleTableViewController.doneAction))
        simpleViewController.navigationItem.rightBarButtonItem?.isEnabled = false
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
        sortedCurrencyNames.sort {
            $0.compare($1, options: [.caseInsensitive, .diacriticInsensitive], locale: CurrencyManager.shared.displayLocale) == .orderedAscending
        }
        
        for currencyName in sortedCurrencyNames {
            var countryCode: String?
            if let currencyCode = allCurrencyNameCodePairs[currencyName] {
                countryCode = allCurrencyCountryPairs[currencyCode]
            }
            var image: UIImage?
            if let countryCode = countryCode {
                image = Flag(countryCode: countryCode)?.image(style: .roundedRect)
            }
            let row = Row(type: .IconTitle,
                cell: Cell(height: 44, tintColor: UIColor(white: 0.15, alpha: 1), accessoryType: .none),
                image: image,
                title: Text(text: currencyName),
                didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                    let selectedCurrencyName = sortedCurrencyNames[indexPath.row]
                    simpleViewController.navigationItem.rightBarButtonItem?.isEnabled = (selectedCurrencyName != CurrencyManager.shared.userCurrencyName)
                    if simpleViewController.updateSelectionCheckmark(indexPath) {
                        var rowsToReload = [indexPath]
                        if let selectedIndexPath = simpleViewController.selectedIndexPath {
                            rowsToReload.append(selectedIndexPath)
                        }
                        simpleViewController.tableView.beginUpdates()
                        simpleViewController.tableView.reloadRows(at: rowsToReload, with: .fade)
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
        
        if let index = sortedCurrencyNames.index(of: CurrencyManager.shared.userCurrencyName) {
            simpleViewController.selectedIndexPath = IndexPath(row: index, section: 0)
            simpleViewController.updateSelectionCheckmark(simpleViewController.selectedIndexPath!)
        }
        // Handler
        simpleViewController.completion = { () -> () in
            if let selectedIndexPath = simpleViewController.selectedIndexPath {
                guard let selectedCurrencyCode = allCurrencyNameCodePairs[sortedCurrencyNames[selectedIndexPath.row]] else {
                    return
                }
                
                // Set user currency
                MBProgressHUD.show()
                CurrencyManager.shared.updateCurrencyRates(selectedCurrencyCode) { (responseObject, error) -> () in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide()
                        if let error = error {
                            DataManager.showRequestFailedAlert(error)
                        } else {
                            simpleViewController.navigationController?.popViewController(animated: true)
                            CurrencyManager.shared.userCurrency = selectedCurrencyCode 
                        }
                    }
                }
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func clearCache() {
        self.updateCacheSize(nil)
        
        // Delete cached NSURL responses
        URLCache.shared.removeAllCachedResponses()
        
        // Delete disk caches
        SDImageCache.shared().clearDisk { () -> Void in
            self.calculateCacheSize()
        }
    }
}

// MARK: Request permissions
extension SettingsViewController {
    
    func registerPushNotification() {
        self.registerPushNotificationTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(SettingsViewController.finishedRequestingNotifications), userInfo: nil, repeats: false)
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    @objc func applicationWillResignActiveNotification() {
        self.registerPushNotificationTimer?.invalidate()
    }
    
    @objc func applicationDidBecomeActiveNotification() {
        self.refreshUI()
    }
    
    @objc func finishedRequestingNotifications() {
        self.registerPushNotificationTimer?.invalidate()
        self.openSettings()
    }
    
    func requestLocationServicePermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
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
    
    func updateCacheSize(_ cacheSize: Double?) {
        DispatchQueue.main.async {
            // Size in string
            let strSize = cacheSize != nil ? FmtString("%.2f MB", cacheSize! / 1048576.0) : "..."
            
            // Update table
            var row = self.sections[3].rows[0]
            row.title?.text = cacheSize != nil ? (NSLocalizedString("settings_vc_cell_clear_cache") + " (" + strSize + ")") : NSLocalizedString("settings_vc_cell_clearing_cache")
            self.sections[3].rows = [row]
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
        }
    }
    
    func calculateCacheSize() {
        // URLCache
        self.cacheSize = Double(URLCache.shared.currentDiskUsage)
        
        // SDImageCache
        SDImageCache.shared().calculateSize { (fileCount, totalSize) -> Void in
            self.cacheSize += Double(totalSize)
            self.updateCacheSize(self.cacheSize)
        }
    }
    
    func refreshUI() {
        // Reload table in case UserInfo is updated
        rebuildTable()
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            self.tableView.reloadRows(at: indexPaths, with: .fade)
        }
        
        // Update cache size
        self.calculateCacheSize()
    }
}

// MARK: Location Service
extension SettingsViewController: CLLocationManagerDelegate {
    
    func locationServiceStatus() -> String {
        return NSLocalizedString((CLLocationManager.authorizationStatus() == .authorizedWhenInUse) ? "settings_vc_cell_localization_enabled" : "settings_vc_cell_localization_not_enabled")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.rebuildTable()
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
        }
    }
}

// MARK: STG Mode
extension SettingsViewController {
    
    @objc func toggleSTGMode() {
        // Update setting
        UserDefaults.setBool(!Utils.isSTGMode(), forKey: Cons.App.isSTGMode)
        // Clear network cache
        URLCache.shared.removeAllCachedResponses()
        // Reinitialize url
        RequestManager.shared.initRequestOperationManager()
        // Logout the current user
        UserManager.shared.logOut()
        // Update status bar color
        (UIApplication.shared.delegate as? AppDelegate)?.setupOverlayWindow()
        // Update table
        self.rebuildTable()
        self.tableView.reloadData()
    }
}
