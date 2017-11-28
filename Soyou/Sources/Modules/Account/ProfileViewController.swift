//
//  ProfileViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class ProfileViewController: SimpleTableViewController {
    
    @IBOutlet var imgViewAvatar: UIImageView!
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("profile_vc_title")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIViewController.dismissSelf))
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                rows: [
                    Row(type: .LeftTitleRightDetail,
                        cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                        title: Text(text: NSLocalizedString("profile_vc_cell_account_username")),
                        subTitle: Text(text: UserManager.shared.username ?? NSLocalizedString("user_info_username_unknown")),
                        didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            self.changeUsername()
                        }),
                    Row(type: .LeftTitleRightDetail,
                        cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                        title: Text(text: NSLocalizedString("profile_vc_cell_account_email")),
                        subTitle: Text(text: NSLocalizedString("profile_vc_cell_account_email_change")),
                        didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            self.changeEmail()
                        })
                ]
            ),
            Section(
                rows: [
                    Row(type: .LeftTitleRightDetail,
                        cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                        title: Text(text: NSLocalizedString("profile_vc_cell_basics_region")),
                        subTitle: Text(text: CurrencyManager.shared.countryName(UserManager.shared.region ?? "") ?? NSLocalizedString("user_info_region_unknown")),
                        didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            self.changeRegion()
                        }),
                    Row(type: .LeftTitleRightDetail,
                        cell: Cell(height: 44, accessoryType: .disclosureIndicator),
                        title: Text(text: NSLocalizedString("profile_vc_cell_basics_gender")),
                        subTitle: Text(text: UserManager.shared.gender),
                        didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            self.changeGender()
                        })
                ]
            ),
            Section(
                rows: [
                    Row(type: .CenterTitle,
                        cell: Cell(height: 44, accessoryType: .none),
                        title: Text(text: NSLocalizedString("profile_vc_cell_logout"), color: UIColor.red),
                        didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                            self.logout()
                        })
                ]
            )
        ]
    }
}

// MARK: Logout
extension ProfileViewController {
    
    func logout() {
        let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alertView.addButton(NSLocalizedString("alert_button_cancel")) {}
        alertView.addButton(NSLocalizedString("profile_vc_cell_logout_warning_sure")) { () -> Void in
            MBProgressHUD.show()
            DataManager.shared.logout({ (responseObject, error) in
                MBProgressHUD.hide()
                if error == nil {
                    UserManager.shared.logOut()
                    self.dismissSelf()
                }
            })
        }
        alertView.showWarning(NSLocalizedString("profile_vc_cell_logout_warning_title"), subTitle: NSLocalizedString("profile_vc_cell_logout_warning"))
    }

}

// MARK: Change Username / Email
extension ProfileViewController {
    
    func changeUsername() {
        let simpleViewController = SimpleTableViewController()
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: simpleViewController, action: #selector(SimpleTableViewController.doneAction))
        simpleViewController.title = NSLocalizedString("profile_vc_change_title_prefix") + NSLocalizedString("profile_vc_cell_account_username")
        // Data
        simpleViewController.sections = [
            Section(
                rows: [
                    Row(type: .TextField,
                        cell: Cell(height: 44, accessoryType: .none),
                        title: Text(text: UserManager.shared.username)
                    )
                ]
            )
        ]
        // Handler
        simpleViewController.completion = { () -> () in
            if let editedText = simpleViewController.editedText {
                MBProgressHUD.show()
                DataManager.shared.modifyUserInfo("username", editedText) { responseObject, error in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide()
                        if let error = error {
                            DataManager.showRequestFailedAlert(error)
                        } else {
                            UserManager.shared.username = editedText
                            simpleViewController.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
    func changeEmail() {
        let simpleViewController = SimpleTableViewController()
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: simpleViewController, action: #selector(SimpleTableViewController.doneAction))
        simpleViewController.title = NSLocalizedString("profile_vc_change_title_prefix") + NSLocalizedString("profile_vc_cell_account_email")
        // Data
        simpleViewController.sections = [
            Section(
                rows: [
                    Row(type: .TextField,
                        cell: Cell(height: 44, accessoryType: .none),
                        title: Text(placeholder: NSLocalizedString("profile_vc_cell_new_email_placeholder"), keyboardType: .emailAddress, returnKeyType: .next)
                    ),
                    Row(type: .TextField,
                        cell: Cell(height: 44, accessoryType: .none),
                        title: Text(placeholder: NSLocalizedString("profile_vc_cell_confirm_new_email_placeholder"), keyboardType: .emailAddress, returnKeyType: .send)
                    )
                ]
            )
        ]
        // Handler
        simpleViewController.completion = { () -> () in
            // Validation
            guard let tfNewEmail = (simpleViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCellTextField)?.tfTitle else { return }
            guard let tfConfirmNewEmail = (simpleViewController.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TableViewCellTextField)?.tfTitle else { return }
            if (tfNewEmail.text != nil &&
                tfNewEmail.text == tfConfirmNewEmail.text &&
                tfNewEmail.text!.isEmail()) {
                tfNewEmail.isEnabled = false
                tfConfirmNewEmail.isEnabled = false
                tfNewEmail.textColor = UIColor(white: 0.15, alpha: 1)
                tfConfirmNewEmail.textColor = UIColor(white: 0.15, alpha: 1)
            } else {
                if !tfNewEmail.text!.isEmail() {
                    tfNewEmail.textColor = UIColor.red
                    tfNewEmail.shake()
                }
                tfConfirmNewEmail.textColor = UIColor.red
                tfConfirmNewEmail.shake()
                return
            }
            
            // Update email
            if let editedText = simpleViewController.editedText {
                MBProgressHUD.show()
                DataManager.shared.modifyEmail(editedText) { responseObject, error in
                    // Succeeded or Failed
                    DispatchQueue.main.async {
                        MBProgressHUD.hide()
                        if let error = error {
                            tfNewEmail.isEnabled = true
                            tfConfirmNewEmail.isEnabled = true
                            DataManager.showRequestFailedAlert(error)
                        } else {
                            let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                            alertView.addButton(NSLocalizedString("alert_button_ok")) { () -> Void in
                                simpleViewController.navigationController?.popViewController(animated: true)
                            }
                            alertView.showSuccess(NSLocalizedString("alert_title_success"), subTitle: NSLocalizedString("profile_vc_change_email_alert_message"))
                        }
                    }
                }
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
    
}

// MARK: Change Region
extension ProfileViewController {
    
    func changeRegion() {
        let simpleViewController = SimpleTableViewController(tableStyle: .grouped)
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: simpleViewController, action: #selector(SimpleTableViewController.doneAction))
        simpleViewController.navigationItem.rightBarButtonItem?.isEnabled = false
        simpleViewController.title = NSLocalizedString("profile_vc_change_title_prefix") + NSLocalizedString("profile_vc_cell_basics_region")
        // Data
        if let regions = Region.mr_findAllSorted(by: "appOrder", ascending: true) {
            let regionCodes = regions.flatMap {($0 as? Region)?.code}
            var rows = [Row]()
            for regionCode in regionCodes {
                let row = Row(type: .IconTitle,
                              cell: Cell(height: 44, tintColor: UIColor(white: 0.15, alpha: 1), accessoryType: .none),
                              image: UIImage(flagImageWithCountryCode: regionCode),
                              title: Text(text: CurrencyManager.shared.countryName(regionCode) ?? ""),
                              userInfo: ["code": regionCode],
                              didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                                let row = simpleViewController.sections[indexPath.section].rows[indexPath.row]
                                simpleViewController.navigationItem.rightBarButtonItem?.isEnabled = (row.title?.text != UserManager.shared.region)
                                if simpleViewController.updateSelectionCheckmark(indexPath) {
                                    var rowsToReload = [indexPath]
                                    if let selectedIndexPath = simpleViewController.selectedIndexPath {
                                        rowsToReload.append(selectedIndexPath)
                                    }
                                    simpleViewController.tableView.beginUpdates()
                                    simpleViewController.tableView.reloadRows(at: rowsToReload, with: .fade)
                                    simpleViewController.tableView.endUpdates()
                                }
                })
                rows.append(row)
            }
            simpleViewController.sections = [
                Section(
                    rows: rows
                )
            ]
            if let region = UserManager.shared.region,
                let index = regionCodes.index(of: region) {
                simpleViewController.selectedIndexPath = IndexPath(row: index, section: 0)
                simpleViewController.updateSelectionCheckmark(simpleViewController.selectedIndexPath!)
            }
        }
        // Handler
        simpleViewController.completion = { () -> () in
            if let selectedIndexPath = simpleViewController.selectedIndexPath,
                let rows = simpleViewController.sections.first?.rows {
                    let row = rows[selectedIndexPath.row]
                    if let userInfo = row.userInfo,
                        let regionCode = userInfo["code"] as? String {
                            // Update region
                            MBProgressHUD.show()
                            DataManager.shared.modifyUserInfo("region", regionCode) { responseObject, error in
                                DispatchQueue.main.async {
                                    MBProgressHUD.hide()
                                    if let error = error {
                                        DataManager.showRequestFailedAlert(error)
                                    } else {
                                        UserManager.shared.region = regionCode
                                        simpleViewController.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                    }
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
}

// MARK: Change Gender
extension ProfileViewController {
    
    func changeGender() {
        let simpleViewController = SimpleTableViewController()
        // UI
        simpleViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: simpleViewController, action: #selector(SimpleTableViewController.doneAction))
        simpleViewController.navigationItem.rightBarButtonItem?.isEnabled = false
        simpleViewController.title = NSLocalizedString("profile_vc_change_title_prefix") + NSLocalizedString("profile_vc_cell_basics_gender")
        // Data
        var rows = [Row]()
        for titleCode in ["user_info_gender_secret","user_info_gender_male","user_info_gender_female"] {
            let row = Row(type: .LeftTitle,
                cell: Cell(height: 44, tintColor: UIColor(white: 0.15, alpha: 1), accessoryType: .none),
                title: Text(text: NSLocalizedString(titleCode)),
                didSelect: {(tableView: UITableView, indexPath: IndexPath) -> Void in
                    simpleViewController.navigationItem.rightBarButtonItem?.isEnabled = (indexPath.row != UserManager.shared.genderIndex)
                    if simpleViewController.updateSelectionCheckmark(indexPath) {
                        simpleViewController.tableView.beginUpdates()
                        simpleViewController.tableView.reloadRows(at: [simpleViewController.selectedIndexPath!, indexPath], with: .fade)
                        simpleViewController.tableView.endUpdates()
                    }
                })
            rows.append(row)
        }
        simpleViewController.sections = [
            Section(
                rows: rows
            )
        ]
        simpleViewController.selectedIndexPath = IndexPath(row: UserManager.shared.genderIndex, section: 0)
        simpleViewController.updateSelectionCheckmark(simpleViewController.selectedIndexPath!)
        // Handler
        simpleViewController.completion = { () -> () in
            // Update gender
            if let selectedIndexPath = simpleViewController.selectedIndexPath {
                let newGender = "\(selectedIndexPath.row+1)"
                MBProgressHUD.show()
                DataManager.shared.modifyUserInfo("gender", newGender) { responseObject, error in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide()
                        if let error = error {
                            DataManager.showRequestFailedAlert(error)
                        } else {
                            UserManager.shared.gender = newGender
                            simpleViewController.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        // Push
        self.navigationController?.pushViewController(simpleViewController, animated: true)
    }
}

// MARK: Routines
extension ProfileViewController {
    
}
