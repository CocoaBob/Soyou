//
//  SimpleTableViewController.swift
//  Soyou
//
//  Created by CocoaBob on 22/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

enum CellType: String {
    case CenterTitle
    case IconTitle
    case IconTitleContent
    case LeftTitle
    case LeftTitleRightDetail
    case TextField
}

struct Text {
    var text: String?
    var placeholder: String?
    var font: UIFont?
    var color: UIColor?
    var keyboardType: UIKeyboardType?
    var returnKeyType: UIReturnKeyType?
}

struct Cell {
    var height: CGFloat?
    var tintColor: UIColor?
    var accessoryType: UITableViewCellAccessoryType
    var separatorInset: UIEdgeInsets?
}

struct Row {
    var type: CellType
    var cell: Cell
    var image: UIImage?
    var title: Text?
    var subTitle: Text?
    var userInfo: [String:AnyObject]?
    var setupCell: ((UITableView, UITableViewCell, NSIndexPath)->())?
    var didSelect: ((UITableView, NSIndexPath)->())?
}

struct Section {
    var title: String?
    var rows: [Row]
}

class SimpleTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var tableStyle: UITableViewStyle?
    
    var sections = [Section]()
    var editedText: String?
    var selectedIndexPath: NSIndexPath?
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
    
    convenience init(tableStyle: UITableViewStyle?) {
        self.init(nibName:nil, bundle:nil)
        self.tableStyle = tableStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If created programmatically
        if self.tableView == nil {
            self.tableView = UITableView(frame: self.view.bounds, style: self.tableStyle ?? .Grouped)
            self.tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            self.tableView.estimatedRowHeight = 44
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.tableFooterView = UIView(frame: CGRectZero)
            self.view.addSubview(self.tableView)
        }
        
        // Background Color
        self.tableView.backgroundColor = UIColor(rgba: Cons.UI.colorBG)
        
        // Setup table data
        if sections.count == 0 {
            self.rebuildTable()
        }
        
        // Register custom cells
        self.tableView.registerNib(UINib(nibName: "TableViewCellCenterTitle", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CenterTitle")
        self.tableView.registerNib(UINib(nibName: "TableViewCellIconTitle", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "IconTitle")
        self.tableView.registerNib(UINib(nibName: "TableViewCellIconTitleContent", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "IconTitleContent")
        self.tableView.registerNib(UINib(nibName: "TableViewCellLeftTitle", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LeftTitle")
        self.tableView.registerNib(UINib(nibName: "TableViewCellLeftTitleRightDetail", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LeftTitleRightDetail")
        self.tableView.registerNib(UINib(nibName: "TableViewCellSectionHeader", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TableViewCellSectionHeader")
        self.tableView.registerNib(UINib(nibName: "TableViewCellTextField", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TextField")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let nextTextField = self.findNextTextField(nil, nil) {
            nextTextField.becomeFirstResponder()
        }
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
            if let font = row.title?.font {
                rowCell.lblTitle.font = font
            }
        case .IconTitle:
            let rowCell = cell as! TableViewCellIconTitle
            rowCell.imgView.image = row.image
            if (rowCell.imgView.image?.size.width > rowCell.imgView.frame.size.width ||
                rowCell.imgView.image?.size.height > rowCell.imgView.frame.size.height)
            {
                rowCell.imgView.contentMode = .ScaleAspectFit
            } else {
                rowCell.imgView.contentMode = .Center
            }
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
            if let font = row.title?.font {
                rowCell.lblTitle.font = font
            }
        case .IconTitleContent:
            let rowCell = cell as! TableViewCellIconTitleContent
            rowCell.imgView.image = row.image
            if rowCell.imageRatioConstraint != nil {
                rowCell.imgView.removeConstraint(rowCell.imageRatioConstraint!)
            }
            let ratioConstraint = NSLayoutConstraint(item: rowCell.imgView, attribute: .Height, relatedBy: .Equal, toItem: rowCell.imgView, attribute: .Width, multiplier: (row.image?.size.height ?? 9999) / (row.image?.size.width ?? 1), constant: 0)
            rowCell.imageRatioConstraint = ratioConstraint
            rowCell.imgView.addConstraint(ratioConstraint)
            rowCell.lblTitle.text = row.title?.text
            if (rowCell.imgView.image?.size.width > rowCell.imgView.frame.size.width ||
                rowCell.imgView.image?.size.height > rowCell.imgView.frame.size.height)
            {
                rowCell.imgView.contentMode = .ScaleAspectFit
            } else {
                rowCell.imgView.contentMode = .Center
            }
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
            if let font = row.title?.font {
                rowCell.lblTitle.font = font
            }
            rowCell.tvContent.text = row.subTitle?.text
            if let color = row.subTitle?.color {
                rowCell.tvContent.textColor = color
            }
            if let font = row.subTitle?.font {
                rowCell.tvContent.font = font
            }
        case .LeftTitle:
            let rowCell = cell as! TableViewCellLeftTitle
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
            if let font = row.title?.font {
                rowCell.lblTitle.font = font
            }
        case .LeftTitleRightDetail:
            let rowCell = cell as! TableViewCellLeftTitleRightDetail
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
            if let font = row.title?.font {
                rowCell.lblTitle.font = font
            }
            rowCell.lblSubTitle.text = row.subTitle?.text
            if let color = row.subTitle?.color {
                rowCell.lblSubTitle.textColor = color
            }
            if let font = row.subTitle?.font {
                rowCell.lblSubTitle.font = font
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
            if let font = row.title?.font {
                rowCell.tfTitle.font = font
            }
            rowCell.tfTitle.addTarget(self, action: "textFieldDidEdit:", forControlEvents: UIControlEvents.EditingChanged)
        }
        
        cell.accessoryType = row.cell.accessoryType
        if let separatorInset = row.cell.separatorInset {
            cell.separatorInset = separatorInset
        }
        if let tintColor = row.cell.tintColor {
            cell.tintColor = tintColor
        }
        
        if let setupCell = row.setupCell {
            setupCell(tableView, cell, indexPath)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = sections[indexPath.section].rows[indexPath.row]
        if let didSelectClosure = row.didSelect {
            didSelectClosure(tableView, indexPath)
        }
        
        self.selectedIndexPath = indexPath
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = sections[indexPath.section].rows[indexPath.row]
        return row.cell.height ?? UITableViewAutomaticDimension
    }
}

// MARK: UITextFieldDelegate
extension SimpleTableViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let position = textField.convertPoint(CGPointZero, toView: self.tableView)
        guard let indexPath = self.tableView.indexPathForRowAtPoint(position) else { return true }
        
        if let nextTextField = self.findNextTextField(textField, indexPath) {
            nextTextField.becomeFirstResponder()
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

// MARK: Routines
extension SimpleTableViewController {

    func findNextTextField(textField: UITextField?, _ indexPath: NSIndexPath?) -> UITextField? {
        for idxSection in (indexPath != nil ? indexPath!.section : 0)..<self.sections.count {
            for idxRow in (indexPath != nil ? indexPath!.row : 0)..<self.sections[idxSection].rows.count {
                let row = sections[idxSection].rows[idxRow]
                if row.type == .TextField {
                    if let tableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: idxRow, inSection: idxSection)) as? TableViewCellTextField {
                        if tableViewCell.tfTitle != textField {
                            return tableViewCell.tfTitle
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func updateSelectionCheckmark(indexPath: NSIndexPath) -> Bool {
        var isChanged = false
        var newSections = [Section]()
        for indexSection in 0..<self.sections.count {
            var section = self.sections[indexSection]
            var newRows = [Row]()
            for indexRow in 0..<section.rows.count {
                var row = section.rows[indexRow]
                let newAccessoryType = (indexSection == indexPath.section && indexRow == indexPath.row) ? UITableViewCellAccessoryType.Checkmark : .None
                if row.cell.accessoryType != newAccessoryType {
                    row.cell.accessoryType = newAccessoryType
                    isChanged = true
                }
                newRows.append(row)
            }
            section.rows = newRows
            newSections.append(section)
        }
        self.sections = newSections
        return isChanged
    }
}