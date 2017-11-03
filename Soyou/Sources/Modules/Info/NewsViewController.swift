//
//  NewsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class NewsViewController: InfoListBaseViewController {
    
    override func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        let fetchedResultsController = News.mr_fetchAllGrouped(by: nil, with: FmtPredicate("appIsFavorite == false"), sortedBy: "datePublication:false,id:false", ascending: false)
        fetchedResultsController.fetchRequest.includesSubentities = false
        return fetchedResultsController
    }
    
    // Class methods
    override class func instantiate() -> NewsViewController {
        let instance = super.instantiate()
        object_setClass(instance, NewsViewController.self)
        return (instance as? NewsViewController)!
    }
    
    deinit {
        // Stop observing data updating
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Cons.DB.newsUpdatingDidFinishNotification), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("news_vc_title")
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        // Observe data updating
        NotificationCenter.default.addObserver(self, selector: #selector(NewsViewController.reloadDataWithoutCompletion), name: NSNotification.Name(rawValue: Cons.DB.newsUpdatingDidFinishNotification), object: nil)
    }
    
    // MARK: Data
    override func loadData(_ relativeID: NSNumber?) {
        DataManager.shared.requestNewsList(relativeID) { responseObject, error in
            guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
            guard let data = responseObject["data"] as? [NSDictionary] else { return }
            
            self.endRefreshing(data.count)
        }
    }
    
    override func loadNextData() {
        let lastNews = self.fetchedResultsController?.fetchedObjects?.last as? News
        self.loadData(lastNews?.id)
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
        if let news = self.fetchedResultsController?.object(at: indexPath) as? News,
            let imageURLString = news.image,
            let imageURL = URL(string: imageURLString) {
            let cacheKey = SDWebImageManager.shared().cacheKey(for: imageURL)
            let _image = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey)
            if let image = _image {
                return CGSize(width: image.size.width, height: image.size.height)
            }
        }
        return nil
    }
}


// MARK: - CollectionView Delegate Methods
extension NewsViewController {
    
    override func cellForItem(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        var returnValue: UICollectionViewCell?
        
        if let news = self.fetchedResultsController?.object(at: indexPath) as? News,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath) as? InfoCollectionViewCell {
            cell.lblTitle.text = news.title
            if let imageURLString = news.image,
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
            returnValue = cell
        }
        
        if returnValue == nil {
            // We can't return a cell without a reuse identifier
            returnValue = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath) as? InfoCollectionViewCell
        }
        
        return returnValue!
    }
    
    override func didSelectItemAtIndexPath(_ collectionView: UICollectionView, indexPath: IndexPath) {
        guard let news = self.fetchedResultsController?.object(at: indexPath) as? News else {
            return
        }
        
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) -> Void in
            guard let localNews = news.mr_(in: localContext) else { return }
            guard let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as? InfoCollectionViewCell else { return }
            
            // Prepare cover image
            var image: UIImage?
            if let imageURLString = localNews.image,
                let imageURL = URL(string: imageURLString) {
                let cacheKey = SDWebImageManager.shared().cacheKey(for: imageURL)
                image = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey)
            }
            
            if image == nil {
                image = cell.fgImageView.image
            }
            
            // Prepare view controller
            let detailViewController = NewsDetailViewController.instantiate()
            detailViewController.delegate = self
            detailViewController.info = localNews
            detailViewController.infoIndex = indexPath.row
            detailViewController.headerImage = image
            
            // Push view controller
            self.infoViewController?.navigationController?.pushViewController(detailViewController, animated: true)
        })
    }
}
