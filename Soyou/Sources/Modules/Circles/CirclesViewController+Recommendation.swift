//
//  CirclesViewController+Recommendation.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-20.
//  Copyright © 2018 Soyou. All rights reserved.
//

// MARK: - Update Recommendations
extension CirclesViewController {
    
    func updateRecommendations() {
        guard let tableHeaderView = self.tableView().tableHeaderView else {
            return
        }
        let needsToShow = !isSingleUserMode && self.recommendations?.count ?? 0 > 0
        let newHeight: CGFloat = needsToShow ? 80.0 : 0.0
        if tableHeaderView.frame.height != newHeight {
            var frame = tableHeaderView.frame
            frame.size.height = newHeight
            tableHeaderView.frame = frame
            self.tableView().tableHeaderView = tableHeaderView
        }
        self.recommendationsCollectionView.reloadData()
    }
}

// MARK: - CollectionView Delegate & DataSource
extension CirclesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommendations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationsCollectionViewCell",
                                                      for: indexPath)
        if let user = self.recommendations?[indexPath.row],
            let cell = cell as? RecommendationsCollectionViewCell {
            cell.configureCell(user)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let user = self.recommendations?[indexPath.row] {
            CirclesViewController.pushNewInstance(user.id, user.profileUrl, user.username, from: self.navigationController)
        }
    }
}

class RecommendationsCollectionView: UICollectionView {
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return super.contentSize
    }
    
    override func reloadData() {
        super.reloadData()
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
}

class RecommendationsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgUserBadge: UIImageView!
    @IBOutlet var lblUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgUser.sd_cancelCurrentImageLoad()
        self.imgUser.image = UIImage(named: "img_avatar_placeholder")
        self.imgUserBadge.isHidden = true
        self.lblUsername.text = nil
    }
    
    func configureCell(_ user: Member) {
        if let profileUrlStr = user.profileUrl, let url = URL(string: profileUrlStr) {
            self.imgUser.sd_setImage(with: url,
                                     placeholderImage: UIImage(named: "img_avatar_placeholder"),
                                     options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority])
        } else {
            self.imgUser.image = UIImage(named: "img_avatar_placeholder")
        }
        if let badge = user.badges?.first as? NSDictionary {
            self.imgUserBadge.isHidden = false
            self.imgUserBadge.image = Member.badgeImage(badge["id"] as? Int, "m")
        } else {
            self.imgUserBadge.isHidden = true
        }
        self.lblUsername.text = user.username?.censored()
    }
}
