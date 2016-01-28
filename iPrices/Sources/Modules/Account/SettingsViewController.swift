//
//  SettingsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 19/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class SettingsViewController: SimpleTableViewController {
    
    @IBOutlet var imgViewAvatar: UIImageView!
    
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
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showAboutUs()
                        }
                    ),
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_about_app"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showAboutApp()
                        }
                    ),
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_feedback"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.sendFeedback()
                        }
                    ),
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_review"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
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
                        title: Text(text: NSLocalizedString("settings_vc_cell_clean_cache"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        accessoryType: .None,
                        separatorInset: nil,
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
        
    }
    
    func review() {
        
    }
    
    func cleanCache() {
        
    }
}

// MARK: Routines
extension SettingsViewController {
    
}