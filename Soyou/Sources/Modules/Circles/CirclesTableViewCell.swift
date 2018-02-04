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
    var textToShare: String?
    var imagesToShare: [UIImage]?
    weak var viewController: CirclesViewController?
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var btnName: UIButton!
    @IBOutlet var lblContent: MarginLabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnForward: UIButton!
    
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
        self.btnDelete.setTitle(NSLocalizedString("circles_vc_delete_button"), for: .normal)
        self.btnForward.setTitle(NSLocalizedString("circles_vc_forward_button"), for: .normal)
        let wechatColor = UIColor(hex8: 0x00bb0cFF)
        self.btnForward.setTitleColor(wechatColor, for: .normal)
        //        self.btnForward.layer.borderWidth = 1
        //        self.btnForward.layer.borderColor = wechatColor.cgColor
        //        self.btnForward.layer.cornerRadius = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgURLs = nil
        self.imgUser.sd_cancelCurrentImageLoad()
        self.imgUser.image = nil
        self.btnName.setTitle(nil, for: .normal)
        self.lblContent.text = nil
        self.btnDelete.isHidden = true
        self.imagesCollectionView.reloadData()
        self.resetMoreLessControl()
        self.updateMoreLessControl()
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
        self.btnDelete.isHidden = UserManager.shared.userID != (circle.userId as? Int)
    }
    
    func configureProfileImage(_ circle: Circle) {
        if let str = circle.userProfileUrl, let url = URL(string: str) {
            self.imgUser.sd_setImage(with: url,
                                     placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                     options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority])
        } else {
            self.imgUser.image = UIImage(named: "img_placeholder_1_1_s")
        }
    }
    
    func configureLabels(_ circle: Circle) {
        self.btnName.setTitle(circle.username ?? "", for: .normal)
        self.lblContent.text = circle.text
        self.updateMoreLessControl()
        if let date = circle.createdDate {
            self.lblDate.text = DateFormatter.localizedString(from: date,
                                                              dateStyle: DateFormatter.Style.medium,
                                                              timeStyle: DateFormatter.Style.short)
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
        //        if let tableView = self.viewController?.tableView() {
        //            UIView.setAnimationsEnabled(false)
        //            tableView.beginUpdates()
        //            tableView.endUpdates()
        //            UIView.setAnimationsEnabled(true)
        //        }
    }
}

// MARK: - CollectionView Delegate & DataSource
extension CirclesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleImageCollectionViewCell",
                                                      for: indexPath)
        if let cell = cell as? CircleImageCollectionViewCell {
            if let dict = self.imgURLs?[indexPath.row] {
                var imageURL: URL?
                if let thumbnailStr = dict["thumbnail"], let thumbnailURL = URL(string: thumbnailStr) {
                    imageURL = thumbnailURL
                }
                cell.imageView.sd_setImage(with: imageURL,
                                           placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                           options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                           completed: { (image, error, type, url) -> Void in
                                            // Update the image with an animation
                                            if (collectionView.indexPathsForVisibleItems.contains(indexPath)) {
                                                if let image = image {
                                                    UIView.transition(with: cell.imageView,
                                                                      duration: 0.3,
                                                                      options: UIViewAnimationOptions.transitionCrossDissolve,
                                                                      animations: { cell.imageView.image = image },
                                                                      completion: nil)
                                                }
                                            }
                })
            } else {
                cell.imageView.image = UIImage(named: "img_placeholder_1_1_s")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageView = (collectionView.cellForItem(at: indexPath) as? CircleImageCollectionViewCell)?.imageView else {
            return
        }
        var image: UIImage?
        if let dict = self.imgURLs?[indexPath.row],
            let str = dict["original"],
            let url = URL(string: str),
            let cachedImage = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: url)) {
            image = cachedImage
        } else if let dict = self.imgURLs?[indexPath.row],
            let str = dict["thumbnail"],
            let url = URL(string: str),
            let cachedImage = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: url)) {
            image = cachedImage
        }
        self.browseImages(imageView, image, UInt(indexPath.row))
    }
}

// MARK: - CollectionView Waterfall Layout
extension CirclesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        // Create a flow layout
        let layout = UICollectionViewLeftAlignedLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets.zero
        
        // Add the waterfall layout to your collection view
        self.imagesCollectionView.collectionViewLayout = layout
        
        // Load data
        self.imagesCollectionView.reloadData()
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let vc = self.viewController, let constraint = self.imagesCollectionViewWidth else {
            return CGSize.zero
        }
        
        let columns = CGFloat((imgURLs?.count == 1 ? 1 : (imgURLs?.count == 4 ? 2 : 3)))
        let collectionViewWidth = (vc.view.bounds.width - 73 * 2) * constraint.multiplier
        let size = floor((floor(collectionViewWidth) - (4 * (columns - 1))) / columns)
        return CGSize(width: size, height: size)
        
        //        let columns = CGFloat((imgURLs?.count == 1 ? 1 : (imgURLs?.count == 4 ? 2 : 3)))
        //        let size = floor((collectionView.bounds.width - 4 * (columns - 1)) / columns)
        //        return CGSize(width: size, height: size)
    }
}

// MARK: More/Less control
extension CirclesTableViewCell {
    
    func resetMoreLessControl() {
        self.lblContentHeight.isActive = true
    }
    
    func contentIsMoreThanSixLines() -> Bool {
        let maxHeight = self.lblContent.sizeThatFits(CGSize(width: self.lblContent.bounds.width,
                                                            height: CGFloat.greatestFiniteMagnitude)).height
        return maxHeight > 108 // height for 6 lines
    }
    
    func updateMoreLessControl() {
        if self.contentIsMoreThanSixLines() {
            self.btnMoreLessHeight.constant = 26 // Button height
            self.btnMoreLess.isHidden = false
            let title = self.lblContentHeight.isActive ? "circles_vc_button_more" : "circles_vc_button_less"
            self.btnMoreLess.setTitle(NSLocalizedString(title), for: .normal)
            self.lblContent.bottomInset = 0 // Bottom margin
            self.lblContentHeight.constant = 108 // Height of 6 lines
        } else {
            self.btnMoreLessHeight.constant = 0
            self.btnMoreLess.isHidden = true
            self.lblContent.bottomInset = ((self.circle?.images?.count ?? 0) > 0) ? 8 : 0 // Bottom margin
            self.lblContentHeight.constant = 116 // 108 + 8 bottom margin
        }
    }
    
    @IBAction func toggleMoreLessControl() {
        self.lblContentHeight.isActive = !self.lblContentHeight.isActive
        self.updateMoreLessControl()
        if let tableView = self.viewController?.tableView() {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

// MARK: CirclesTableViewCell Actions
extension CirclesTableViewCell {
    
    @IBAction func delete() {
        guard let circle = self.circle, let circleID = circle.id else {
            return
        }
        guard let vc = self.viewController else {
            return
        }
        let alertController = UIAlertController(title: nil,
                                                message: NSLocalizedString("circles_vc_delete_alert"),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_delete"),
                                                style: UIAlertActionStyle.default,
                                                handler: { (action: UIAlertAction) -> Void in
                                                    MBProgressHUD.show(vc.view)
                                                    DataManager.shared.deleteCircle(circleID) { responseObject, error in
                                                        circle.delete({
                                                            MBProgressHUD.hide(vc.view)
                                                        })
                                                    }
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_cancel"),
                                                style: UIAlertActionStyle.default,
                                                handler: { (action: UIAlertAction) -> Void in
        }))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func forward() {
        guard let circle = self.circle else {
            return
        }
        if let imgURLs = self.imgURLs {
            var urls = [URL]()
            for dict in imgURLs {
                if let str = dict["original"], let url = URL(string: str) {
                    urls.append(url)
                }
            }
            self.forwardTextAndImages(text: circle.text, urls: urls)
        } else {
            self.forwardTextAndImages(text: circle.text, urls: nil)
        }
    }
    
    func browseImages(_ view: UIView, _ image: UIImage?, _ index: UInt) {
        guard let imgURLs = self.imgURLs else {
            return
        }
        var photos = [IDMPhoto]()
        for dict in imgURLs {
            if let originalStr = dict["original"], let originalURL = URL(string: originalStr) {
                photos.append(IDMPhoto(url: originalURL))
            }
        }
        IDMPhotoBrowser.present(photos, index: index, view: view, scaleImage: image, viewVC: self.viewController)
    }
    
    @IBAction func viewUserCircles() {
        guard let circle = self.circle, let vc = self.viewController else { return }
        var needsToPush = true
        if let nextID = circle.userId as? Int, let currID = vc.userID, currID == nextID {
            needsToPush = false
        }
        if needsToPush {
            CirclesViewController.pushNewInstance(circle.userId as? Int, circle.userProfileUrl, circle.username, from: vc.navigationController)
        }
    }
}

// MARK: Share original images
extension CirclesTableViewCell: CircleComposeViewControllerDelegate {
    
    func forwardTextAndImages(text: String?, urls: [URL]?) {
        self.textToShare = text
        self.imagesToShare = ((urls?.count ?? 0) > 0) ? [UIImage]() : nil
        
        if let urls = urls {
            let dispatchGroup = DispatchGroup()
            for url in urls {
                let cacheKey = SDWebImageManager.shared().cacheKey(for: url)
                if let image = SDImageCache.shared().imageFromCache(forKey: cacheKey) {
                    self.imagesToShare?.append(image)
                } else {
                    MBProgressHUD.show(self.viewController?.view)
                    dispatchGroup.enter()
                    SDWebImageManager.shared().loadImage(
                        with: url,
                        options: [.continueInBackground, .allowInvalidSSLCertificates],
                        progress: nil,
                        completed: { (image, data, error, type, finished, url) -> Void in
                            MBProgressHUD.hide(self.viewController?.view)
                            if let image = image {
                                self.imagesToShare?.append(image)
                            }
                            dispatchGroup.leave()
                    })
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.composeTextAndImages(text: self.textToShare, images: self.imagesToShare)
            }
        } else {
            self.composeTextAndImages(text: self.textToShare, images: nil)
        }
    }
    
    func composeTextAndImages(text: String?, images: [UIImage]?) {
        // Prepare TLPHAsset
        var assets: [TLPHAsset]?
        if let images = images {
            assets = [TLPHAsset]()
            for image in images {
                assets?.append(TLPHAsset(image: image))
            }
        }
        // Create CircleComposeViewController
        let vc = CircleComposeViewController.instantiate()
        let nav = UINavigationController(rootViewController: vc)
        // Setup
        vc.delegate = self
        vc.customAssets = assets
        vc.selectedAssets = assets
        vc.loadViewIfNeeded()
        vc.tvContent.text = text
        vc.isOnlySharing = true
        // Present
        self.viewController?.tabBarController?.present(nav, animated: true, completion: nil)
    }
    
    func didDismiss(text: String?, images: [UIImage]?, needsToShare: Bool) {
        if needsToShare {
            DataManager.shared.analyticsShareCircle(id: self.circle?.id ?? "")
            Utils.shareTextAndImagesToWeChat(from: self.viewController, text: text, images: images)
        }
    }
}
