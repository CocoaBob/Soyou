//
//  NewsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class NewsViewController: InfoListBaseViewController {
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return News.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication:false,id:false,appIsMore:true", ascending: false)
    }
    
    // Class methods
    override class func instantiate() -> NewsViewController {
        let instance = super.instantiate()
        object_setClass(instance, NewsViewController.self)
        return (instance as? NewsViewController)!
    }
    
    deinit {
        // Stop observing data updating
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Cons.DB.newsUpdatingDidFinishNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("news_vc_title")
        self.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        
        // Observe data updating
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsViewController.reloadDataWithoutCompletion), name: Cons.DB.newsUpdatingDidFinishNotification, object: nil)
    }
    
    // MARK: Data
    override func loadData(relativeID: NSNumber?) {
        DataManager.shared.requestNewsList(relativeID) { responseObject, error in
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
extension NewsViewController {
    
    override func cellForItemAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        var returnValue: UICollectionViewCell?
        
        if let news = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? News {
            if news.appIsMore != nil && news.appIsMore!.boolValue {
                if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InfoCollectionViewCellMore", forIndexPath: indexPath) as? InfoCollectionViewCellMore {
                    cell.indicator.hidden = true
                    cell.moreImage.hidden = false
                    returnValue = cell
                }
            } else {
                if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InfoCollectionViewCell", forIndexPath: indexPath) as? InfoCollectionViewCell {
                    cell.lblTitle.text = news.title
                    if let imageURLString = news.image,
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
                    returnValue = cell
                }
            }
        }
        
        if returnValue == nil {
            // We can't return a cell without a reuse identifier
            returnValue = collectionView.dequeueReusableCellWithReuseIdentifier("InfoCollectionViewCell", forIndexPath: indexPath) as? InfoCollectionViewCell
        }
        
        return returnValue!
    }
    
    override func didSelectItemAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {
        guard let news = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? News else {
            return
        }
        
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            guard let localNews = news.MR_inContext(localContext) else { return }
            let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            if localNews.appIsMore != nil && localNews.appIsMore!.boolValue {
                guard let cell = cell as? InfoCollectionViewCellMore else { return }
                
                self.selectedMoreButtonCell = cell
                
                cell.indicator.startAnimating()
                cell.indicator.hidden = false
                cell.moreImage.hidden = true
                self.loadData(localNews.id)
            } else {
                guard let cell = cell as? InfoCollectionViewCell else { return }
                
                // Prepare cover image
                var image: UIImage?
                if let imageURLString = localNews.image,
                    imageURL = NSURL(string: imageURLString) {
                    let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
                    image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
                }
                
                if image == nil {
                    image = cell.fgImageView.image
                }
                
                // Prepare view controller
                let newsDetailViewController = NewsDetailViewController.instantiate()
                newsDetailViewController.delegate = self
                newsDetailViewController.info = localNews
                newsDetailViewController.infoIndex = indexPath.row
                newsDetailViewController.headerImage = image
                
                // Push view controller
                self.infoViewController?.navigationController?.pushViewController(newsDetailViewController, animated: true)
            }
        }
    }
}
