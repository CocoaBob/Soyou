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
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("settings_vc_cell_clean_cache"),
                        titleColor: nil,
                        cell: .IconTitle,
                        callback: nil)
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("settings_vc_cell_about"),
                        titleColor: nil,
                        cell: .IconTitle,
                        callback: nil),
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("settings_vc_cell_feedback"),
                        titleColor: nil,
                        cell: .IconTitle,
                        callback: nil)
                ]
            )
        ]
    }
}

// MARK: Cell actions
extension SettingsViewController {
    
}

// MARK: Routines
extension SettingsViewController {
    
}