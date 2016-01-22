//
//  ProfileViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

private enum SectionType: Int {
    case Favorites
    case Settings
}

private enum CellType: String {
    case CenterTitle
    case IconTitle
}

private struct Row {
    var image: UIImage?
    var title: String?
    var titleColor: UIColor?
    var cell: CellType
    var callback: Selector?
}

private struct Section {
    var title: String?
    var rows: [Row]
}

private var sections = [Section]()

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imgViewAvatar: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("login_vc_login_title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissSelf")
        
        // Background Color
        self.tableView.backgroundColor = UIColor(rgba: Cons.UI.colorBG)
        
        // Setup table
        self.tableView.sectionHeaderHeight = 10.0;
        self.tableView.sectionFooterHeight = 10.0;
        
        // Setup table data
        self.rebuildTable()
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(row.cell.rawValue, forIndexPath: indexPath)
        
        switch row.cell {
        case .CenterTitle:
            let rowCell = cell as! CenterTitleTableViewCell
            rowCell.lblTitle.text = row.title
            if let titleColor = row.titleColor {
                rowCell.lblTitle.textColor = titleColor
            }
            break
        case .IconTitle:
            let rowCell = cell as! IconTitleTableViewCell
            rowCell.imgView.image = row.image
            rowCell.lblTitle.text = row.title
            if let titleColor = row.titleColor {
                rowCell.lblTitle.textColor = titleColor
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.title
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 32
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = sections[indexPath.section].rows[indexPath.row]
        
        if let callback = row.callback {
            self.performSelector(callback)
        }
    }
}

// Cell actions
extension ProfileViewController {
    
    func logout() {
        UserManager.shared.logOut()
        self.dismissSelf()
    }
}

// Routines
extension ProfileViewController {
    
    func updateAvatar() {
        self.imgViewAvatar.image = UIImage(named: UserManager.shared.isLoggedIn ? "img_default_avatar" : "img_default_avatar_2")
    }
    
    func rebuildTable() {
        sections = [
            Section(
                title: nil,
                rows: [
                    Row(image: UIImage(named: "img_heart_shadow_selected")!,
                        title: NSLocalizedString("profile_vc_cell_account_nickname"),
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
                        title: NSLocalizedString("profile_vc_cell_basics_sex"),
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