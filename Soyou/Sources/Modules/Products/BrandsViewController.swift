//
//  BrandsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class BrandsViewController: AsyncedFetchedResultsViewController {
    
    // Override AsyncedFetchedResultsViewController
    @IBOutlet var _collectionView: UICollectionView!
    @IBOutlet var _tableView: UITableView!
    
    var isListMode: Bool = false
    
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
    
    override func collectionView() -> UICollectionView? {
        return isListMode ? nil : _collectionView
    }
    
    override func tableView() -> UITableView? {
        return isListMode ? _tableView : nil
    }
    
    override func createFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest? {
        return Brand.MR_requestAllSortedBy(
            "order,id",
            ascending: true,
            withPredicate: isListMode ? nil : FmtPredicate("isHot == true"),
            inContext: context)
    }
    
    // Properties
    var transition: ZoomInteractiveTransition?
    
    var selectedIndexPath: NSIndexPath?
    
    // Class methods
    class func instantiate() -> BrandsViewController {
        return (UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("BrandsViewController") as? BrandsViewController)!
    }
    
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
        
        if isListMode {
            _collectionView.dataSource = nil
            _collectionView.delegate = nil
            _collectionView.removeFromSuperview()
            
            _tableView.hidden = false
            _tableView.dataSource = self
            _tableView.delegate = self
            
            // Fix scroll view insets
            self.updateScrollViewInset(_tableView, 0, true, true, false, true)
        } else {
            _tableView.dataSource = nil
            _tableView.delegate = nil
            _tableView.removeFromSuperview()
            
            _collectionView.hidden = false
            _collectionView.dataSource = self
            _collectionView.delegate = self
            
            // Fix scroll view insets
            self.updateScrollViewInset(_collectionView, 0, true, true, false, true)
            
            // Setups
            self.setupCollectionView()
        }
        
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
extension BrandsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (self.fetchedResults != nil) ? 1 : 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResults?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("BrandsCollectionViewCell", forIndexPath: indexPath) as? BrandsCollectionViewCell)!
        
        let brand = (self.fetchedResults?[indexPath.row] as? Brand)!
            
        if let label = brand.label {
            cell.lblTitle.text = label
        }
        
        if let imageURLString = brand.imageUrl,
            imageURL = NSURL(string: imageURLString) {
            cell.fgImageView?.sd_setImageWithURL(imageURL,
                                                 placeholderImage: UIImage(named: "img_placeholder_3_2_m"),
                                                 options: [.ContinueInBackground, .AllowInvalidSSLCertificates, .DelayPlaceholder])
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "MoreCollectionReusableView", forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        
        let brand = (self.fetchedResults?[indexPath.row] as? Brand)!
        
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
        if let imageURLString = imageURLString,
            imageURL = NSURL(string: imageURLString) {
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

// MARK: - 
extension BrandsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.fetchedResults != nil) ? 1 : 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResults?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let brand = (self.fetchedResults?[indexPath.row] as? Brand)!
        let cell = (tableView.dequeueReusableCellWithIdentifier("BrandsTableViewCell", forIndexPath: indexPath) as? BrandsTableViewCell)!
        
        cell.lblTitle.text = brand.label
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let brand = (self.fetchedResults?[indexPath.row] as? Brand)!
        
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
        if let imageURLString = imageURLString,
            imageURL = NSURL(string: imageURLString) {
            brandViewController.brandImageURL = imageURL
            
            let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
            image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
        }
        brandViewController.brandImage = image
        
        // Push view
        self.navigationController?.pushViewController(brandViewController, animated: true)
    }
}

//MARK: - CollectionView Waterfall Layout
extension BrandsViewController {//: CHTCollectionViewDelegateWaterfallLayout {
    
    func setupCollectionView() {
        _collectionView.indicatorStyle = .White

        // Create a waterfall layout
        let layout = UICollectionViewFlowLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        
        // Header view / Footer view
        layout.headerReferenceSize = CGSize(width: 0, height: 44.0)
        
        if #available(iOS 9.0, *) {
            layout.sectionHeadersPinToVisibleBounds = true
        } else {
            // Fallback on earlier versions
        }
        
        // Add the waterfall layout to your collection view
        _collectionView.collectionViewLayout = layout
        
        // Collection view attributes
        _collectionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        _collectionView.alwaysBounceVertical = true
        
        // Load data
        _collectionView.reloadData()
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let width = (collectionView.bounds.width - 3) / 2
        return CGSize(width: width, height: width * 2 / 3)
    }
}

// MARK: ZoomInteractiveTransition
extension BrandsViewController: ZoomTransitionProtocol {
    
    private func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            cell = _collectionView.cellForItemAtIndexPath(indexPath) as? BrandsCollectionViewCell,
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
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(BrandViewController.showSearchController))
    }
    
    func showSearchController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setRightBarButtonItem(nil, animated: false)
        self.navigationItem.titleView = self.searchController!.searchBar
        self.searchController!.searchBar.becomeFirstResponder()
    }
    
    func hideSearchController() {
        self.setupRightBarButtonItem()
        self.navigationItem.titleView = nil
    }
    
    func setupSearchController() {
        let searchResultsController = ProductsViewController.instantiate()
        searchResultsController.isSearchResultsViewController = true
        searchResultsController.searchFromViewController = self
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController!.delegate = self
        self.searchController!.searchResultsUpdater = searchResultsController
        self.searchController!.searchBar.delegate = searchResultsController
        self.searchController!.searchBar.placeholder = NSLocalizedString("brands_vc_search_bar_placeholder")
        self.searchController!.hidesNavigationBarDuringPresentation = false
        
        if isListMode {
            self.setupRightBarButtonItem()
        } else {
            self.navigationItem.titleView = self.searchController!.searchBar
        }
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.hideSearchController()
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

// MARK: Show All Brands
extension BrandsViewController {
    
    @IBAction func showAllBrands() {
        let brandsViewController = BrandsViewController.instantiate()
        brandsViewController.isListMode = true
        let _ = brandsViewController.view
        self.navigationController?.pushViewController(brandsViewController, animated: true)
    }
}

// MARK: - Custom cells
class BrandsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        
        self.lblTitle.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        lblTitle.text = nil
    }
}

class MoreCollectionReusableView: UICollectionReusableView {
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        lblTitle.text = NSLocalizedString("brands_vc_all_brands")
    }
}


class BrandsTableViewCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        
        self.lblTitle.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        lblTitle.text = nil
    }
}
