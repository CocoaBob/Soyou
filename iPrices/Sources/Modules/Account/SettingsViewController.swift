//
//  SettingsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 19/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class SettingsViewController: SimpleTableViewController {
    
    @IBOutlet var imgViewAvatar: UIImageView!
    
    var cacheSize: Double = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("settings_vc_title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissSelf")
        
        // Background Color
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
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_about_us"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        tintColor: nil,
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showAboutUs()
                        }
                    ),
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_about_app"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        tintColor: nil,
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showAboutApp()
                        }
                    ),
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_feedback"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        tintColor: nil,
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.sendFeedback()
                        }
                    ),
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_review"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        tintColor: nil,
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.review()
                        }
                    )
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(type: .CenterTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_clear_cache"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        tintColor: nil,
                        accessoryType: .None,
                        separatorInset: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.cleanCache()
                        }
                    )
                ]
            )
        ]
    }
}

// MARK: Cell actions
extension SettingsViewController {
    
    func showAboutUs() {
        
    }
    
    func showAboutApp() {
        
    }
    
    func sendFeedback() {
        Utils.shared.sendFeedbackEmail(self)
    }
    
    func review() {
        Utils.shared.openAppStorePage()
    }
    
    func cleanCache() {
        self.updateCacheSize(nil)
        
        // Delete cached NSURL responses
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        // Delete expired disk caches
        SDImageCache.sharedImageCache().cleanDiskWithCompletionBlock { () -> Void in
            // Delete disk caches
            SDImageCache.sharedImageCache().clearDiskOnCompletion { () -> Void in
                self.calculateCacheSize()
            }
        }
    }
}

// MARK: Routines
extension SettingsViewController {
    
    func updateCacheSize(cacheSize: Double?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // Size in string
            let strSize = cacheSize != nil ? FmtString("%.2f MB", cacheSize! / 1000000.0) : "..."

            // Update table
            var row = self.sections[1].rows[0]
            row.title?.text = cacheSize != nil ? (NSLocalizedString("settings_vc_cell_clear_cache") + " (" + strSize + ")") : NSLocalizedString("settings_vc_cell_clearing_cache")
            self.sections[1].rows = [row]
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