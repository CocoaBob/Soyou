//
//  StatusMessageTableViewCell.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-06.
//  Copyright © 2018 Soyou. All rights reserved.
//

class StatusMessageTableViewCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)
    }
}
