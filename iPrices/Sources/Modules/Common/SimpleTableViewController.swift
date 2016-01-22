//
//  SimpleTableViewController.swift
//  iPrices
//
//  Created by CocoaBob on 22/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

enum SectionType: Int {
    case Favorites
    case Settings
}

enum CellType: String {
    case CenterTitle
    case IconTitle
}

struct Row {
    var image: UIImage?
    var title: String?
    var titleColor: UIColor?
    var cell: CellType
    var callback: Selector?
}

struct Section {
    var title: String?
    var rows: [Row]
}

class SimpleTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var sections = [Section]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table
        self.tableView.sectionHeaderHeight = 32;
        self.tableView.sectionFooterHeight = 0;
        
        // Setup table data
        self.rebuildTable()
        
        // Register custom cells
        self.tableView.registerNib(UINib(nibName: "TableViewCellCenterTitle", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CenterTitle")
        self.tableView.registerNib(UINib(nibName: "TableViewCellIconTitle", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "IconTitle")
        self.tableView.registerNib(UINib(nibName: "TableViewCellSectionHeader", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TableViewCellSectionHeader")
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension SimpleTableViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            let rowCell = cell as! TableViewCellCenterTitle
            rowCell.lblTitle.text = row.title
            if let titleColor = row.titleColor {
                rowCell.lblTitle.textColor = titleColor
            }
        case .IconTitle:
            let rowCell = cell as! TableViewCellIconTitle
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellSectionHeader") as! TableViewCellSectionHeader
        let section = sections[section]
        cell.lblTitle.text = section.title
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = sections[indexPath.section].rows[indexPath.row]
        
        if let callback = row.callback {
            self.performSelector(callback)
        }
    }
}

// MARK: Build hierarchy
extension SimpleTableViewController {

    func rebuildTable() {
    }
}