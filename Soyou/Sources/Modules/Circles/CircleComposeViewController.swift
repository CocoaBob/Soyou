//
//  CircleComposeViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-01-06.
//  Copyright © 2018 Soyou. All rights reserved.
//

protocol CircleComposeViewControllerDelegate {
    
    func didPostNewCircle()
    func didDismiss(text: String?, images: [UIImage]?, needsToShare: Bool)
}

class CircleComposeViewController: UITableViewController {
    
    var delegate: CircleComposeViewControllerDelegate?
    var selectedAssets: [TLPHAsset]?
    
    @IBOutlet var tvContent: UITextView!
    @IBOutlet var imagesCollectionView: UICollectionView!
    
    @IBOutlet var imgShareToWeChat: UIImageView!
    @IBOutlet var lblShareToWeChat: UILabel!
    @IBOutlet var shareToWeChat: UISwitch!
    
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
        // Action button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("alert_button_cancel"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(CircleComposeViewController.quitEditing))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("circle_compose_post"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(CircleComposeViewController.post))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
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
        
        self.tvContent.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

extension CircleComposeViewController {
    
    func setupViews() {
        self.tvContent.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8)
        self.tvContent.textContainer.lineFragmentPadding = 0
        self.lblShareToWeChat.text = NSLocalizedString("circle_compose_share_to_wechat")
        self.imgShareToWeChat.image = UIImage(named: "img_moments")?.withRenderingMode(.alwaysTemplate)
        self.imgShareToWeChat.tintColor = UIColor.gray
    }
}

// MARK: - TableView
extension CircleComposeViewController {
    
    func setupTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 104
            } else if indexPath.row == 1 {
                self.imagesCollectionView.setNeedsLayout()
                self.imagesCollectionView.layoutIfNeeded()
                return self.imagesCollectionView.contentSize.height + 22 // CollectionView Top/Bottom margins
            } else if indexPath.row == 2 {
                return 44
            }
        } else if indexPath.section == 1 {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
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
                cell.imageView.image = self.selectedAssets?[indexPath.row].fullResolutionImage
            } else {
                cell.imageView.contentMode = .center
                cell.imageView.image = UIImage(named: "img_plus_40")
                cell.imageView.layer.borderWidth = 1
                cell.imageView.layer.borderColor = UIColor.lightGray.cgColor
                cell.selectedBackgroundView = UIView()
                cell.selectedBackgroundView?.backgroundColor = UIColor(white: 0, alpha: 0.1)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Add button
        if indexPath.row == self.selectedAssets?.count ?? 0 {
            self.addPicture()
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

// MARK: Update Edited status and POST button
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

// MARK: Actions
extension CircleComposeViewController {
    
    @IBAction func quitEditing() {
        if !self.isEdited() {
            self.dismissSelf()
            return
        }
        let alertController = UIAlertController(title: nil,
                                                message: NSLocalizedString("circle_compose_quit_editing_title"),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("circle_compose_quit_editing_quit"),
                                                style: UIAlertActionStyle.default,
                                                handler: { (action: UIAlertAction) -> Void in
                                                    self.dismissSelf()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_cancel"),
                                                style: UIAlertActionStyle.cancel,
                                                handler: { (action: UIAlertAction) -> Void in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func post() {
        UserManager.shared.loginOrDo {
            MBProgressHUD.show(self.view)
            let encodedText = self.tvContent.text.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
            let images = self.selectedAssets?.flatMap() { $0.fullResolutionImage?.resizedImage(byMagick: "854x854") }
            let imageDatas = images?.flatMap() { UIImageJPEGRepresentation($0, 0.7) }
            DataManager.shared.createCicle(encodedText, imageDatas, CircleVisibility.everyone) { (responseObject, error) in
                MBProgressHUD.hide(self.view)
                self.delegate?.didPostNewCircle()
                self.dismiss(animated: true, completion: {
                    self.delegate?.didDismiss(text: self.tvContent.text, images: images, needsToShare: self.shareToWeChat.isOn)
                })
            }
        }
    }
}

// MARK: Reordering
private var oldIndexPathKey: UInt8 = 0
private var snapshotViewKey: UInt8 = 0
extension CircleComposeViewController {
    
    var oldIndexPath: NSIndexPath {
        get {
            return associatedObject(base: self, key: &oldIndexPathKey) {
                return NSIndexPath() // Set the initial value of the var
            }
        }
        set {
            associateObject(base: self, key: &oldIndexPathKey, value: newValue)
        }
    }
    
    var snapshotView: UIView {
        get {
            return associatedObject(base: self, key: &snapshotViewKey) {
                return UIView() // Set the initial value of the var
            }
        }
        set {
            associateObject(base: self, key: &snapshotViewKey, value: newValue)
        }
    }
    
    func setupDraggingGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(CircleComposeViewController.handleLongGesture(gesture:)))
        self.imagesCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            guard let indexPath = self.imagesCollectionView.indexPathForItem(at: gesture.location(in: self.imagesCollectionView)),
                let cell = self.imagesCollectionView.cellForItem(at: indexPath) else {
                break
            }
            if !self.collectionView(self.imagesCollectionView, canMoveItemAt: indexPath) {
                gesture.isEnabled = false
                gesture.isEnabled = true
                break
            }
            self.oldIndexPath = indexPath as NSIndexPath
            if let snapshotView = cell.snapshotView(afterScreenUpdates: false) {
                self.view.addSubview(snapshotView)
                self.snapshotView = snapshotView
                self.snapshotView.frame = cell.convert(cell.bounds, to: self.view)
                cell.isHidden = true
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.snapshotView.transform = cell.transform.scaledBy(x: 1.2, y: 1.2)
                self.snapshotView.center = gesture.location(in: self.view)
            })
        case .changed:
            self.snapshotView.center = gesture.location(in: self.view)
            for cell in self.imagesCollectionView.visibleCells {
                let oldIndexPath = self.oldIndexPath as IndexPath
                guard var cellIndexPath = self.imagesCollectionView.indexPath(for: cell) else {
                    break
                }
                cellIndexPath = self.collectionView(self.imagesCollectionView, targetIndexPathForMoveFromItemAt: oldIndexPath, toProposedIndexPath: cellIndexPath)
                if cellIndexPath == oldIndexPath {
                    continue
                }
                let snapshotViewCenter = self.imagesCollectionView.convert(self.snapshotView.center, from: self.view)
                let distance = sqrtf(pow(Float(snapshotViewCenter.x - cell.center.x), 2) + powf(Float(snapshotViewCenter.y - cell.center.y), 2))
                if distance <= Float(self.snapshotView.bounds.size.width / 2.0) {
                    let moveIndexPath = cellIndexPath
                    self.imagesCollectionView.moveItem(at: oldIndexPath, to: moveIndexPath)
                    self.collectionView(self.imagesCollectionView, moveItemAt: oldIndexPath, to: moveIndexPath)
                    self.oldIndexPath = moveIndexPath as NSIndexPath
                    break
                }
            }
        default:
            guard let cell = self.imagesCollectionView.cellForItem(at: self.oldIndexPath as IndexPath) else {
                break
            }
            self.imagesCollectionView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.snapshotView.center = self.imagesCollectionView.convert(cell.center, to: self.view)
                            self.snapshotView.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                self.snapshotView.removeFromSuperview()
                cell.isHidden = false
                self.imagesCollectionView.isUserInteractionEnabled = true
            })
        }
    }
}

extension CircleComposeViewController: TLPhotosPickerViewControllerDelegate {
    
    func addPicture() {
        PicturePickerViewController.pick9Photos(from: self,
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
