//
//  SimpleTableViewController.swift
//  iPrices
//
//  Created by CocoaBob on 22/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

enum CellType: String {
    case CenterTitle
    case IconTitle
    case LeftTitle
    case LeftTitleRightDetail
    case TextField
}

struct Text {
    var text: String?
    var color: UIColor?
}

struct Row {
    var type: CellType
    var image: UIImage?
    var title: Text?
    var subTitle: Text?
    var callback: Selector?
    var accessoryType: UITableViewCellAccessoryType
    var separatorInset: UIEdgeInsets?
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
        self.tableView.registerNib(UINib(nibName: "TableViewCellLeftTitle", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LeftTitle")
        self.tableView.registerNib(UINib(nibName: "TableViewCellLeftTitleRightDetail", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LeftTitleRightDetail")
        self.tableView.registerNib(UINib(nibName: "TableViewCellSectionHeader", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TableViewCellSectionHeader")
        self.tableView.registerNib(UINib(nibName: "TableViewCellTextField", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TableViewCellTextField")
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(row.type.rawValue, forIndexPath: indexPath)
        
        switch row.type {
        case .CenterTitle:
            let rowCell = cell as! TableViewCellCenterTitle
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
        case .IconTitle:
            let rowCell = cell as! TableViewCellIconTitle
            rowCell.imgView.image = row.image
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
        case .LeftTitle:
            let rowCell = cell as! TableViewCellLeftTitle
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
        case .LeftTitleRightDetail:
            let rowCell = cell as! TableViewCellLeftTitleRightDetail
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
            rowCell.lblSubTitle.text = row.subTitle?.text
            if let color = row.subTitle?.color {
                rowCell.lblSubTitle.textColor = color
            }
        case .TextField:
            let rowCell = cell as! TableViewCellTextField
            rowCell.tfTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.tfTitle.textColor = color
            }
        }
        
        cell.accessoryType = row.accessoryType
        if let separatorInset = row.separatorInset {
            cell.separatorInset = separatorInset
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