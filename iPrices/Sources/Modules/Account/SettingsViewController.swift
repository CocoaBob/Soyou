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
        sections = [
            Section(
                title: nil,
                rows: [
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_about"), color: nil),
                        subTitle: Text(text: nil, color: nil),
                        callback: "showAbout",
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_feedback"), color: nil),
                        subTitle: Text(text: nil, color: nil),
                        callback: "sendFeedback",
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(type: .CenterTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("settings_vc_cell_clean_cache"), color: nil),
                        subTitle: Text(text: nil, color: nil),
                        callback: "cleanCache",
                        accessoryType: .None,
                        separatorInset: nil)
                ]
            )
        ]
    }
}

// MARK: Cell actions
extension SettingsViewController {
    
    func showAbout() {
        
    }
    
    func sendFeedback() {
        
    }
    
    func cleanCache() {
        
    }
}

// MARK: Routines
extension SettingsViewController {
    
}