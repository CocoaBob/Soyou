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
                        title: Text(text: NSLocalizedString("profile_vc_cell_account_username"), color: nil),
                        subTitle: Text(text: UserManager.shared.userName() ?? NSLocalizedString("user_info_username_empty"), color: nil),
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeUsername()
                    }),
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_account_email"), color: nil),
                        subTitle: Text(text: NSLocalizedString("profile_vc_cell_account_email_change"), color: nil),
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
                        title: Text(text: NSLocalizedString("profile_vc_cell_basics_region"), color: nil),
                        subTitle: Text(text: UserManager.shared.region(), color: nil),
                        accessoryType: .DisclosureIndicator,
                        separatorInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in
                            self.changeRegion()
                    }),
                    Row(type: .LeftTitleRightDetail,
                        image: nil,
                        title: Text(text: NSLocalizedString("profile_vc_cell_basics_gender"), color: nil),
                        subTitle: Text(text: UserManager.shared.gender(), color: nil),
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
                        title: Text(text: NSLocalizedString("profile_vc_cell_logout"), color: UIColor.redColor()),
                        subTitle: Text(text: nil, color: nil),
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
        let editViewController = SimpleTableViewController()
        editViewController.sections = [
            Section(
                title: nil,
                rows: [
                    Row(type: .TextField,
                        image: nil,
                        title: Text(text: UserManager.shared.userName(), color: nil),
                        subTitle: nil,
                        accessoryType: .None,
                        separatorInset: nil,
                        didSelect: {(tableView: UITableView, indexPath: NSIndexPath) -> Void in

                    })
                ]
            )
        ]
        editViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: editViewController, action: "doneAction")
        editViewController.completion = { () -> () in
            if let editedText = editViewController.editedText {
                MBProgressHUD.showLoader(nil)
                DataManager.shared.modifyUserInfo("username", editedText, completion: { (error: NSError?) -> () in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        MBProgressHUD.hideLoader(nil)
                        if let error = error {
                            DataManager.showRequestFailedAlert(error)
                        } else {
                            UserManager.shared.setUserName(editedText)
                            editViewController.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                })
            } else {
                editViewController.navigationController?.popViewControllerAnimated(true)
            }
        }
        self.navigationController?.pushViewController(editViewController, animated: true)
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