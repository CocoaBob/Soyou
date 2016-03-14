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
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = true
        
        // UIViewController
        self.title = NSLocalizedString("settings_vc_title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissSelf")
        
        // Setup tableview
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor(rgba: Cons.UI.colorBG)
        
        // Update cache size
        self.calculateCacheSize()
    }
}

// MARK: Build hierarchy
extension SettingsViewController {
    
    override func rebuildTable() {
        self.sections = [
            Section(
                title: nil,
                rows: [
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_language"), placeholder:nil, font: nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeLanguage()
                        }
                    ),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_my_currency"), placeholder:nil, font: nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeMyCurrency()
                        }
                    )
                    
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_intro"), placeholder:nil, font: nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            IntroViewController.shared.showIntroView()
                        }
                    ),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_about"), placeholder:nil, font: nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showAbout()
                        }
                    ),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_credits"), placeholder:nil, font: nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showCredits()
                        }
                    ),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_feedback"), placeholder:nil, font: nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.sendFeedback()
                        }
                    ),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_review"), placeholder:nil, font: nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.review()
                        }
                    ),
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(type: .CenterTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .None, separatorInset: nil),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_clear_cache"), placeholder:nil, font: nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.clearCache()
                        }
                    )
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
                title: " ",
                rows: [
                    Row(type: .IconTitleContent,
                        cell: Cell(height: nil, tintColor: nil, accessoryType: .None, separatorInset: nil),
                        image: nil,
                        title: Text(text: title, placeholder: nil, font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 17), color: UIColor.darkGrayColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: NSLocalizedString("app_about_content") + "\n", placeholder: nil, font: UIFont.systemFontOfSize(16), color: UIColor.grayColor(), keyboardType: nil, returnKeyType: nil),
                        userInfo: nil,
                        didSelect: nil
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
                title: " ",
                rows: [
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, tintColor: nil, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_jiyun"),
                        title: Text(text: "\nJiyun", placeholder: nil, font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGrayColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: "General Developer", placeholder: nil, font: UIFont.systemFontOfSize(13), color: UIColor.grayColor(), keyboardType: nil, returnKeyType: nil),
                        userInfo: nil,
                        didSelect: nil
                    ),
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, tintColor: nil, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_cocoabob"),
                        title: Text(text: "\nCocoaBob", placeholder: nil, font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGrayColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: "iOS Developer", placeholder: nil, font: UIFont.systemFontOfSize(13), color: UIColor.grayColor(), keyboardType: nil, returnKeyType: nil),
                        userInfo: nil,
                        didSelect: nil
                    ),
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, tintColor: nil, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_chenglian"),
                        title: Text(text: "\nChenglian", placeholder: nil, font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGrayColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: "Creative Director", placeholder: nil, font: UIFont.systemFontOfSize(13), color: UIColor.grayColor(), keyboardType: nil, returnKeyType: nil),
                        userInfo: nil,
                        didSelect: nil
                    ),
                    Row(type: .IconTitleContent,
                        cell: Cell(height: 108, tintColor: nil, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_niuniu"),
                        title: Text(text: "\nNiuniu", placeholder: nil, font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 16), color: UIColor.darkGrayColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: "Villain Creature", placeholder: nil, font: UIFont.systemFontOfSize(13), color: UIColor.grayColor(), keyboardType: nil, returnKeyType: nil),
                        userInfo: nil,
                        didSelect: nil
                    )
                ]
            )
        ]
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func sendFeedback() {
        Utils.shared.sendFeedbackEmail(self)
    }
    
    func review() {
        Utils.openAppStorePage()
    }
    
    func changeLanguage() {
        var currentLanguageSelection: String?
        let simpleViewController = SimpleTableViewController(tableStyle: .Plain)
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: simpleViewController, action: "doneAction")
        simpleViewController.navigationItem.rightBarButtonItem?.enabled = false
        simpleViewController.title = NSLocalizedString("settings_vc_cell_language")
        // Data
        let langCode = ["zh-Hans", "en-US"]
        // Prepare rows
        var rows = [Row]()
        for langCode in langCode {
            let row = Row(type: .LeftTitle,
                cell: Cell(height: 44, tintColor: UIColor(white: 0.15, alpha: 1), accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                image: nil,
                title: Text(text: CurrencyManager.shared.languageName(langCode) ?? "", placeholder: nil, font: nil, color: nil, keyboardType: .Default, returnKeyType: .Default),
                subTitle: nil,
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
                }
            )
            rows.append(row)
        }
        simpleViewController.sections = [
            Section(
                title: nil,
                rows: rows
            )
        ]
        if let currentLanguageCode = NSLocale.preferredLanguages().first {
            DLog(currentLanguageCode)
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
                            NSUserDefaults.standardUserDefaults().setObject([regionCode], forKey: "AppleLanguages")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            let alertView = SCLAlertView()
                            alertView.addButton(NSLocalizedString("settings_vc_cell_language_set_done")) { () -> Void in
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                            alertView.showCloseButton = false
                            alertView.showSuccess(NSLocalizedString("settings_vc_cell_language_set_title"), subTitle: NSLocalizedString("settings_vc_cell_language_set_subtitle"))
                    }
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func changeMyCurrency() {
        
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

// MARK: Routines
extension SettingsViewController {
    
    func updateCacheSize(cacheSize: Double?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // Size in string
            let strSize = cacheSize != nil ? FmtString("%.2f MB", cacheSize! / 1048576.0) : "..."

            // Update table
            var row = self.sections[2].rows[0]
            row.title?.text = cacheSize != nil ? (NSLocalizedString("settings_vc_cell_clear_cache") + " (" + strSize + ")") : NSLocalizedString("settings_vc_cell_clearing_cache")
            self.sections[2].rows = [row]
            self.tableView.reloadData()
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
}