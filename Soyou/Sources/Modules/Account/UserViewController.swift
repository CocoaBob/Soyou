//
//  UserViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class UserViewController: SimpleTableViewController {
    
    @IBOutlet var imgViewAvatar: UIImageView!
    @IBOutlet var viewUserInfo: UIView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblMatricule: UILabel!
    
    private var KVOContextUserViewController = 0
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = false
                
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("user_vc_tab_title"), image: UIImage(named: "img_tab_user"), selectedImage: UIImage(named: "img_tab_user_selected"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Hide navigation bar before calculating inset
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, false, false, false, true)
        
        // Parallax Header
        self.setupParallaxHeader()
        
        // Background Color
        self.tableView.backgroundColor = UIColor(rgba: Cons.UI.colorBG)
        
        // Setup avatar action
        self.imgViewAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserViewController.avatarAction)))
        self.lblUsername.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserViewController.avatarAction)))
        
        // Username shadow
        self.lblUsername.layer.shadowColor = UIColor(white: 0, alpha: 0.5).CGColor
        self.lblUsername.layer.shadowOpacity = 1
        self.lblUsername.layer.shadowRadius = 2
        self.lblUsername.layer.shadowOffset = CGSize.zero
        
        // Observe UserManager.shared.token
        UserManager.shared.addObserver(self, forKeyPath: "token", options: .New, context: &KVOContextUserViewController)
    }
    
    deinit {
        UserManager.shared.removeObserver(self, forKeyPath: "token")
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
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &KVOContextUserViewController {
            // Update login status
            updateUserInfo()
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}

// MARK: Build hierarchy
extension UserViewController {
    
    override func rebuildTable() {
        self.sections = [
            Section(
                headerTitle: NSLocalizedString("user_vc_cell_favs"),
                rows: [
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("user_vc_cell_favs_news")),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.showNewsFavorites()
                    }),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .DisclosureIndicator),
                        title: Text(text: NSLocalizedString("user_vc_cell_favs_products")),
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
        if let matricule = UserManager.shared.matricule {
            self.lblMatricule.text = matricule
        } else {
            self.lblMatricule.text = nil
        }
    }
    
    func avatarAction() {
        UserManager.shared.loginOrDo() { () -> () in
            self.presentViewController(UINavigationController(rootViewController: ProfileViewController()), animated: true, completion: nil)
        }
    }
    
    @IBAction func showSettingsViewController(sender: UIBarButtonItem?) {
        self.presentViewController(UINavigationController(rootViewController: SettingsViewController()), animated: true, completion: nil)
    }
    
    @IBAction func likeApp(sender: UIBarButtonItem?) {
        let alertController = UIAlertController(title: NSLocalizedString("user_vc_feedback_alert_title"), message: NSLocalizedString("user_vc_feedback_alert_message"), preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_like"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            Utils.openAppStorePage()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_feedback"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            Utils.shared.sendFeedbackEmail(self)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_share"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            Utils.shareApp()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_close"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
