//
//  CircleComposeViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-01-06.
//  Copyright © 2018 Soyou. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

protocol CircleComposeViewControllerDelegate {
    
    func didPostNewCircle()
    func didDismiss(text: String?, images: [UIImage]?, needsToShare: Bool)
}

extension CircleComposeViewControllerDelegate {
    
    func didPostNewCircle() {}
    func didDismiss(text: String?, images: [UIImage]?, needsToShare: Bool) {}
}

class CircleComposeViewController: UITableViewController {
    
    var delegate: CircleComposeViewControllerDelegate?
    var customAssets: [TLPHAsset]?
    var selectedAssets: [TLPHAsset]? {
        didSet {
            self.updatePostButton()
        }
    }
    var isSharing = false {// If true, we will submit images and text to circles
        didSet {
            if self.isViewLoaded {
                self.setupViews()
            }
        }
    }
    var isPublicDisabled = false
    
    var visibility: Int = CircleVisibility.friends {
        didSet {
            if self.isViewLoaded {
                self.updateVisibility()
            }
        }
    }
    var allowedTags: [Tag]?
    var forbiddenTags: [Tag]?
    
    var originalId: String? // If it's forwarding another circle, this is the other one's ID
    var content: String? {
        didSet {
            if self.isViewLoaded {
                self.tvContent.text = content
            }
        }
    }
    
    @IBOutlet var tvContent: UITextView!
    @IBOutlet var imagesCollectionView: UICollectionView!
    
    @IBOutlet var imgShareToWeChat: UIImageView!
    @IBOutlet var lblShareToWeChat: UILabel!
    @IBOutlet var shareToWeChat: UISwitch!
    
    @IBOutlet var imgSubmitToSoyou: UIImageView!
    @IBOutlet var lblSubmitToSoyou: UILabel!
    @IBOutlet var submitToSoyou: UISwitch!
    
    @IBOutlet var imgVisibility: UIImageView!
    @IBOutlet var lblVisibilityTitle: UILabel!
    @IBOutlet var lblVisibilityValue: UILabel!
    
    // Class methods
    class func instantiate() -> CircleComposeViewController {
        return UIStoryboard(name: "CirclesViewController", bundle: nil).instantiateViewController(withIdentifier: "CircleComposeViewController") as! CircleComposeViewController
    }
    
    // UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide tabs
        self.hidesBottomBarWhenPushed = true
        // Setup Views
        self.setupViews()
        // TableView
        self.setupTableView()
        // ImagesCollectionView
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: - Setup Views
extension CircleComposeViewController {
    
    func setupViews() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("alert_button_cancel"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(CircleComposeViewController.quitEditing))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(self.isSharing ? "circle_compose_share" : "circle_compose_post"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(CircleComposeViewController.post))
        self.updatePostButton()
        self.tvContent.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8)
        self.tvContent.textContainer.lineFragmentPadding = 0
        let currContent = self.content
        self.content = currContent
        self.lblShareToWeChat.text = NSLocalizedString("circle_compose_share_to_wechat")
        self.imgShareToWeChat.image = UIImage(named: "img_moments")?.withRenderingMode(.alwaysTemplate)
        self.imgShareToWeChat.tintColor = UIColor.gray
        self.shareToWeChat.isEnabled = !self.isSharing
        self.shareToWeChat.isOn = self.isSharing
        self.lblSubmitToSoyou.text = NSLocalizedString("circle_compose_submit_to_soyou")
        self.imgSubmitToSoyou.image = UIImage(named: "img_soyou_logo")?.withRenderingMode(.alwaysTemplate)
        self.imgSubmitToSoyou.tintColor = UIColor.gray
        self.submitToSoyou.isEnabled = true
        self.submitToSoyou.isOn = !self.isSharing
        self.imgVisibility.image = UIImage(named: "img_globe")?.withRenderingMode(.alwaysTemplate)
        self.visibility = self.isSharing ? CircleVisibility.friends : CircleVisibility.everyone
        self.lblVisibilityTitle.text = NSLocalizedString("circle_compose_visibility_title")
        self.updateVisibility()
    }
}

// MARK: - TableView
extension CircleComposeViewController {
    
    func setupTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 104
            } else if indexPath.row == 1 {
                let topBottomMargin = CGFloat(10)
                let leftRightMargin = CGFloat(20)
                let cellSize = CGFloat(80)
                let cellSpacing = CGFloat(4)
                let collectionViewWidth = tableView.frame.width - leftRightMargin - leftRightMargin
                let rowSize = floor((CGFloat(collectionViewWidth) - cellSize) / (cellSize + cellSpacing)) + 1
                var cellCount = CGFloat(self.selectedAssets?.count ?? 0)
                if cellCount < 9 {
                    cellCount += 1
                }
                let rowCount = ceil(cellCount / rowSize)
                let collectionViewHeight = cellSize + (cellSize + cellSpacing) * (rowCount - 1)
                return topBottomMargin + collectionViewHeight + topBottomMargin
            } else if indexPath.row == 2 {
                return 44
            }
        } else if indexPath.section == 1 {
            return 44
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Hide the separator for the 1st cell
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsetsMake(0, self.tableView.bounds.width, 0, 0)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            self.changeVisibility()
        }
    }
}

// MARK: - CollectionView Delegate & DataSource
extension CircleComposeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.selectedAssets?.count ?? 0
        return count >= 9 ? 9 : count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleImageCollectionViewCell", for: indexPath)
        
        if let cell = cell as? CircleImageCollectionViewCell {
            if indexPath.row < self.selectedAssets?.count ?? 0 {
                guard let tlphAsset = self.selectedAssets?[indexPath.row] else {
                    return cell
                }
                if let image = tlphAsset.fullResolutionImage {
                    cell.imageView.image = image
                } else {
                    cell.imageView.image = UIImage(named: "img_placeholder_1_1_s")
                    tlphAsset.cloudImageDownload(progressBlock: { (progress) in
                        DispatchQueue.main.async {
                            if progress != 1 {
                                cell.progressView?.isHidden = false
                                cell.progressView?.setProgress(CGFloat(progress), animated: true)
                            } else  if progress == 1 {
                                cell.progressView?.setProgress(CGFloat(progress), animated: false)
                                cell.progressView?.isHidden = true
                            }
                        }
                    }, completionBlock: { (image) in
                        if let image = image {
                            tlphAsset.fullResolutionImage = image
                            cell.imageView.image = image
                        }
                    })
                }
                cell.deleteAction = { cell in
                    if let indexPath = collectionView.indexPath(for: cell) {
                        // Reload table view
                        self.selectedAssets?.remove(at: indexPath.row)
                        self.imagesCollectionView.reloadData()
                        // Update cell height
                        self.tableView.beginUpdates()
                        self.tableView.endUpdates()
                    }
                }
            } else {
                cell.imageView.contentMode = .center
                cell.imageView.image = UIImage(named: "img_plus_40")
                cell.imageView.layer.borderWidth = 1
                cell.imageView.layer.borderColor = UIColor.lightGray.cgColor
                cell.selectedBackgroundView = UIView()
                cell.selectedBackgroundView?.backgroundColor = UIColor(white: 0, alpha: 0.1)
                cell.deleteAction = nil
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Add button
        if indexPath.row == self.selectedAssets?.count ?? 0 {
            self.addPicture()
        } else {
            if let imageView = (collectionView.cellForItem(at: indexPath) as? CircleImageCollectionViewCell)?.imageView {
                self.browseImages(imageView, UInt(indexPath.row))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row == self.selectedAssets?.count ?? 0 {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard var selectedAssets = self.selectedAssets, destinationIndexPath.row < selectedAssets.count else {
            return
        }
        let asset = selectedAssets[sourceIndexPath.row]
        selectedAssets.remove(at: sourceIndexPath.row)
        selectedAssets.insert(asset, at: destinationIndexPath.row)
        
        for (index, asset) in selectedAssets.enumerated() {
            asset.selectedOrder = index + 1
        }
        
        self.selectedAssets = selectedAssets
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        guard let count = self.selectedAssets?.count else {
            return IndexPath(row:0, section:0)
        }
        if proposedIndexPath.row == count {
            return IndexPath(row: max(0, count - 1), section:0)
        } else {
            return proposedIndexPath
        }
    }
}

// MARK: - CollectionView Waterfall Layout
extension CircleComposeViewController: UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        // Create a flow layout
        let layout = UICollectionViewLeftAlignedLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width: 80, height: 80)
        
        // Add the waterfall layout to your collection view
        self.imagesCollectionView.collectionViewLayout = layout
        
        // Load data
        self.imagesCollectionView.reloadData()
        
        // Add Drag&Drop gesture
        self.setupDraggingGesture()
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

// MARK: - Update Edited status and POST button
extension CircleComposeViewController: UITextViewDelegate {
    
    func isEdited() -> Bool {
        return (self.selectedAssets?.count ?? 0 > 0) || (self.tvContent.text.count > 0)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updatePostButton()
    }
    
    func updatePostButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = self.isEdited()
    }
}

// MARK: - Actions
extension CircleComposeViewController {
    
    @IBAction func quitEditing() {
        if !self.isEdited() {
            self.dismissSelf()
            return
        }
        UIAlertController.presentAlert(from: self,
                                       message: NSLocalizedString("circle_compose_quit_editing_title"),
                                       UIAlertAction(title: NSLocalizedString("circle_compose_quit_editing_quit"),
                                                     style: UIAlertActionStyle.default,
                                                     handler: { (action: UIAlertAction) -> Void in
                                                        self.dismissSelf()
                                       }),
                                       UIAlertAction(title: NSLocalizedString("alert_button_cancel"),
                                                     style: UIAlertActionStyle.cancel,
                                                     handler: nil))
    }
    
    @IBAction func post() {
        if self.submitToSoyou.isOn {
            let text = self.tvContent.text
            CensorshipManager.censorThenDo(text) {
                MBProgressHUD.show(self.view)
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                UserManager.shared.loginOrDo {
                    let images = self.selectedAssets?.flatMap() { $0.fullResolutionImage?.resizedImage(byMagick: "1080x1080^") }
                    let imageDatas = images?.flatMap() { UIImageJPEGRepresentation($0, 0.6) }
                    var allowedUserIds = Set<Int>()
                    if let allowedTags = self.allowedTags {
                        for tag in allowedTags {
                            for tagUser in tag.members ?? [] {
                                allowedUserIds.insert(tagUser.userId)
                            }
                        }
                    }
                    var forbiddenUserIds = Set<Int>()
                    if let forbiddenTags = self.forbiddenTags {
                        for tag in forbiddenTags {
                            for tagUser in tag.members ?? [] {
                                forbiddenUserIds.insert(tagUser.userId)
                            }
                        }
                    }
                    DataManager.shared.createCircle(text, imageDatas, self.visibility,
                                                    allowedUserIds.isEmpty ? nil : Array(allowedUserIds), forbiddenUserIds.isEmpty ? nil : Array(forbiddenUserIds),
                                                    self.originalId) { (responseObject, error) in
                                                        MBProgressHUD.hide(self.view)
                                                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                                                        self.delegate?.didPostNewCircle()
                                                        self.dismiss(animated: true, completion: {
                                                            self.delegate?.didDismiss(text: text, images: images, needsToShare: self.shareToWeChat.isOn)
                                                        })
                    }
                }
            }
        } else {
            let text = self.tvContent.text
            let images = self.selectedAssets?.flatMap() { $0.fullResolutionImage?.resizedImage(byMagick: "1080x1080^") }
            self.dismiss(animated: true, completion: {
                self.delegate?.didDismiss(text: text, images: images, needsToShare: self.shareToWeChat.isOn)
            })
        }
    }
    
    @IBAction func toggleShareToWeChat(sender: UISwitch) {
        if sender.isOn && !UserManager.shared.isWeChatUser {
            sender.setOn(false, animated: true)
            Utils.showWeChatSignInWarning(from: self) {
                if let tabC = self.presentingViewController as? UITabBarController {
                    // Dismiss self
                    self.dismiss(animated: true, completion: {
                        // Show the User tab
                        tabC.selectedViewController = tabC.viewControllers?.last
                    })
                }
            }
        }
    }
    
    func browseImages(_ view: UIView, _ index: UInt) {
        guard let assets = self.selectedAssets else {
            return
        }
        var photos = [IDMPhoto]()
        var scaleImage: UIImage?
        for (i, asset) in assets.enumerated() {
            if let photo = IDMPhoto(image: asset.fullResolutionImage) {
                photo.placeholderImage = asset.fullResolutionImage
                photos.append(photo)
                if i == index {
                    scaleImage = asset.fullResolutionImage
                }
            }
        }
        IDMPhotoBrowser.present(photos, index: index, view: view, scaleImage: scaleImage, viewVC: self)
    }
}

// MARK: - Reordering
private var oldIndexPathKey: UInt8 = 0
private var snapshotViewKey: UInt8 = 0
private var deleteViewKey: UInt8 = 0
extension CircleComposeViewController {
    
    var oldIndexPath: NSIndexPath {
        get {
            return associatedObject(base: self, key: &oldIndexPathKey) ?? NSIndexPath()
        }
        set {
            associateObject(base: self, key: &oldIndexPathKey, value: newValue)
        }
    }
    
    var snapshotView: UIView {
        get {
            return associatedObject(base: self, key: &snapshotViewKey) ?? UIView()
        }
        set {
            associateObject(base: self, key: &snapshotViewKey, value: newValue)
        }
    }
    
    var deleteView: UILabel {
        get {
            return associatedObject(base: self, key: &deleteViewKey) ?? UILabel()
        }
        set {
            associateObject(base: self, key: &deleteViewKey, value: newValue)
        }
    }
    
    func updateDeleteView(gesture: UIGestureRecognizer) {
        let location = gesture.location(in: self.currentWindow())
        if self.deleteView.frame.contains(location) {
            self.deleteView.backgroundColor = UIColor(hex8: 0xd67b76FF)
            self.deleteView.text = NSLocalizedString("circle_compose_drop_to_delete")
        } else {
            self.deleteView.backgroundColor = UIColor(hex8: 0xd65e57FF)
            self.deleteView.text = NSLocalizedString("circle_compose_drag_to_delete")
        }
    }
    
    func setupDraggingGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(CircleComposeViewController.handleLongGesture(gesture:)))
        self.imagesCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    func currentWindow() -> UIView {
        if let window = self.view.window {
            return window
        } else {
            return self.view
        }
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        let currentWindow = self.currentWindow()
        let currentLocation = gesture.location(in: currentWindow)
        switch(gesture.state) {
        case .began:
            // Get current index and cell
            guard let indexPath = self.imagesCollectionView.indexPathForItem(at: gesture.location(in: self.imagesCollectionView)),
                let cell = self.imagesCollectionView.cellForItem(at: indexPath) else {
                break
            }
            // Cannot drag the + button
            if !self.collectionView(self.imagesCollectionView, canMoveItemAt: indexPath) {
                gesture.state = .cancelled
                break
            }
            // Dismiss keyboard
            self.dismissKeyboard()
            // Create snapshot view
            self.oldIndexPath = indexPath as NSIndexPath
            if let snapshotView = cell.snapshotView(afterScreenUpdates: false) {
                currentWindow.addSubview(snapshotView)
                self.snapshotView = snapshotView
                self.snapshotView.frame = cell.convert(cell.bounds, to: currentWindow)
                cell.isHidden = true
            }
            // Create delete view
            let _deleteView = UILabel()
            _deleteView.textColor = .white
            _deleteView.textAlignment = NSTextAlignment.center
            currentWindow.insertSubview(_deleteView, belowSubview: self.snapshotView)
            // Prepare delete view initial position
            _deleteView.snp.makeConstraints({ (make) in
                make.height.equalTo(64 + Cons.UI.screenBottomMargin)
                make.left.right.equalToSuperview()
                make.top.equalTo(currentWindow.snp.bottom).offset(-(64 + Cons.UI.screenBottomMargin))
            })
            self.deleteView = _deleteView
            self.updateDeleteView(gesture: gesture)
            UIView.animate(withDuration: 0.3, animations: {
                // Show snapshot view
                self.snapshotView.center = currentLocation
                self.snapshotView.transform = cell.transform.scaledBy(x: 1.2, y: 1.2)
                self.snapshotView.alpha = 0.5
            })
        case .changed:
            self.snapshotView.center = currentLocation
            for cell in self.imagesCollectionView.visibleCells {
                let oldIndexPath = self.oldIndexPath as IndexPath
                guard var cellIndexPath = self.imagesCollectionView.indexPath(for: cell) else {
                    break
                }
                cellIndexPath = self.collectionView(self.imagesCollectionView, targetIndexPathForMoveFromItemAt: oldIndexPath, toProposedIndexPath: cellIndexPath)
                if cellIndexPath == oldIndexPath {
                    continue
                }
                let snapshotViewCenter = self.imagesCollectionView.convert(self.snapshotView.center, from: currentWindow)
                let distance = sqrtf(pow(Float(snapshotViewCenter.x - cell.center.x), 2) + powf(Float(snapshotViewCenter.y - cell.center.y), 2))
                if distance <= Float(self.snapshotView.bounds.size.width / 2.0) {
                    let moveIndexPath = cellIndexPath
                    self.imagesCollectionView.moveItem(at: oldIndexPath, to: moveIndexPath)
                    self.collectionView(self.imagesCollectionView, moveItemAt: oldIndexPath, to: moveIndexPath)
                    self.oldIndexPath = moveIndexPath as NSIndexPath
                    break
                }
            }
            self.updateDeleteView(gesture: gesture)
        default:
            guard let cell = self.imagesCollectionView.cellForItem(at: self.oldIndexPath as IndexPath) else {
                return
            }
            // Delete the asset if it's in the delete view
            if self.deleteView.frame.contains(currentLocation) {
                self.imagesCollectionView.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.15, animations: {
                    self.snapshotView.transform = self.snapshotView.transform.scaledBy(x: 2, y: 2)
                    self.snapshotView.alpha = 0.0
                }, completion: { (finished) in
                    self.imagesCollectionView.isUserInteractionEnabled = true
                    self.snapshotView.removeFromSuperview()
                    // Reload table view
                    self.selectedAssets?.remove(at: self.oldIndexPath.row)
                    cell.isHidden = false
                    self.imagesCollectionView.reloadData()
                    // Update cell height
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                })
            } else {
                self.imagesCollectionView.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.3, animations: {
                    // Hide snapshot view
                    self.snapshotView.center = self.imagesCollectionView.convert(cell.center, to: currentWindow)
                    self.snapshotView.transform = CGAffineTransform.identity
                    self.snapshotView.alpha = 1.0
                }, completion: { (finished) in
                    self.imagesCollectionView.isUserInteractionEnabled = true
                    self.snapshotView.removeFromSuperview()
                    cell.isHidden = false
                })
            }
            self.deleteView.removeFromSuperview()
        }
    }
}

// MARK: - TLPhotosPickerViewControllerDelegate
extension CircleComposeViewController: TLPhotosPickerViewControllerDelegate {
    
    func addPicture() {
        PicturePickerViewController.pick9Photos(from: self,
                                                customAssets: self.customAssets,
                                                selectedAssets: self.selectedAssets,
                                                maxSelection: 9,
                                                delegate: self)
    }
    
    func didDismissPhotoPicker(with tlphAssets: [TLPHAsset]) {
        self.selectedAssets = tlphAssets
        UIView.setAnimationsEnabled(false)
        self.imagesCollectionView.reloadData()
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        UIView.setAnimationsEnabled(true)
        self.updatePostButton()
    }
}

// MARK: - Change Visibility
extension CircleComposeViewController {
    
    func changeVisibility() {
        let vc = CircleVisibilityViewController.instantiate()
        vc.isPublicDisabled = self.isPublicDisabled
        vc.completionHandler = { visibility, allowedTags, forbiddenTags in
            self.visibility = visibility
            self.allowedTags = allowedTags
            self.forbiddenTags = forbiddenTags
            self.updateVisibility()
        }
        if self.visibility == CircleVisibility.everyone {
            vc.selectedVisibility = Visibility.everyone
        } else if self.visibility == CircleVisibility.friends {
            if let _ = self.allowedTags {
                vc.selectedVisibility = Visibility.allowSelected
            } else if let _ = self.forbiddenTags {
                vc.selectedVisibility = Visibility.forbidSelected
            } else {
                vc.selectedVisibility = Visibility.followers
            }
        }  else if self.visibility == CircleVisibility.author {
            vc.selectedVisibility = Visibility.author
        }
        if let allowedTags = self.allowedTags {
            vc.selectedTags = Set(allowedTags)
        } else if let forbiddenTags = self.forbiddenTags {
            vc.selectedTags = Set(forbiddenTags)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateVisibility() {
        if self.visibility == CircleVisibility.everyone {
            self.imgVisibility.tintColor = Cons.UI.colorWeChat
            self.lblVisibilityValue.text = NSLocalizedString("circle_compose_visibility_everyone")
        } else if self.visibility == CircleVisibility.friends {
            self.imgVisibility.tintColor = Cons.UI.colorLike
            if let allowedTags = self.allowedTags {
                let tagNames = allowedTags.flatMap({ $0.label }).joined(separator: ", ")
                self.lblVisibilityValue.text = tagNames
            } else if let forbiddenTags = self.forbiddenTags {
                let tagNames = forbiddenTags.flatMap({ $0.label }).joined(separator: ", ")
                self.lblVisibilityValue.text = FmtString(NSLocalizedString("circle_compose_visibility_followers_except"), tagNames)
            } else {
                self.lblVisibilityValue.text = NSLocalizedString("circle_compose_visibility_followers")
            }
        } else if self.visibility == CircleVisibility.author {
            self.imgVisibility.tintColor = Cons.UI.colorStore
            self.lblVisibilityValue.text = NSLocalizedString("circle_compose_visibility_author")
        }
    }
}
