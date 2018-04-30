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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("news_vc_title")
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
    }
    
    // MARK: Data
    override func loadData(_ relativeID: Int?) {
        self.beginRefreshing()
        DataManager.shared.requestNewsList(relativeID) { responseObject, error in
            if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                let data = responseObject["data"] as? [NSDictionary] {
                self.endRefreshing(data.count)
            } else {
                self.endRefreshing(0)
            }
        }
    }
    
    override func loadNextData() {
        let lastNews = self.fetchedResultsController?.fetchedObjects?.last as? News
        self.loadData(lastNews?.id as? Int)
    }
    
    override func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize? {
        if let news = self.fetchedResultsController?.object(at: indexPath) as? News,
            let imageURLString = news.image,
            let imageURL = URL(string: imageURLString),
            let image = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: imageURL)) {
            return CGSize(width: image.size.width, height: image.size.height)
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
            if let expireDate = news.expireDate {
                if expireDate.timeIntervalSinceNow > 0 {
                    cell.deadlineOverlay.isHidden = false
                    let dateString = DateFormatter.localizedString(from: expireDate, dateStyle: .short, timeStyle: .short)
                    cell.lblDeadline.text = FmtString(NSLocalizedString("news_vc_deadline"), dateString)
                } else {
                    cell.expireOverlay.isHidden = false
                    cell.lblExpired.text = NSLocalizedString("discouts_vc_expired")
                }
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
                image = SDImageCache.shared().imageFromCache(forKey: cacheKey)
            }
            
            if image == nil {
                image = cell.bgImageView.image
            }
            
            // Prepare view controller
            let detailViewController = NewsDetailViewController.instantiate()
            detailViewController.info = localNews
            detailViewController.headerImage = image
            
            // Push view controller
            self.infoViewController?.navigationController?.pushViewController(detailViewController, animated: true)
        })
    }
}
