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
        
        // Setup avatar action
        self.imgViewAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "avatarAction"))
        self.lblUsername.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "avatarAction"))
        
        // Username shadow
        self.lblUsername.layer.shadowColor = UIColor(white: 0, alpha: 0.5).CGColor
        self.lblUsername.layer.shadowOpacity = 1
        self.lblUsername.layer.shadowRadius = 2
        self.lblUsername.layer.shadowOffset = CGSizeZero
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Check if the user is logged in
        if UserManager.shared.isLoggedIn {
            DataManager.shared.checkToken()
        }
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
        self.sections = [
            Section(
                title: NSLocalizedString("user_vc_cell_favs"),
                rows: [
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("user_vc_cell_favs_news"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        tintColor: nil,
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showNewsFavorites()
                    }),
                    Row(type: .LeftTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("user_vc_cell_favs_products"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        tintColor: nil,
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showProductsFavorites()
                    })
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
        UserManager.shared.loginOrDo() { () -> () in
            let favoritesViewController = FavoritesViewController.instantiate()
            favoritesViewController.type = .News
            self.navigationController?.pushViewController(favoritesViewController, animated: true)
        }
    }
    
    func showProductsFavorites() {
        UserManager.shared.loginOrDo() { () -> () in
            let favoritesViewController = FavoritesViewController.instantiate()
            favoritesViewController.type = .Products
            self.navigationController?.pushViewController(favoritesViewController, animated: true)
        }
    }
}


// Routines
extension UserViewController {
    
    func updateUserInfo() {
        self.imgViewAvatar.image = UserManager.shared.avatarImage()
        self.lblUsername.text = UserManager.shared.username
    }
    
    func avatarAction() {
        UserManager.shared.loginOrDo() { () -> () in
            self.presentViewController(UINavigationController(rootViewController: ProfileViewController.instantiate()), animated: true, completion: nil)
        }
    }
    
    @IBAction func showSettingsViewController(sender: UIBarButtonItem?) {
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") {
            self.presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
    
    @IBAction func likeApp(sender: UIBarButtonItem?) {
        let alertController = UIAlertController(title: NSLocalizedString("user_vc_feedback_alert_title"), message: NSLocalizedString("user_vc_feedback_alert_message"), preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_like"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            Utils.shared.openAppStorePage()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_feedback"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            Utils.shared.sendFeedbackEmail(self)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_close"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}