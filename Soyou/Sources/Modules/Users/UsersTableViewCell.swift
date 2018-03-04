//
//  UsersTableViewCell.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-04.
//  Copyright © 2018 Soyou. All rights reserved.
//

class UsersTableViewCell: UITableViewCell {
    
    var follower: User? {
        didSet {
            self.configureCell()
        }
    }
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgUserBadge: UIImageView?
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
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
extension UsersTableViewCell {
    
    func configureCell() {
        guard let follower = self.follower else {
            return
        }
        if let url = URL(string: follower.profileUrl) {
            self.imgUser.sd_setImage(with: url,
                                     placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                     options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority])
        } else {
            self.imgUser.image = UIImage(named: "img_placeholder_1_1_s")
        }
        self.imgUserBadge?.isHidden = follower.badges?.count ?? 0 == 0
        self.lblName.text = follower.username
    }
}
