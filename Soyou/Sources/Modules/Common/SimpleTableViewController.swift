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
    
    init(
        text: String? = nil,
        placeholder: String? = nil,
        font: UIFont? = nil,
        color: UIColor? = nil,
        keyboardType: UIKeyboardType? = nil,
        returnKeyType: UIReturnKeyType? = nil) {
        self.text = text
        self.placeholder = placeholder
        self.font = font
        self.color = color
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
    }
}

struct Cell {
    var height: CGFloat?
    var tintColor: UIColor?
    var separatorInset: UIEdgeInsets?
    var accessoryType: UITableViewCellAccessoryType
    var selectionStyle: UITableViewCellSelectionStyle
    
    init(
        height: CGFloat? = nil,
        tintColor: UIColor? = nil,
        separatorInset: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0),
        accessoryType: UITableViewCellAccessoryType = .none,
        selectionStyle: UITableViewCellSelectionStyle = .default) {
        self.height = height
        self.tintColor = tintColor
        self.separatorInset = separatorInset
        self.accessoryType = accessoryType
        self.selectionStyle = selectionStyle
    }
}

struct Row {
    var type: CellType
    var cell: Cell
    var image: UIImage?
    var title: Text?
    var subTitle: Text?
    var userInfo: [String: Any]?
    var setupCell: ((UITableView, UITableViewCell, IndexPath)->())?
    var didSelect: ((UITableView, IndexPath)->())?
    
    init(
        type: CellType = .CenterTitle,
        cell: Cell,
        image: UIImage? = nil,
        title: Text? = nil,
        subTitle: Text? = nil,
        userInfo: [String: Any]? = nil,
        setupCell: ((UITableView, UITableViewCell, IndexPath)->())? = nil,
        didSelect: ((UITableView, IndexPath)->())? = nil) {
        self.type = type
        self.cell = cell
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.userInfo = userInfo
        self.setupCell = setupCell
        self.didSelect = didSelect
    }
}

struct Section {
    var headerTitle: String?
    var footerTitle: String?
    var rows: [Row]
    
    init(
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        rows: [Row]) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.rows = rows
    }
    
}

class SimpleTableViewController: UIViewController {
    
    var tableView: UITableView!
    
    fileprivate var tableStyle: UITableViewStyle?
    
    var sections = [Section]()
    var editedText: String?
    var selectedIndexPath: IndexPath?
    var completion: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(tableStyle: UITableViewStyle?) {
        self.init(nibName:nil, bundle:nil)
        self.tableStyle = tableStyle
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If created programmatically
        if self.tableView == nil {
            self.tableView = UITableView(frame: self.view.bounds, style: self.tableStyle ?? .grouped)
            self.tableView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.view.addSubview(self.tableView)
        }
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedSectionHeaderHeight = 15
//        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedSectionFooterHeight = 5
//        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
//        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
//        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Background Color
        self.tableView.backgroundColor = Cons.UI.colorBG
        
        // Register custom cells
        self.tableView.register(UINib(nibName: "TableViewCellCenterTitle",           bundle: Bundle.main), forCellReuseIdentifier: "CenterTitle")
        self.tableView.register(UINib(nibName: "TableViewCellIconTitle",             bundle: Bundle.main), forCellReuseIdentifier: "IconTitle")
        self.tableView.register(UINib(nibName: "TableViewCellIconTitleContent",      bundle: Bundle.main), forCellReuseIdentifier: "IconTitleContent")
        self.tableView.register(UINib(nibName: "TableViewCellLeftTitle",             bundle: Bundle.main), forCellReuseIdentifier: "LeftTitle")
        self.tableView.register(UINib(nibName: "TableViewCellLeftTitleRightDetail",  bundle: Bundle.main), forCellReuseIdentifier: "LeftTitleRightDetail")
        self.tableView.register(UINib(nibName: "TableViewCellTextField",             bundle: Bundle.main), forCellReuseIdentifier: "TextField")
        
        // Setup table data
        if sections.isEmpty {
            self.rebuildTable()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let nextTextField = self.findNextTextField(nil, nil) {
            nextTextField.becomeFirstResponder()
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension SimpleTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: row.type.rawValue, for: indexPath)
        
        switch row.type {
        case .CenterTitle:
            guard let rowCell = cell as? TableViewCellCenterTitle else { break }
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
            if let font = row.title?.font {
                rowCell.lblTitle.font = font
            }
        case .IconTitle:
            guard let rowCell = cell as? TableViewCellIconTitle else { break }
            if let image = row.image {
                rowCell.imgView.image = image
                if (image.size.width > rowCell.imgView.frame.width ||
                    image.size.height > rowCell.imgView.frame.height) {
                    rowCell.imgView.contentMode = .scaleAspectFit
                } else {
                    rowCell.imgView.contentMode = .center
                }
            }
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
            if let font = row.title?.font {
                rowCell.lblTitle.font = font
            }
        case .IconTitleContent:
            guard let rowCell = cell as? TableViewCellIconTitleContent else { break }
            if rowCell.imageRatioConstraint != nil {
                rowCell.imgView.removeConstraint(rowCell.imageRatioConstraint!)
            }
            if let image = row.image {
                rowCell.imgView.image = image
                if (image.size.width > rowCell.imgView.frame.width ||
                    image.size.height > rowCell.imgView.frame.height) {
                    rowCell.imgView.contentMode = .scaleAspectFit
                } else {
                    rowCell.imgView.contentMode = .center
                }
            }
            let ratioConstraint = NSLayoutConstraint(item: rowCell.imgView, attribute: .height, relatedBy: .equal, toItem: rowCell.imgView, attribute: .width, multiplier: (row.image?.size.height ?? 9999) / (row.image?.size.width ?? 1), constant: 0)
            rowCell.imageRatioConstraint = ratioConstraint
            rowCell.imgView.addConstraint(ratioConstraint)
            rowCell.lblTitle.text = row.title?.text
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
            guard let rowCell = cell as? TableViewCellLeftTitle else { break }
            rowCell.lblTitle.text = row.title?.text
            if let color = row.title?.color {
                rowCell.lblTitle.textColor = color
            }
            if let font = row.title?.font {
                rowCell.lblTitle.font = font
            }
        case .LeftTitleRightDetail:
            guard let rowCell = cell as? TableViewCellLeftTitleRightDetail else { break }
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
            guard let rowCell = cell as? TableViewCellTextField else { break }
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
            rowCell.tfTitle.addTarget(self, action: #selector(SimpleTableViewController.textFieldDidEdit(_:)), for: UIControlEvents.editingChanged)
        }
        
        cell.accessoryType = row.cell.accessoryType
        cell.selectionStyle = row.cell.selectionStyle
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = sections[indexPath.section].rows[indexPath.row]
        return row.cell.height ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (sections[section].headerTitle != nil) ? UITableViewAutomaticDimension : 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (sections[section].footerTitle != nil) ? UITableViewAutomaticDimension : 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = sections[indexPath.section].rows[indexPath.row]
        if let didSelectClosure = row.didSelect {
            didSelectClosure(tableView, indexPath)
        }
        
        self.selectedIndexPath = indexPath
    }
}

// MARK: UITextFieldDelegate
extension SimpleTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let position = textField.convert(CGPoint.zero, to: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: position) else { return true }
        
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
    
    func textFieldDidEdit(_ textField: UITextField) {
        self.editedText = textField.text
        let position = textField.convert(CGPoint.zero, to: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: position) else { return }
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
    
    func findNextTextField(_ textField: UITextField?, _ indexPath: IndexPath?) -> UITextField? {
        for idxSection in (indexPath != nil ? indexPath!.section : 0)..<self.sections.count {
            for idxRow in (indexPath != nil ? indexPath!.row : 0)..<self.sections[idxSection].rows.count {
                let row = sections[idxSection].rows[idxRow]
                if row.type == .TextField {
                    if let tableViewCell = self.tableView.cellForRow(at: IndexPath(row: idxRow, section: idxSection)) as? TableViewCellTextField {
                        if tableViewCell.tfTitle != textField {
                            return tableViewCell.tfTitle
                        }
                    }
                }
            }
        }
        return nil
    }
    
    @discardableResult func updateSelectionCheckmark(_ indexPath: IndexPath) -> Bool {
        var isChanged = false
        var newSections = [Section]()
        for indexSection in 0..<self.sections.count {
            var section = self.sections[indexSection]
            var newRows = [Row]()
            for indexRow in 0..<section.rows.count {
                var row = section.rows[indexRow]
                let newAccessoryType = (indexSection == indexPath.section && indexRow == indexPath.row) ? UITableViewCellAccessoryType.checkmark : .none
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
