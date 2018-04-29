//
//  DiscountsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 24/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class DiscountsViewController: InfoListBaseViewController {
    
    override func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        let fetchedResultsController = Discount.mr_fetchAllGrouped(by: nil, with: FmtPredicate("appIsFavorite == false"), sortedBy: "publishdate:false,id:false", ascending: false)
        fetchedResultsController.fetchRequest.includesSubentities = false
        return fetchedResultsController
    }
    
    // Class methods
    override class func instantiate() -> DiscountsViewController {
        let instance = super.instantiate()
        object_setClass(instance, DiscountsViewController.self)
        return (instance as? DiscountsViewController)!
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("discouts_vc_title")
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        // Observe UIApplicationDidBecomeActive to update EXPIRED labels
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(DiscountsViewController.updateVisibleCells),
                                               name: Notification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update EXPIRED labels
        self.updateVisibleCells()
    }
    
    // MARK: Data
    override func loadData(_ relativeID: Int?) {
        self.beginRefreshing()
        DataManager.shared.requestDiscountsList(relativeID) { responseObject, error in
            if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                let data = responseObject["data"] as? [NSDictionary] {
                self.endRefreshing(data.count)
            } else {
                self.endRefreshing(0)
            }
        }
    }
    
    override func loadNextData() {
        let lastDiscount = self.fetchedResultsController?.fetchedObjects?.last as? Discount
        self.loadData(lastDiscount?.id as? Int)
    }
    
    override func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize? {
        if let discount = self.fetchedResultsController?.object(at: indexPath) as? Discount,
            let imageURLString = discount.coverImage,
            let imageURL = URL(string: imageURLString),
            let image = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: imageURL)) {
            return CGSize(width: image.size.width, height: image.size.height)
        }
        return nil
    }
}

// MARK: - CollectionView Delegate Methods
extension DiscountsViewController {
    
    override func cellForItem(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let discount = (self.fetchedResultsController?.object(at: indexPath) as? Discount)!
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath) as? InfoCollectionViewCell)!
        cell.lblTitle.text = discount.title
        if let imageURLString = discount.coverImage, let imageURL = URL(string: imageURLString) {
            cell.bgImageView.sd_setImage(with: imageURL,
                                         placeholderImage: UIImage(named: "img_placeholder_3_2_l"),
                                         options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                         completed: { (image, error, type, url) -> Void in
                                            // Update cell height based on the image width/height ratio
                                            if (image != nil &&
                                                !self.collectionView().isDragging &&
                                                !self.collectionView().isDecelerating &&
                                                self.collectionView().indexPathsForVisibleItems.contains(indexPath)) {
                                                self.collectionView().collectionViewLayout.invalidateLayout()
                                            }
            })
        }
        cell.fgCover.isHidden = (discount.expireDate?.timeIntervalSinceNow ?? 0) >= 0
        cell.lblExpired.text = NSLocalizedString("discouts_vc_expired")
        return cell
    }
    
    override func didSelectItemAtIndexPath(_ collectionView: UICollectionView, indexPath: IndexPath) {
        let discount = (self.fetchedResultsController?.object(at: indexPath) as? Discount)!
        
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) -> Void in
            guard let localDiscount = discount.mr_(in: localContext) else { return }
            let cell = (collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as? InfoCollectionViewCell)!
            
            // Prepare cover image
            var image: UIImage?
            if let imageURLString = localDiscount.coverImage,
                let imageURL = URL(string: imageURLString) {
                let cacheKey = SDWebImageManager.shared().cacheKey(for: imageURL)
                image = SDImageCache.shared().imageFromCache(forKey: cacheKey)
            }
            
            if image == nil {
                image = cell.bgImageView.image
            }
            
            // Prepare view controller
            let detailViewController = DiscountDetailViewController.instantiate()
            detailViewController.info = localDiscount
            detailViewController.headerImage = image
            
            // Push view controller
            self.infoViewController?.navigationController?.pushViewController(detailViewController, animated: true)
        })
    }
}

// MARK: - Discounts
extension DiscountsViewController {

    @objc func updateVisibleCells() {
        DispatchQueue.main.async {
            self.collectionView().reloadItems(at: self.collectionView().indexPathsForVisibleItems)
        }
    }
}
