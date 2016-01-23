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
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("profile_vc_cell_account_username"),
                        titleColor: nil,
                        cell: .IconTitle,
                        callback: nil),
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("profile_vc_cell_account_email"),
                        titleColor: nil,
                        cell: .IconTitle,
                        callback: nil)
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("profile_vc_cell_basics_gender"),
                        titleColor: nil,
                        cell: .IconTitle,
                        callback: nil),
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("profile_vc_cell_basics_region"),
                        titleColor: nil,
                        cell: .IconTitle,
                        callback: nil)
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(image: nil,
                        title: NSLocalizedString("profile_vc_cell_logout"),
                        titleColor: UIColor.redColor(),
                        cell: .CenterTitle,
                        callback: "logout")
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
}

// MARK: Routines
extension ProfileViewController {
    
    func updateAvatar() {
        self.imgViewAvatar.image = UIImage(named: UserManager.shared.isLoggedIn ? "img_default_avatar" : "img_default_avatar_2")
    }
}