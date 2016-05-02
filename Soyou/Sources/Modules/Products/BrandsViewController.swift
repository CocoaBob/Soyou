//
//  BrandsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class BrandsViewController: FetchedResultsViewController {
    
    // Override FetchedResultsViewController
    @IBOutlet var _collectionView: UICollectionView!
    
    private var checkLoadingTimer: NSTimer? // If DataManager is updating data, check if brands data is ready
    @IBOutlet private var _feedbackButton: UIButton!
    @IBOutlet private var _reloadButton: UIButton!
    @IBOutlet private var _loadingLabel: UILabel!
    @IBOutlet private var _loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var _loadingView: UIView!
    var isLoadingViewVisible: Bool = true {
        didSet {
            if self.isLoadingViewVisible {
                self._loadingView.alpha = 1
                self._loadingView.hidden = false
            } else {
                UIView.animateWithDuration(0.3, animations: {
                    self._loadingView.alpha = 0
                }) { (finished) in
                    self._loadingView.hidden = true
                }
            }
        }
    }
    
    var searchController: UISearchController?
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    override func createFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest? {
        return Brand.MR_requestAllSortedBy(
            "order",
            ascending: true,
            withPredicate: nil,
            inContext: context)
    }
    
    // Properties
    var transition: ZoomInteractiveTransition?
    
    var selectedIndexPath: NSIndexPath?
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = false
        
        // UIViewController
        self.title = NSLocalizedString("brands_vc_title")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("brands_vc_tab_title"), image: UIImage(named: "img_tab_tag"), selectedImage: UIImage(named: "img_tab_tag_selected"))
    }
    
    deinit {
        // Stop observing data updating
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Cons.DB.brandsUpdatingDidFinishNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To let ProductsViewController's viewWillAppear()/viewDidAppear() be called
        self.navigationController?.delegate = self
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), 0, true, true, false, true)
        
        // Setups
        self.setupCollectionView()
        
        // Setup Search Controller
        self.setupSearchController()
        
        // Observe data updating
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BrandsViewController.reloadDataWithoutCompletion), name: Cons.DB.brandsUpdatingDidFinishNotification, object: nil)
        
        // Load data
        self.showLoadingIndicator()
        self.reloadData(nil)
        
        // Transitions
        self.transition = ZoomInteractiveTransition(navigationController: self.navigationController)
        self.transition?.handleEdgePanBackGesture = false
        self.transition?.transitionDuration = 0.3
        let animationOpts: UIViewAnimationOptions = .CurveEaseOut
        let keyFrameOpts: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOpts.rawValue)
        self.transition?.transitionAnimationOption = [UIViewKeyframeAnimationOptions.CalculationModeCubic, keyFrameOpts]
        
        // Report problem button
        self._feedbackButton.setTitle(NSLocalizedString("brands_vc_beedback"), forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        // Hide toolbar. No animation because it might need to be shown immediately
        self.hideToolbar(false)
        // For navigation bar search bar
        self.definesPresentationContext = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = false
    }
}

// MARK: - CollectionView Delegate Methods
extension BrandsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (self.fetchedResults != nil) ? 1 : 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResults?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("BrandsCollectionViewCell", forIndexPath: indexPath) as? BrandsCollectionViewCell)!
        
        if let brand = self.fetchedResults?[indexPath.row] as? Brand {
            
            if let label = brand.label {
                cell.lblTitle?.text = label
            }
            
            if let imageURLString = brand.imageUrl, let imageURL = NSURL(string: imageURLString) {
                cell.fgImageView?.sd_setImageWithURL(imageURL,
                    placeholderImage: UIImage(named: "img_placeholder_3_2_m"),
                    options: [.ContinueInBackground, .AllowInvalidSSLCertificates, .DelayPlaceholder])
            }
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        
        guard let brand = self.fetchedResults?[indexPath.row] as? Brand else {
            return
        }
        
        let brandViewController = BrandViewController.instantiate()
        
        // Prepare attributes
        var imageURLString: String? = nil
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            guard let localBrand = brand.MR_inContext(localContext) else { return }
            brandViewController.brandID = localBrand.id
            brandViewController.brandName = localBrand.label
            brandViewController.brandCategories = localBrand.categories as? [NSDictionary]
            imageURLString = localBrand.imageUrl
        })
        
        // Load brand image
        var image: UIImage?
        if let imageURLString = imageURLString, let imageURL = NSURL(string: imageURLString) {
            brandViewController.brandImageURL = imageURL
            
            let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
            image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
        }
        if image == nil {
            if let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? BrandsCollectionViewCell {
                image = cell.fgImageView.image
            }
        }
        brandViewController.brandImage = image
        
        // Push view
        self.navigationController?.pushViewController(brandViewController, animated: true)
    }
}

//MARK: - CollectionView Waterfall Layout
extension BrandsViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func setupCollectionView() {
        self.collectionView().indicatorStyle = .White

        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.itemRenderDirection = .LeftToRight
        layout.minimumColumnSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0)
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        (self.collectionView().collectionViewLayout as? CHTCollectionViewWaterfallLayout)?.columnCount = 2
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
        
        // Load data
        self.collectionView().reloadData()
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSize(width: 3, height: 2)
    }
}

// MARK: ZoomInteractiveTransition
extension BrandsViewController: ZoomTransitionProtocol {
    
    private func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? BrandsCollectionViewCell,
            imageView = cell.fgImageView {
                return imageView
        }
        return nil
    }
    
    func viewForZoomTransition(isSource: Bool) -> UIView? {
        return self.imageViewForZoomTransition()
    }
    
    func initialZoomViewSnapshotFromProposedSnapshot(snapshot: UIImageView!) -> UIImageView? {
        if let imageView = self.imageViewForZoomTransition() {
            let returnImageView = UIImageView(image: imageView.image)
            returnImageView.contentMode = imageView.contentMode
            returnImageView.clipsToBounds = imageView.clipsToBounds
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        if ((operation == .Push && fromVC === self && toVC is BrandViewController) ||
            (operation == .Pop && fromVC is BrandViewController && toVC === self)) {
            return true
        }
        return false
    }
}

// MARK: FetchedResultsController
extension BrandsViewController {
    
    override func reloadData(completion: ((Int) -> Void)?) {
        // Reload Data
        super.reloadData() { resultCount in
            // Original completion
            if let completion = completion { completion(resultCount) }
            
            // After searching is completed, if there are results, hide the indicator
            if self.fetchedResults?.count ?? 0 > 0 {
                self.isLoadingViewVisible = false
                self.endCheckIsLoadingTimer()
            } else {
                self.isLoadingViewVisible = true
                self.checkIsLoading()
                self.beginCheckIsLoadingTimer()
            }
        }
    }
}

// MARK: - SearchControler
extension BrandsViewController: UISearchControllerDelegate {
    
    func setupSearchController() {
        let searchResultsController = ProductsViewController.instantiate()
        searchResultsController.isSearchResultsViewController = true
        searchResultsController.searchFromViewController = self
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController!.searchResultsUpdater = searchResultsController
        self.searchController!.searchBar.delegate = searchResultsController
        self.searchController!.searchBar.placeholder = NSLocalizedString("brands_vc_search_bar_placeholder")
        self.searchController!.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = self.searchController!.searchBar
    }
}

// MARK: - UINavigationControllerDelegate
extension BrandsViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        viewController.viewWillAppear(animated)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        viewController.viewDidAppear(animated)
    }
}

// MARK: Updating data
extension BrandsViewController {
    
    private func beginCheckIsLoadingTimer() {
        self.endCheckIsLoadingTimer()
        self.checkLoadingTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(BrandsViewController.checkIsLoading), userInfo: nil, repeats: true)
    }
    
    private func endCheckIsLoadingTimer() {
        if self.checkLoadingTimer != nil {
            self.checkLoadingTimer?.invalidate()
            self.checkLoadingTimer = nil
        }
    }
    
    func checkIsLoading() {
        if DataManager.shared.isUpdatingData {
            self.showLoadingIndicator()
        } else {
            self.endCheckIsLoadingTimer()
            self.showReloadButton()
        }
    }
    
    private func showLoadingIndicator() {
        self._reloadButton.hidden = true
        self._loadingIndicator.hidden = false
        self._loadingIndicator.startAnimating()
        self._loadingLabel.text = NSLocalizedString("brands_vc_no_data_label_loading")
    }
    
    private func showReloadButton() {
        self._reloadButton.hidden = false
        self._loadingIndicator.hidden = true
        self._loadingIndicator.stopAnimating()
        self._loadingLabel.text = NSLocalizedString("brands_vc_no_data_label_reload")
    }
    
    @IBAction func updateData() {
        DataManager.shared.requestAllBrands { (_, error) in
            if error == nil {
                DataManager.shared.updateData(nil)
            }
            self.reloadData(nil)
        }
        self.checkIsLoading()
        self.beginCheckIsLoadingTimer()
    }
}

// MARK: Send feedback
extension BrandsViewController {
    
    @IBAction func feedback() {
        Utils.shared.sendDiagnosticReport(self)
    }
}

// MARK: - Custom cells
class BrandsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblTitle: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        
        self.lblTitle?.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        lblTitle?.text = nil
    }
}
