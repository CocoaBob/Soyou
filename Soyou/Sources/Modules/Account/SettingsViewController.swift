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
                        title: Text(text: NSLocalizedString("settings_vc_cell_about"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showAbout()
                        }
                    ),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_credits"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showCredits()
                        }
                    ),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_feedback"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.sendFeedback()
                        }
                    ),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .DisclosureIndicator, separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_review"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
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
                        cell: Cell(height: 44, tintColor: nil, accessoryType: .None, separatorInset: nil),
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_clear_cache"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
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
    
    func showAbout() {
        
    }
    
    func showCredits() {
        let simpleViewController = SimpleTableViewController()
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: simpleViewController, action: "doneAction")
        simpleViewController.title = NSLocalizedString("settings_vc_cell_credits")
        // Data
        simpleViewController.sections = [
            Section(
                title: nil,
                rows: [
                    Row(type: .IconTitle,
                        cell: Cell(height: 108, tintColor: nil, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_jiyun"),
                        title: Text(text: "Jiyun\nGeneral Manager", placeholder: nil, color: UIColor.darkGrayColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: nil
                    ),
                    Row(type: .IconTitle,
                        cell: Cell(height: 108, tintColor: nil, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_cocoabob"),
                        title: Text(text: "CocoaBob\nDeveloper", placeholder: nil, color: UIColor.darkGrayColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: nil
                    ),
                    Row(type: .IconTitle,
                        cell: Cell(height: 108, tintColor: nil, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_chenglian"),
                        title: Text(text: "Chenglian\nCreative Director", placeholder: nil, color: UIColor.darkGrayColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        userInfo: nil,
                        didSelect: nil
                    ),
                    Row(type: .IconTitle,
                        cell: Cell(height: 108, tintColor: nil, accessoryType: .None, separatorInset: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)),
                        image: UIImage(named: "img_credits_niuniu"),
                        title: Text(text: "Niuniu\nCreative Director", placeholder: nil, color: UIColor.darkGrayColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
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