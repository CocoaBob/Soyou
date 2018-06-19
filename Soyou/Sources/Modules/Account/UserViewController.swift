//
//  UserViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class UserViewController: SimpleTableViewController {
    
    fileprivate let indexPathUserProfile = IndexPath(row: 0, section: 0)
    fileprivate var userProfileTableViewCell: UserProfileTableViewCell?
    
    // KVO Context
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
        
        // KVO
        self.startObservingUserManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Title
        self.title = NSLocalizedString("user_vc_title")
        
        if let tableView = self.tableView {
            // Fix scroll view insets
            self.updateScrollViewInset(tableView, 0, true, true, false, true)
        }
        
        // Background Color
        self.tableView?.backgroundColor = Cons.UI.colorBG
        
        // Navigation Items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "img_heart"), style: .plain, target: self, action: #selector(UserViewController.likeApp(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "img_gear"), style: .plain, target: self, action: #selector(UserViewController.showSettingsViewController(_:)))
    }
    
    deinit {
        self.stopObservingUserManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Don't show again after dismissing login view
        if self.presentedViewController == nil {
            // If not logged in, show login view
            UserManager.shared.loginOrDo(nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        if row.type == .Custom {
            if indexPath == self.indexPathUserProfile {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileTableViewCell", for: indexPath)
                if let rowCell = cell as? UserProfileTableViewCell {
                    rowCell.updateUserInfo(false)
                    self.userProfileTableViewCell = rowCell
                }
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return super.tableView(tableView, heightForHeaderInSection: section)
        }
    }
}

// MARK: - KVO
extension UserViewController {
    
    func startObservingUserManager() {
        UserManager.shared.addObserver(self, forKeyPath: "isLoggedIn", options: .new, context: &KVOContextUserViewController)
        UserManager.shared.addObserver(self, forKeyPath: "avatar", options: .new, context: &KVOContextUserViewController)
        UserManager.shared.addObserver(self, forKeyPath: "username", options: .new, context: &KVOContextUserViewController)
    }
    
    func stopObservingUserManager() {
        UserManager.shared.removeObserver(self, forKeyPath: "isLoggedIn", context: &KVOContextUserViewController)
        UserManager.shared.removeObserver(self, forKeyPath: "avatar", context: &KVOContextUserViewController)
        UserManager.shared.removeObserver(self, forKeyPath: "username", context: &KVOContextUserViewController)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &KVOContextUserViewController {
            if keyPath == "isLoggedIn" {
                self.rebuildTable()
                self.tableView?.reloadData()
            } else if keyPath == "avatar" {
                self.userProfileTableViewCell?.updateUserInfo(true)
            } else if keyPath == "username" {
                self.userProfileTableViewCell?.updateUserInfo(false)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - Build hierarchy
extension UserViewController {
    
    override func rebuildTable() {
        self.sections.removeAll()
        self.sections.append(Section(
            headerTitle: nil,
            rows: [
                Row(type: .Custom,
                    cell: Cell(height: 100, accessoryType: .disclosureIndicator),
                    didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                        self.showUserProfile()
                })
            ]
        ))
        if UserManager.shared.isLoggedIn {
            self.sections.append(contentsOf: [
                Section(headerTitle: nil,
                        rows: [
                            Row(type: .IconTitle,
                                cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                                image: UIImage(named: "img_qr_code"),
                                title: Text(text: NSLocalizedString("user_vc_cell_my_qr_code")),
                                didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                                    self.showQRCode()
                            }),
                            Row(type: .IconTitle,
                                cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                                image: UIImage(named: "img_followings"),
                                title: Text(text: NSLocalizedString("user_vc_cell_my_followings")),
                                didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                                    self.showFollowings()
                            }),
                            Row(type: .IconTitle,
                                cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                                image: UIImage(named: "img_followers"),
                                title: Text(text: NSLocalizedString("user_vc_cell_my_followers")),
                                didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                                    self.showFollowers()
                            }),
                            Row(type: .IconTitle,
                                cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                                image: UIImage(named: "img_tags"),
                                title: Text(text: NSLocalizedString("user_vc_cell_my_tags")),
                                didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                                    self.showTags()
                            })
                    ]),
                Section(headerTitle: NSLocalizedString("user_vc_cell_tools"),
                        rows: [
                            Row(type: .IconTitle,
                                cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                                image: UIImage(named: "img_websites"),
                                title: Text(text: NSLocalizedString("user_vc_cell_tools_website_crawler")),
                                didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                                    self.showCrawlsViewController()
                            })
                    ]),
                Section(headerTitle: NSLocalizedString("user_vc_cell_favs"),
                        rows: [
                            Row(type: .IconTitle,
                                cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                                image: UIImage(named: "img_news"),
                                title: Text(text: NSLocalizedString("user_vc_cell_favs_news")),
                                didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                                    self.showFavoritesViewController(.news)
                            }),
                            Row(type: .IconTitle,
                                cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                                image: UIImage(named: "img_product"),
                                title: Text(text: NSLocalizedString("user_vc_cell_favs_products")),
                                didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                                    self.showFavoritesViewController(.products)
                            })
                    ])
                ])
        }
    }
}

// Routines
extension UserViewController {
    
    func showUserProfile() {
        UserManager.shared.loginOrDo() { () -> () in
            self.navigationController?.pushViewController(ProfileViewController(), animated: true)
        }
    }
    
    func showQRCode() {
        Utils.showMyQRCode(self)
    }
    
    func showFollowings() {
        let vc = MembersViewController.instantiate()
        vc.userID = UserManager.shared.userID
        vc.isShowingFollowers = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showFollowers() {
        let vc = MembersViewController.instantiate()
        vc.userID = UserManager.shared.userID
        vc.isShowingFollowers = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTags() {
        let vc = TagsViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCrawlsViewController() {
        self.navigationController?.pushViewController(CrawlsViewController.instantiate(), animated: true)
    }
    
    func showFavoritesViewController(_ type: FavoriteType) {
        UserManager.shared.loginOrDo() { () -> () in
            let favoritesViewController = FavoritesViewController.instantiate()
            favoritesViewController.type = type
            self.navigationController?.pushViewController(favoritesViewController, animated: true)
        }
    }
    
    @objc func showSettingsViewController(_ sender: UIBarButtonItem?) {
        let vc = SettingsViewController()
        // Setup Navigation Controller
        let navC = UINavigationController(rootViewController: vc)
        navC.modalPresentationStyle = .custom
        navC.modalPresentationCapturesStatusBarAppearance = true
        // Setup Transition Animator
        if #available(iOS 11.0, *) {
            vc.loadViewIfNeeded()
            vc.setupTransitionAnimator(modalVC: vc)
            navC.transitioningDelegate = vc.transitionAnimator
        }
        // Present
        self.present(navC, animated: true, completion: nil)
    }
    
    @objc func likeApp(_ sender: UIBarButtonItem?) {
        UIAlertController.presentAlert(from: self,
                                       title: NSLocalizedString("user_vc_feedback_alert_title"),
                                       message: NSLocalizedString("user_vc_feedback_alert_message"),
                                       UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_like"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
                                        Utils.openAppStorePage()
                                       }),
                                       UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_feedback"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
                                        MBProgressHUD.show(self.view)
                                        Utils.shared.sendFeedbackEmail(self, attachments: ["SystemDiagnostic.zip": Utils.compressData("SystemDiagnostic.txt", Utils.systemDiagnosticData())])
                                        MBProgressHUD.hide(self.view)
                                       }),
                                       UIAlertAction(title: NSLocalizedString("user_vc_feedback_alert_share"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
                                        Utils.shareApp()
                                       }),
                                       UIAlertAction(title: NSLocalizedString("alert_button_close"), style: UIAlertActionStyle.cancel, handler: nil))
    }
}

class UserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblSoyouID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgAvatar.image = UIImage(named: "img_avatar_placeholder")
        self.lblName.text = nil
        self.lblSoyouID.text = nil
    }
    
    func updateUserInfo(_ reloadAvatar: Bool) {
        if UserManager.shared.isLoggedIn, let url = URL(string: UserManager.shared.avatar ?? "") {
            var options: SDWebImageOptions = [.continueInBackground, .allowInvalidSSLCertificates]
            if reloadAvatar {
                options = [.refreshCached, .continueInBackground, .allowInvalidSSLCertificates]
            }
            self.imgAvatar.sd_setImage(with: url,
                                       placeholderImage: UIImage(named: "img_avatar_placeholder"),
                                       options: options,
                                       completed: nil)
        } else {
            self.imgAvatar.image = UIImage(named: "img_avatar_placeholder")
        }
        self.lblName.text = UserManager.shared.username ?? NSLocalizedString("user_vc_username_unknown")
        if let matricule = UserManager.shared.matricule {
            self.lblSoyouID.text = FmtString(NSLocalizedString("user_vc_soyou_id"), "\(matricule)")
        } else {
            self.lblSoyouID.text = nil
        }
    }
}
