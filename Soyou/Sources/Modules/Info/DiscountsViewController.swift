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
        // Stop observing data updating
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Cons.DB.discountsUpdatingDidFinishNotification), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("discouts_vc_title")
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        // Observe data updating
        NotificationCenter.default.addObserver(self, selector: #selector(DiscountsViewController.reloadDataWithoutCompletion), name: NSNotification.Name(rawValue: Cons.DB.discountsUpdatingDidFinishNotification), object: nil)
    }
    
    // MARK: Data
    override func loadData(_ relativeID: NSNumber?) {
        DataManager.shared.requestDiscountsList(relativeID) { responseObject, error in
            guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
            guard let data = responseObject["data"] as? [NSDictionary] else { return }
            
            self.endRefreshing(data.count)
        }
    }
    
    override func loadNextData() {
        let lastDiscount = self.fetchedResultsController?.fetchedObjects?.last as? Discount
        self.loadData(lastDiscount?.id)
        self.beginRefreshing()
    }
    
    // MARK: SwitchPrevNextItemDelegate
    override func hasNextInfo(_ indexPath: IndexPath, isNext: Bool) -> Bool {
        return self.fetchedResultsController?.fetchedObjects?.count ?? 0 > 1
    }
    
    override func getNextInfo(_ indexPath: IndexPath, isNext: Bool, completion: ((_ indexPath: IndexPath?, _ item: Any?)->())?) {
        guard let completion = completion else { return }
        
        guard let fetchedResults = self.fetchedResultsController?.fetchedObjects else { return
            completion(nil, nil)
        }
        
        var newIndex = indexPath.row + (isNext ? 1 : -1)
        if newIndex < 0 {
            newIndex = fetchedResults.count - 1
        }
        if newIndex > fetchedResults.count - 1 {
            newIndex = 0
        }
        
        completion(IndexPath(row: newIndex, section: 0), fetchedResults[newIndex])
    }
    
    override func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize? {
        if let discount = self.fetchedResultsController?.object(at: indexPath) as? Discount,
            let imageURLString = discount.coverImage,
            let imageURL = URL(string: imageURLString) {
            let cacheKey = SDWebImageManager.shared().cacheKey(for: imageURL)
            if let image = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey) {
                return CGSize(width: image.size.width, height: image.size.height)
            }
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
        if let imageURLString = discount.coverImage,
            let imageURL = URL(string: imageURLString) {
            cell.fgImageView.sd_setImage(with: imageURL,
                                         placeholderImage: UIImage(named: "img_placeholder_3_2_l"),
                                         options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                         completed: { (image, error, type, url) -> Void in
                                            if (image != nil &&
                                                !self.collectionView().isDragging &&
                                                !self.collectionView().isDecelerating &&
                                                self.collectionView().indexPathsForVisibleItems.contains(indexPath)) {
                                                self.collectionView().reloadItems(at: [indexPath])
                                            }
            })
        }
        
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
                image = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey)
            }
            
            if image == nil {
                image = cell.fgImageView.image
            }
            
            // Prepare view controller
            let detailViewController = DiscountDetailViewController.instantiate()
            detailViewController.delegate = self
            detailViewController.info = localDiscount
            detailViewController.infoIndex = indexPath.row
            detailViewController.headerImage = image
            
            // Push view controller
            self.infoViewController?.navigationController?.pushViewController(detailViewController, animated: true)
        })
    }
}
