//
//  MembersTableViewCell.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-04.
//  Copyright © 2018 Soyou. All rights reserved.
//

class MembersTableViewCell: UITableViewCell {
    
    var member: Member? {
        didSet {
            self.configureCell()
        }
    }
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgUserBadge: UIImageView?
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgCheckbox: UIImageView!
    @IBOutlet var imgCheckboxWidth: NSLayoutConstraint!
    @IBOutlet var imgCheckboxTrailing: NSLayoutConstraint!
    
    var showCheckbox = false {
        didSet {
            self.imgCheckboxWidth.constant = showCheckbox ? 22 : 0
            self.imgCheckboxTrailing.constant = showCheckbox ? 20 : 0
        }
    }
    
    var showDisclosureIndicator = false {
        didSet {
            self.accessoryType = showDisclosureIndicator ? .disclosureIndicator : .none
        }
    }
    
    var isMemberSelected = false {
        didSet {
            self.imgCheckbox.image = UIImage(named: isMemberSelected ? "img_cell_checked_blue" : "img_cell_unchecked")
        }
    }
    var isMemberExcluded = false {
        didSet {
            if isMemberExcluded {
                self.imgCheckbox.image = UIImage(named: "img_cell_checked_gray")
                self.selectionStyle = .none
            } else {
                let isSelected = self.isMemberSelected
                self.isMemberSelected = isSelected
                self.selectionStyle = .gray
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        self.separatorInset = UIEdgeInsets.zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgUser.sd_cancelCurrentImageLoad()
        self.imgUser.image = nil
        self.imgUserBadge?.isHidden = true
        self.lblName.text = nil
    }
}

// MARK: - Configure Cell
extension MembersTableViewCell {
    
    func configureCell() {
        guard let member = self.member else {
            return
        }
        if let profileUrlStr = member.profileUrl, let url = URL(string: profileUrlStr) {
            self.imgUser.setImageWithCensorship(with: url,
                                                placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                                options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority])
        } else {
            self.imgUser.image = UIImage(named: "img_placeholder_1_1_s")
        }
        if let badge = member.badges?.first as? NSDictionary {
            self.imgUserBadge?.isHidden = false
            self.imgUserBadge?.image = Member.badgeImage(badge["id"] as? Int, "m")
        } else {
            self.imgUserBadge?.isHidden = true
        }
        self.lblName.text = member.username?.censored()
    }
}
