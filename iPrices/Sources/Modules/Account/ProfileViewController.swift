//
//  ProfileViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class ProfileViewController: SimpleTableViewController {
    
    @IBOutlet var imgViewAvatar: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("profile_vc_title")
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
extension ProfileViewController {
    
    override func rebuildTable() {
        sections = [
            Section(
                title: nil,
                rows: [
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_account_username"), color: nil),
                        subTitle: Text(text: UserManager.shared.userName() ?? NSLocalizedString("user_info_username_empty"), color: nil),
                        callback: "changeUsername",
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_account_email"), color: nil),
                        subTitle: Text(text: NSLocalizedString("profile_vc_cell_account_email_change"), color: nil),
                        callback: "changeEmail",
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_basics_region"), color: nil),
                        subTitle: Text(text: UserManager.shared.region(), color: nil),
                        callback: "changeRegion",
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_basics_gender"), color: nil),
                        subTitle: Text(text: UserManager.shared.gender(), color: nil),
                        callback: "changeGender",
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(type: .CenterTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_logout"), color: UIColor.redColor()),
                        subTitle: Text(text: nil, color: nil),
                        callback: "logout",
                        accessoryType:.None,
                        separatorInset:nil)
                ]
            )
        ]
    }
}

// MARK: Cell actions
extension ProfileViewController {
    
    func logout() {
        UserManager.shared.logOut()
        self.dismissSelf()
    }

    func changeUsername() {
        
    }
    
    func changeEmail() {
        
    }
    
    func changeRegion() {
        
    }
    
    func changeGender() {
        
    }
}

// MARK: Routines
extension ProfileViewController {
    
}