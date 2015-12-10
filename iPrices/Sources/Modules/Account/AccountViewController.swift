//
//  AccountViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

private enum SectionType: Int {
    case Account
    case Favorites
    case Settings
}

private enum RowType: Int {
    case Account
    case Favorites
    case Settings
}

private enum CellType: String {
    case CenterTitle
    case IconTitle
}

private struct Row {
    var type: RowType
    var cell: CellType
}

private struct Section {
    var type: SectionType
    var rows: [Row]
}

private var sections = [Section]()

class AccountViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("account_view_controller_title", comment: "")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "img_tab_user"), selectedImage: UIImage(named: "img_tab_user_selected"))
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table data
        self.rebuildTable()
        
        // Setup table
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(row.cell.rawValue, forIndexPath: indexPath)
        switch row.type {
        case .Account:
            let rowCell = cell as! IconTitleTableViewCell
            rowCell.imgView?.image = UIImage(named: "img_user")
            rowCell.lblTitle?.text = "Account name"
        case .Favorites:
            let rowCell = cell as! IconTitleTableViewCell
            rowCell.imgView?.image = UIImage(named: "img_heart")
            rowCell.lblTitle?.text = "Favorites"
        case .Settings:
            let rowCell = cell as! IconTitleTableViewCell
            rowCell.imgView?.image = UIImage(named: "img_gear")
            rowCell.lblTitle?.text = "Settings"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("\(__FUNCTION__)")
    }
}

// Routines
extension AccountViewController {
    
    func rebuildTable() {
        sections = [
            Section(type: .Account, rows: [Row(type: .Account, cell: .IconTitle)]),
            Section(type: .Favorites, rows: [Row(type: .Favorites, cell: .IconTitle)]),
            Section(type: .Settings, rows: [Row(type: .Settings, cell: .IconTitle)])
        ]
    }
}