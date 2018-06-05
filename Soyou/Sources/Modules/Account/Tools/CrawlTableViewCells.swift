//
//  CrawlTableViewCell.swift
//  Soyou
//
//  Created by CocoaBob on 2018-06-05.
//  Copyright © 2018 Soyou. All rights reserved.
//

class CrawlTableViewCell: UITableViewCell {
    
    var crawl: Crawl? {
        didSet {
            self.configureCell()
        }
    }
    
    @IBOutlet var lblLabel: UILabel!
    @IBOutlet var lblUrl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblLabel.text = nil
        self.lblUrl.text = nil
    }
    
    func configureCell() {
        if let crawl = self.crawl {
            self.lblLabel.text = crawl.label
            self.lblUrl.text = crawl.url
        } else {
            self.prepareForReuse()
        }
    }
}

class EditCrawlTableViewCell: UITableViewCell {
    
    @IBOutlet var textfield: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        self.separatorInset = UIEdgeInsets.zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textfield.text = nil
    }
}

