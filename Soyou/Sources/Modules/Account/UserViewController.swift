//
//  UserViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class UserViewController: SimpleTableViewController {
    
    @IBOutlet var imgViewAvatar: UIImageView!
    @IBOutlet var parallaxHeaderView: UIView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblMatricule: UILabel!
    
    fileprivate var KVOContextUserViewController = 0
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = false
                
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("user_vc_tab_title"),
                                       image: UIImage(named: "img_tab_user"),
                                       selectedImage: UIImage(named: "img_tab_user_selected"))
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
        self.tableView.backgroundColor = Cons.UI.colorBG
        
        // Setup avatar action
        self.imgViewAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserViewController.avatarAction)))
        self.lblUsername.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserViewController.avatarAction)))
        
        // Username shadow
        self.lblUsername.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.lblUsername.layer.shadowOpacity = 1
        self.lblUsername.layer.shadowRadius = 2
        self.lblUsername.layer.shadowOffset = CGSize.zero
        
        // Observe UserManager.shared.token
        UserManager.shared.addObserver(self, forKeyPath: "token", options: .new, context: &KVOContextUserViewController)
        UserManager.shared.addObserver(self, forKeyPath: "avatar", options: .new, context: &KVOContextUserViewController)
    }
    
    deinit {
        UserManager.shared.removeObserver(self, forKeyPath: "token")
        UserManager.shared.removeObserver(self, forKeyPath: "avatar")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Update User Info
        self.updateUserInfo(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &KVOContextUserViewController {
            // Update login status
            self.updateUserInfo(true)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
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
                        cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                        title: Text(text: NSLocalizedString("user_vc_cell_favs_news")),
                        didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            self.showFavoritesViewController(.news)
                    }),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                        title: Text(text: NSLocalizedString("user_vc_cell_favs_discounts")),
                        didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            self.showFavoritesViewController(.discounts)
                    }),
                    Row(type: .LeftTitle,
                        cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                        title: Text(text: NSLocalizedString("user_vc_cell_favs_products")),
                        didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            self.showFavoritesViewController(.products)
                    })
                ]
            )
        ]
    }
}

// MARK: Parallax Header
extension UserViewController {
    
    fileprivate func setupParallaxHeader() {
        // Parallax View
        if let scrollView = self.tableView {
            scrollView.parallaxHeader.height = self.parallaxHeaderView.frame.height
            scrollView.parallaxHeader.view = self.parallaxHeaderView
            scrollView.parallaxHeader.mode = .fill
        }
    }
}

// MARK: Cell actions
extension UserViewController {
    
    func showFavoritesViewController(_ type: FavoriteType) {
        UserManager.shared.loginOrDo() { () -> () in
            let favoritesViewController = FavoritesViewController.instantiate()
            favoritesViewController.type = type
            self.navigationController?.pushViewController(favoritesViewController, animated: true)
        }
    }
}

// Routines
extension UserViewController {
    
    func addAvatarBorder() {
        self.imgViewAvatar.layer.borderWidth = 1
        self.imgViewAvatar.layer.borderColor = UIColor.white.cgColor
    }
    
    func removeAvatarBorder() {
        self.imgViewAvatar.layer.borderWidth = 0
    }
    
    func updateUserInfo(_ reloadAvatar: Bool) {
        self.removeAvatarBorder()
        if let url = URL(string: UserManager.shared.avatar ?? "") {
            var options: SDWebImageOptions = [.continueInBackground, .allowInvalidSSLCertificates, .delayPlaceholder]
            if reloadAvatar {
                options = [.refreshCached, .continueInBackground, .allowInvalidSSLCertificates, .delayPlaceholder]
            }
            self.imgViewAvatar.sd_setImage(with: url,
                                           placeholderImage: UserManager.shared.defaultAvatarImage(),
                                           options: options,
                                           completed: { (image, error, type, url) -> Void in
                                            if error == nil {
                                                self.addAvatarBorder()
                                            }
            })
        } else {
            self.imgViewAvatar.image = UserManager.shared.defaultAvatarImage()
        }
        self.lblUsername.text = UserManager.shared.username ?? NSLocalizedString("user_vc_username_unknown")
        if let matricule = UserManager.shared.matricule {
            self.lblMatricule.text = "\(matricule)"
        } else {
            self.lblMatricule.text = nil
        }
    }
    
    @objc func avatarAction() {
        UserManager.shared.loginOrDo() { () -> () in
            self.present(UINavigationController(rootViewController: ProfileViewController()), animated: true, completion: nil)
        }
    }
    
    @IBAction func showSettingsViewController(_ sender: UIBarButtonItem?) {
        self.present(UINavigationController(rootViewController: SettingsViewController()), animated: true, completion: nil)
    }
    
    @IBAction func likeApp(_ sender: UIBarButtonItem?) {
        let alertController = UIAlertController(title: NSLocalizedString("user_vc_feedback_alert_title"), message: NSLocalizedString("user_vc_feedback_alert_message"), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_like"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            Utils.openAppStorePage()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_feedback"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            MBProgressHUD.show(self.view)
            Utils.shared.sendFeedbackEmail(self, attachments: ["SystemDiagnostic.zip": Utils.compressData("SystemDiagnostic.txt", Utils.systemDiagnosticData())])
            MBProgressHUD.hide(self.view)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_share"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            Utils.shareApp()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_close"), style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
