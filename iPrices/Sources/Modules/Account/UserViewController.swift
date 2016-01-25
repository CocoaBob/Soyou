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
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("user_vc_tab_title"), image: UIImage(named: "img_tab_user"), selectedImage: UIImage(named: "img_tab_user_selected"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar before calculating inset
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, false)
        
        // Parallax Header
        self.setupParallaxHeader()
        
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
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        // Update login status
        updateUserInfo()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

// MARK: Build hierarchy
extension UserViewController {
    
    override func rebuildTable() {
        sections = [
            Section(
                title: NSLocalizedString("user_vc_cell_favs"),
                rows: [
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("user_vc_cell_favs_news"), color: nil),
                        subTitle: Text(text: nil, color: nil),
                        callback: "showNewsFavorites",
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)),
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("user_vc_cell_favs_products"), color: nil),
                        subTitle: Text(text: nil, color: nil),
                        callback: "showProductsFavorites",
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
                ]
            )
        ]
    }
}

// MARK: Parallax Header
extension UserViewController {
    
    private func setupParallaxHeader() {
        // Parallax View
        let scrollView = self.tableView
        scrollView.parallaxHeader.height = self.viewUserInfo.frame.size.height
        scrollView.parallaxHeader.view = self.viewUserInfo
        scrollView.parallaxHeader.mode = .Fill
    }
}

// MARK: Cell actions
extension UserViewController {
    
    func showNewsFavorites() {
        let favoritesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FavoritesViewController") as! FavoritesViewController
        favoritesViewController.type = .News
        self.navigationController?.pushViewController(favoritesViewController, animated: true)
    }
    
    func showProductsFavorites() {
        let favoritesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FavoritesViewController") as! FavoritesViewController
        favoritesViewController.type = .Products
        self.navigationController?.pushViewController(favoritesViewController, animated: true)
    }
}


// Routines
extension UserViewController {
    
    func updateUserInfo() {
        self.imgViewAvatar.image = UserManager.shared.avatarImage()
        self.lblUsername.text = UserManager.shared.userName()
    }
    
    func avatarAction() {
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(UserManager.shared.isLoggedIn ?  "ProfileViewController" : "LoginViewController") {
            let navigationController = UINavigationController(rootViewController: viewController)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showSettingsViewController(sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") {
            self.presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
    
    @IBAction func likeApp(sender: UIBarButtonItem) {
        
    }
}