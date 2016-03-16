//
//  TableViewCells.swift
//  Soyou
//
//  Created by CocoaBob on 10/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class TableViewCellCenterTitle: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
}

class TableViewCellIconTitle: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
}

class TableViewCellIconTitleContent: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tvContent: UITextView!
    @IBOutlet var imageRatioConstraint: NSLayoutConstraint?
}

class TableViewCellLeftTitle: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
}

class TableViewCellLeftTitleRightDetail: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
}

class TableViewCellSectionHeader: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
}

class TableViewCellTextField: UITableViewCell {
    
    @IBOutlet var tfTitle: UITextField!
}
