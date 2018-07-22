//
//  CirclesTableViewCell.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-04.
//  Copyright © 2018 Soyou. All rights reserved.
//

class CirclesTableViewCell: UITableViewCell {
    
    var circle: Circle? {
        didSet {
            self.imgURLs = circle?.images as? [[String:String]]
            self.configureCell()
        }
    }
    var imgURLs: [[String: String]]?
    var imagesToSave: [UIImage]?
    var imagesCountToSave: Int = 0
    var textToShare: String?
    weak var parentViewController: CirclesViewController?
    var isLiked = false {
        didSet {
            self.btnLike.setImage(UIImage(named: isLiked ? "img_circle_liked" : "img_circle_like"), for: .normal)
        }
    }
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgUserBadge: UIImageView!
    @IBOutlet var btnName: UIButton!
    @IBOutlet var lblContent: MarginLabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnDeleteWidth: NSLayoutConstraint!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnSaveWidth: NSLayoutConstraint!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var likesContainer: UIView!
    @IBOutlet var likesContainerHeight: NSLayoutConstraint!
    @IBOutlet var likesTextView: UITextView!
    
    @IBOutlet var btnMoreLess: UIButton!
    @IBOutlet var btnMoreLessHeight: NSLayoutConstraint!
    @IBOutlet var lblContentHeight: NSLayoutConstraint!
    
    @IBOutlet var imagesCollectionView: CircleImagesCollectionView!
    @IBOutlet var imagesCollectionViewWidth: NSLayoutConstraint?
    @IBOutlet var imagesCollectionViewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
        self.setupCollectionView()
        self.prepareForReuse()
    }
    
    func setupViews() {
        self.btnShare.setTitle(NSLocalizedString("circles_vc_share_button"), for: .normal)
        self.likesTextView.linkTextAttributes = [NSAttributedStringKey.font.rawValue: UIFont.boldSystemFont(ofSize: 13.0),
                                                 NSAttributedStringKey.foregroundColor.rawValue: UIColor(hex8: 0x5C6994FF)]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgURLs = nil
        self.imgUser.sd_cancelCurrentImageLoad()
        self.imgUser.image = UIImage(named: "img_avatar_placeholder")
        self.imgUserBadge.isHidden = true
        self.btnName.setTitle(nil, for: .normal)
        self.lblContent.text = nil
        self.btnDelete.isHidden = true
        self.btnDeleteWidth.constant = 0
        self.btnSave.isHidden = true
        self.btnSaveWidth.constant = 0
        self.imagesCollectionView.reloadData()
        self.resetMoreLessControl()
        self.updateMoreLessControl()
        self.likesContainerHeight.constant = 0
        self.likesContainer.isHidden = true
        self.likesTextView.text = nil
    }
}

// MARK: - Configure Cell
extension CirclesTableViewCell {
    
    func configureCell() {
        guard let circle = self.circle else {
            return
        }
        self.configureProfileImage(circle)
        self.configureLabels(circle)
        self.configureImagesCollectionView(circle)
        self.configureLikes(circle.likes)
    }
    
    func configureProfileImage(_ circle: Circle) {
        if let str = circle.userProfileUrl, let url = URL(string: str) {
            self.imgUser.sd_setImage(with: url,
                                     placeholderImage: UIImage(named: "img_avatar_placeholder"),
                                     options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority])
        } else {
            self.imgUser.image = UIImage(named: "img_avatar_placeholder")
        }
        if let badge = (circle.userBadges as? [NSDictionary])?.first {
            self.imgUserBadge.isHidden = false
            self.imgUserBadge.image = Member.badgeImage(badge["id"] as? Int, "m")
        } else {
            self.imgUserBadge.isHidden = true
        }
        self.btnDelete.isHidden = UserManager.shared.userID != (circle.userId as? Int)
        self.btnDeleteWidth.constant = self.btnDelete.isHidden ? 0 : 22
        self.btnSave.isHidden = self.imgURLs == nil || self.imgURLs?.count ?? 0 == 0
        self.btnSaveWidth.constant = self.btnSave.isHidden ? 0 : 22
    }
    
    func configureLabels(_ circle: Circle) {
        let strName = circle.username ?? ""
        self.btnName.setTitle(strName.censored(), for: .normal)
        self.lblContent.text = circle.text?.censored()
        self.updateMoreLessControl()
        if let date = circle.createdDate {
            self.lblDate.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        } else {
            self.lblDate.text = nil
        }
    }
    
    func configureImagesCollectionView(_ circle: Circle) {
        guard let imgURLs = self.imgURLs else {
            return
        }
        if let constraint = self.imagesCollectionViewWidth {
            self.imagesCollectionViewContainer.removeConstraint(constraint)
        }
        var ratio = CGFloat(1)
        if imgURLs.count == 1 {
            ratio *= 0.5
        } else if imgURLs.count == 4 {
            ratio *= 2.0 / 3.0
        }
        let constraint = NSLayoutConstraint(item: self.imagesCollectionView,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: self.imagesCollectionViewContainer,
                                            attribute: .width,
                                            multiplier: ratio,
                                            constant: 0)
        self.imagesCollectionViewContainer.addConstraint(constraint)
        self.imagesCollectionViewWidth = constraint
        self.imagesCollectionView.reloadData()
        self.imagesCollectionView.collectionViewLayout.invalidateLayout() // Update layout
    }
    
    func configureLikes(_ likes: NSArray?) {
        var _isLikedByCurrentUser = false
        if let likes = likes, likes.count > 0 {
            self.likesContainerHeight.constant = 9999
            self.likesContainer.isHidden = false
            let attrString = NSMutableAttributedString()
            for like in likes {
                guard
                    let like = like as? NSDictionary,
                    let userId = like["userId"] as? Int,
                    var username = like["username"] as? String else {
                        continue
                }
                // Check if it's the current user
                if userId == UserManager.shared.userID ?? -1 {
                    _isLikedByCurrentUser = true
                }
                // Prepare username
                username = username.removingPercentEncoding ?? username
                guard let based64EncodedName = username.base64Encoded() else {
                    continue
                }
                // Prepare userProfileUrl
                let userProfileUrl = like["userProfileUrl"] as? String
                let based64EncodedProfileUrl = userProfileUrl?.base64Encoded() ?? ""
                guard let userURL = URL(string: "https://soyou.io/\(userId)-\(based64EncodedName)-\(based64EncodedProfileUrl)") else {
                    continue
                }
                // Add comma
                if attrString.length > 0 {
                    attrString.append(NSAttributedString(string: ", ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13.0)]))
                }
                // Add name
                username = username.censored()
                attrString.append(NSAttributedString(string: username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13.0),
                                                                                    NSAttributedStringKey.link: userURL]))
            }
            self.likesTextView.attributedText = attrString
        } else {
            self.likesContainerHeight.constant = 0
            self.likesContainer.isHidden = true
        }
        self.isLiked = _isLikedByCurrentUser
    }
}
