//
//  ProfileViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class ProfileViewController: SimpleTableViewController {
    
    @IBOutlet var imgViewAvatar: UIImageView!
    
    // Class methods
    class func instantiate() -> ProfileViewController {
        return UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("profile_vc_title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissSelf")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload table in case UserInfo is updated
        rebuildTable()
        self.tableView.reloadData()
    }
}

// MARK: Build hierarchy
extension ProfileViewController {
    
    override func rebuildTable() {
        self.sections = [
            Section(
                title: nil,
                rows: [
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_account_username"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: UserManager.shared.username ?? NSLocalizedString("user_info_username_empty"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeUsername()
                    }),
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_account_email"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: NSLocalizedString("profile_vc_cell_account_email_change"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeEmail()
                    })
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_basics_region"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: UserManager.shared.region, placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeRegion()
                    }),
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_basics_gender"), placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: UserManager.shared.gender, placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeGender()
                    })
                ]
            ),
            Section(
                title: nil,
                rows: [
                    Row(type: .CenterTitle,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_logout"), placeholder:nil, color: UIColor.redColor(), keyboardType: nil, returnKeyType: nil),
                        subTitle: Text(text: nil, placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        accessoryType:.None,
                        separatorInset:nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.logout()
                    })
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
        let simpleViewController = SimpleTableViewController()
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: simpleViewController, action: "doneAction")
        simpleViewController.title = NSLocalizedString("profile_vc_modify_title_prefix") + NSLocalizedString("profile_vc_cell_account_username")
        // Data
        simpleViewController.sections = [
            Section(
                title: nil,
                rows: [
                    Row(type: .TextField,
                        image: nil,
                        title: Text(text: UserManager.shared.username, placeholder:nil, color: nil, keyboardType: nil, returnKeyType: nil),
                        subTitle: nil,
                        accessoryType: .None,
                        separatorInset: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in

                    })
                ]
            )
        ]
        // Handler
        simpleViewController.completion = { () -> () in
            if let editedText = simpleViewController.editedText {
                MBProgressHUD.showLoader(nil)
                DataManager.shared.modifyUserInfo("username", editedText, completion: { (error: NSError?) -> () in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        MBProgressHUD.hideLoader(nil)
                        if let error = error {
                            DataManager.showRequestFailedAlert(error)
                        } else {
                            UserManager.shared.username = editedText
                            simpleViewController.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                })
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func changeEmail() {
        let simpleViewController = SimpleTableViewController()
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: simpleViewController, action: "doneAction")
        simpleViewController.title = NSLocalizedString("profile_vc_modify_title_prefix") + NSLocalizedString("profile_vc_cell_account_email")
        // Data
        simpleViewController.sections = [
            Section(
                title: nil,
                rows: [
                    Row(type: .TextField,
                        image: nil,
                        title: Text(text: nil, placeholder: NSLocalizedString("profile_vc_cell_new_email_placeholder"), color: nil, keyboardType: .EmailAddress, returnKeyType: .Next),
                        subTitle: nil,
                        accessoryType: .None,
                        separatorInset: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            
                    }),
                    Row(type: .TextField,
                        image: nil,
                        title: Text(text: nil, placeholder: NSLocalizedString("profile_vc_cell_confirm_new_email_placeholder"), color: nil, keyboardType: .EmailAddress, returnKeyType: .Send),
                        subTitle: nil,
                        accessoryType: .None,
                        separatorInset: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            
                    })
                ]
            )
        ]
        // Handler
        simpleViewController.completion = { () -> () in
            let tfNewEmail = (simpleViewController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TableViewCellTextField).tfTitle
            let tfConfirmNewEmail = (simpleViewController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TableViewCellTextField).tfTitle
            if (tfNewEmail.text != nil &&
                tfNewEmail.text == tfConfirmNewEmail.text &&
                tfNewEmail.text!.isEmail())
            {
                tfNewEmail.enabled = false
                tfConfirmNewEmail.enabled = false
                tfNewEmail.textColor = UIColor(white: 0.15, alpha: 1)
                tfConfirmNewEmail.textColor = UIColor(white: 0.15, alpha: 1)
            } else {
                if !tfNewEmail.text!.isEmail() {
                    tfNewEmail.textColor = UIColor.redColor()
                    tfNewEmail.shake()
                }
                tfConfirmNewEmail.textColor = UIColor.redColor()
                tfConfirmNewEmail.shake()
                return
            }
            if let editedText = simpleViewController.editedText {
                MBProgressHUD.showLoader(nil)
                DataManager.shared.modifyEmail(editedText, completion: { (error: NSError?) -> () in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        MBProgressHUD.hideLoader(nil)
                        if let error = error {
                            tfNewEmail.enabled = true
                            tfConfirmNewEmail.enabled = true
                            DataManager.showRequestFailedAlert(error)
                        } else {
                            let alertView = SCLAlertView()
                            alertView.addButton(NSLocalizedString("alert_button_ok")) { () -> Void in
                                simpleViewController.navigationController?.popViewControllerAnimated(true)
                            }
                            alertView.showCloseButton = false
                            alertView.showSuccess(NSLocalizedString("alert_title_success"), subTitle: NSLocalizedString("profile_vc_change_email_alert_message"))
                        }
                    })
                })
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func changeRegion() {
        
    }
    
    func changeGender() {
        
    }
}

// MARK: Routines
extension ProfileViewController {
    
}