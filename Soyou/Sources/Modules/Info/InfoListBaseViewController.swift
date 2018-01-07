//
//  InfoListBaseViewController.swift
//  Soyou
//
//  Created by CocoaBob on 01/06/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class InfoListBaseViewController: SyncedFetchedResultsViewController {
    
    // Used for getting the navigation controller
    var infoViewController: UIViewController?
    
    // Override AsyncedFetchedResultsViewController
    @IBOutlet var _collectionView: UICollectionView!
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    // Properties
    var selectedIndexPath: IndexPath?
    
    // Class methods
    class func instantiate() -> InfoListBaseViewController {
        return UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewController(withIdentifier: "InfoListBaseViewController") as! InfoListBaseViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), 0, false, false, false, true)
        
        // Setups
        self.setupCollectionView()
        self.setupRefreshControls()
        
        // Prepare FetchedResultsController
        self.reloadDataWithoutCompletion()
        // Load Data
        self.loadData(nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateColumnCount(Int(floor(size.width / 240)))
    }
    
    func didShowInfo(_ indexPath: IndexPath, isNext: Bool) {
        self.collectionView().scrollToItem(at: indexPath, at: .top, animated: false)
        self.selectedIndexPath = indexPath
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize? {
        return nil
    }
    
    // MARK: Data
    func loadData(_ relativeID: Int?) {
        
    }
    
    func loadNextData() {
        
    }
}

// MARK: - CollectionView Delegate Methods
extension InfoListBaseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    @objc func cellForItem(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath)
        return cell
    }
    
    @objc func didSelectItemAtIndexPath(_ collectionView: UICollectionView, indexPath: IndexPath) {

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.cellForItem(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.didSelectItemAtIndexPath(collectionView, indexPath: indexPath)
    }
}

// MARK: - UIScrollViewDelegate
extension InfoListBaseViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView().reloadItems(at: self.collectionView().indexPathsForVisibleItems)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView().reloadItems(at: self.collectionView().indexPathsForVisibleItems)
    }
}

// MARK: - CollectionView Waterfall Layout
extension InfoListBaseViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func setupCollectionView() {
        self.collectionView().indicatorStyle = .white
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.itemRenderDirection = .leftToRight
        layout.minimumColumnSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        updateColumnCount(Int(floor(self.view.frame.width / 568)))
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.collectionView().alwaysBounceVertical = true
    }
    
    func updateColumnCount(_ count: Int) {
        // Update column count
        (self.collectionView().collectionViewLayout as? CHTCollectionViewWaterfallLayout)?.columnCount = max(count, 1)
        
        // Update margins
        if let layout = self.collectionView().collectionViewLayout as? CHTCollectionViewWaterfallLayout {
//            if count > 1 {
//                layout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4)
//            } else {
            layout.sectionInset = UIEdgeInsets.zero
//            }
        }
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        var size = CGSize(width: 3, height: 2) // Default size
        
        if let newSize = self.sizeForItemAtIndexPath(indexPath) {
            size = newSize
        }
        
        return size
    }
}

// MARK: ZoomInteractiveTransition
extension InfoListBaseViewController {
    
    fileprivate func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            let cell = self.collectionView().cellForItem(at: indexPath) as? InfoCollectionViewCell {
            return cell.bgImageView
        }
        return nil
    }
    
    func view(forZoomTransition isSource: Bool) -> UIView? {
        return self.imageViewForZoomTransition()
    }
    
    func initialZoomViewSnapshot(fromProposedSnapshot snapshot: UIImageView!) -> UIImageView? {
        if let imageView = self.imageViewForZoomTransition() {
            let returnImageView = UIImageView(image: imageView.image)
            returnImageView.contentMode = imageView.contentMode
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransition(for operation: UINavigationControllerOperation, from fromVC: UIViewController!, to toVC: UIViewController!) -> Bool {
        // Only available for opening/closing an info from/to info base view controller
        if ((operation == .push && fromVC === self.infoViewController && toVC is InfoDetailBaseViewController) ||
            (operation == .pop && fromVC is InfoDetailBaseViewController && toVC === self.infoViewController)) {
            return true
        }
        return false
    }
}

// MARK: - Refreshing
extension InfoListBaseViewController {
    
    func setupRefreshControls() {
        guard let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData(nil)
            self.beginRefreshing()
        }) else { return }
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle"), for: .idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling"), for: .pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing"), for: .refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        header.lastUpdatedTimeLabel?.isHidden = true
        self.collectionView().mj_header = header
        
        guard let footer = MJRefreshAutoStateFooter(refreshingBlock: { () -> Void in
            self.loadNextData()
        }) else { return }
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), for: .idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), for: .pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), for: .refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        self.collectionView().mj_footer = footer
    }
    
    func beginRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endRefreshing(_ resultCount: Int) {
        DispatchQueue.main.async {
            self.collectionView().mj_header.endRefreshing()
            if resultCount > 0 {
                self.collectionView().mj_footer.endRefreshing()
            } else {
                self.collectionView().mj_footer.endRefreshingWithNoMoreData()
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: - Custom cells

class InfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var fgCover: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblExpired: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        
        self.lblTitle.clipsToBounds = true
        self.lblTitle.layer.shadowRadius = 1
        self.lblTitle.layer.shadowColor = UIColor.black.cgColor
        self.lblTitle.layer.shadowOpacity = 1
        self.lblTitle.layer.shadowOffset = CGSize.zero
    }
    
    override func prepareForReuse() {
        lblTitle.text = nil
        fgCover.isHidden = true
    }
}
