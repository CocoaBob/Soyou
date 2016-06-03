//
//  DiscountsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 24/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class DiscountsViewController: InfoListBaseViewController {
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return Discount.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "publishdate:false,id:false", ascending: false)
    }
    
    // Class methods
    override class func instantiate() -> DiscountsViewController {
        let instance = super.instantiate()
        object_setClass(instance, DiscountsViewController.self)
        return (instance as? DiscountsViewController)!
    }
    
    deinit {
        // Stop observing data updating
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Cons.DB.discountsUpdatingDidFinishNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("discouts_vc_title")
        self.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        
        // Observe data updating
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DiscountsViewController.reloadDataWithoutCompletion), name: Cons.DB.discountsUpdatingDidFinishNotification, object: nil)
    }
    
    // MARK: Data
    override func loadData(relativeID: NSNumber?) {
        DataManager.shared.requestDiscountsList(relativeID) { responseObject, error in
            self.endRefreshing()
            self.resetMoreButtonCell()
        }
    }
    
    // MARK: SwitchPrevNextItemDelegate
    override func hasNextInfo(indexPath: NSIndexPath, isNext: Bool) -> Bool {
        return self.fetchedResultsController?.fetchedObjects?.isEmpty == false
    }
    
    override func getNextInfo(indexPath: NSIndexPath, isNext: Bool, completion: ((indexPath: NSIndexPath?, item: Any?)->())?) {
        guard let completion = completion else { return }
        
        guard let fetchedResults = self.fetchedResultsController?.fetchedObjects else { return
            completion(indexPath: nil, item: nil)
        }
        
        var newIndex = indexPath.row + (isNext ? 1 : -1)
        if newIndex < 0 {
            newIndex = fetchedResults.count - 1
        }
        if newIndex > fetchedResults.count - 1 {
            newIndex = 0
        }
        
        completion(indexPath: NSIndexPath(forRow: newIndex, inSection: 0), item: fetchedResults[newIndex])
    }
}


// MARK: - CollectionView Delegate Methods
extension DiscountsViewController {
    
    override func cellForItemAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let discount = (self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Discount)!
        
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("InfoCollectionViewCell", forIndexPath: indexPath) as? InfoCollectionViewCell)!
        cell.lblTitle.text = discount.title
        if let imageURLString = discount.coverImage,
            imageURL = NSURL(string: imageURLString) {
            cell.fgImageView.sd_setImageWithURL(imageURL,
                                                placeholderImage: UIImage(named: "img_placeholder_3_2_l"),
                                                options: [.ContinueInBackground, .AllowInvalidSSLCertificates, .HighPriority],
                                                completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                                                    if (image != nil &&
                                                        !self.collectionView().dragging &&
                                                        !self.collectionView().decelerating &&
                                                        self.collectionView().indexPathsForVisibleItems().contains(indexPath)) {
                                                        self.collectionView().reloadItemsAtIndexPaths([indexPath])
                                                    }
            })
        }
        
        return cell
    }
    
    override func didSelectItemAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {
        let discount = (self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Discount)!
        
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            guard let localDiscount = discount.MR_inContext(localContext) else { return }
            let cell = (collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? InfoCollectionViewCell)!
            
            // Prepare cover image
            var image: UIImage?
            if let imageURLString = localDiscount.coverImage,
                imageURL = NSURL(string: imageURLString) {
                let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
                image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
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
        }
    }
}
