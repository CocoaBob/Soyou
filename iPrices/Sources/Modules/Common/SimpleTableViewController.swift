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
    var placeholder: String?
    var color: UIColor?
    var keyboardType: UIKeyboardType?
    var returnKeyType: UIReturnKeyType?
}

struct Row {
    var type: CellType
    var image: UIImage?
    var title: Text?
    var subTitle: Text?
    var accessoryType: UITableViewCellAccessoryType
    var separatorInset: UIEdgeInsets?
    var didSelect: ((UITableView, NSIndexPath)->())?
}

struct Section {
    var title: String?
    var rows: [Row]
}

class SimpleTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var sections = [Section]()
    var editedText: String?
    var selectedRow: NSIndexPath?
    var completion: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In case created programmatically
        if self.tableView == nil {
            self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
            self.tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.view.addSubview(self.tableView)
        }
        
        // Setup table
        self.tableView.sectionHeaderHeight = 32;
        self.tableView.sectionFooterHeight = 0;
        
        // Background Color
        self.tableView.backgroundColor = UIColor(rgba: Cons.UI.colorBG)
        
        // Setup table data
        if sections.count == 0 {
            self.rebuildTable()
        }
        
        // Register custom cells
        self.tableView.registerNib(UINib(nibName: "TableViewCellCenterTitle", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CenterTitle")
        self.tableView.registerNib(UINib(nibName: "TableViewCellIconTitle", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "IconTitle")
        self.tableView.registerNib(UINib(nibName: "TableViewCellLeftTitle", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LeftTitle")
        self.tableView.registerNib(UINib(nibName: "TableViewCellLeftTitleRightDetail", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LeftTitleRightDetail")
        self.tableView.registerNib(UINib(nibName: "TableViewCellSectionHeader", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TableViewCellSectionHeader")
        self.tableView.registerNib(UINib(nibName: "TableViewCellTextField", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TextField")
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
            rowCell.tfTitle.delegate = self
            rowCell.tfTitle.text = row.title?.text
            rowCell.tfTitle.placeholder = row.title?.placeholder
            if let keyboardType = row.title?.keyboardType {
                rowCell.tfTitle.keyboardType = keyboardType
            }
            if let returnKeyType = row.title?.returnKeyType {
                rowCell.tfTitle.returnKeyType = returnKeyType
            }
            if let color = row.title?.color {
                rowCell.tfTitle.textColor = color
            }
            rowCell.tfTitle.addTarget(self, action: "textFieldDidEdit:", forControlEvents: UIControlEvents.EditingChanged)
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
        
        self.selectedRow = indexPath
        
        let row = sections[indexPath.section].rows[indexPath.row]
        if let didSelectClosure = row.didSelect {
            didSelectClosure(tableView, indexPath)
        }
    }
}

// MARK: UITextFieldDelegate
extension SimpleTableViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let position = textField.convertPoint(CGPointZero, toView: self.tableView)
        guard let indexPath = self.tableView.indexPathForRowAtPoint(position) else { return true }
        
        var nextTextFieldCell: TableViewCellTextField?
        searchingLoop: for idxSection in indexPath.section..<self.sections.count {
            for idxRow in indexPath.row..<self.sections[idxSection].rows.count {
                let row = sections[idxSection].rows[idxRow]
                if row.type == .TextField {
                    if let tableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: idxRow, inSection: idxSection)) as? TableViewCellTextField {
                        if tableViewCell.tfTitle != textField {
                            nextTextFieldCell = tableViewCell
                            break searchingLoop
                        }
                    }
                }
            }
        }
        if let nextTextFieldCell = nextTextFieldCell {
            nextTextFieldCell.tfTitle.becomeFirstResponder()
        } else {
            self.doneAction()
        }
        
        return true
    }
}

// MARK: Actions
extension SimpleTableViewController {
    
    func textFieldDidEdit(textField: UITextField) {
        self.editedText = textField.text
        let position = textField.convertPoint(CGPointZero, toView: self.tableView)
        guard let indexPath = self.tableView.indexPathForRowAtPoint(position) else { return }
        let row = sections[indexPath.section].rows[indexPath.row]
        textField.textColor = row.title?.color
    }
    
    func doneAction() {
        if let completion = self.completion {
            completion()
        }
    }
}

// MARK: Build hierarchy
extension SimpleTableViewController {

    func rebuildTable() {
    }
}