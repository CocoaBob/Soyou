//
//  UserViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class UserViewController: SimpleTableViewController {
    
    @IBOutlet var imgViewAvatar: UIImageView!
    @IBOutlet var viewUserInfo: UIView!
    @IBOutlet var lblUsername: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("user_vc_title")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "img_tab_user"), selectedImage: UIImage(named: "img_tab_user"))
        self.tabBarItem.title = NSLocalizedString("user_vc_tab_title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background Color
        self.tableView.backgroundColor = UIColor(rgba: Cons.UI.colorBG)
        
        // Navigation Bar Button Items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_heart"), style: UIBarButtonItemStyle.Plain, target: self, action: "likeApp:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_gear"), style: UIBarButtonItemStyle.Plain, target: self, action: "showSettingsViewController:")
        
        // Setup avatar action
        let tapGR = UITapGestureRecognizer(target: self, action: "avatarAction")
        self.viewUserInfo.addGestureRecognizer(tapGR)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update login status
        updateUserInfo()
    }
}

// MARK: Build hierarchy
extension UserViewController {
    
    override func rebuildTable() {
        sections = [
            Section(
                title: NSLocalizedString("user_vc_cell_favs"),
                rows: [
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("user_vc_cell_favs_news"),
                        titleColor: nil,
                        cell: .IconTitle,
                        callback: nil),
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("user_vc_cell_favs_products"),
                        titleColor: nil,
                        cell: .IconTitle,
                        callback: nil)
                ]
            )
        ]
    }
}

// Routines
extension UserViewController {
    
    func updateUserInfo() {
        self.imgViewAvatar.image = UIImage(named: UserManager.shared.isLoggedIn ? "img_default_avatar" : "img_default_avatar_2")
        self.lblUsername.text = UserManager.shared.isLoggedIn ? UserManager.shared.userName : NSLocalizedString("user_vc_please_login")
    }
    
    func avatarAction() {
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(UserManager.shared.isLoggedIn ?  "ProfileViewController" : "LoginViewController") {
            let navigationController = UINavigationController(rootViewController: viewController)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    func showSettingsViewController(sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") {
            self.presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
    
    func likeApp(sender: UIBarButtonItem) {
        
    }
}