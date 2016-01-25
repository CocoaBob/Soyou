//
//  TableViewCells.swift
//  iPrices
//
//  Created by CocoaBob on 10/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class TableViewCellCenterTitle: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
}

class TableViewCellIconTitle: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
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