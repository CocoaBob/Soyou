//
//  BrandsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class BrandsViewController: SyncedFetchedResultsViewController {
    
    // Override SyncedFetchedResultsViewController
    @IBOutlet var _collectionView: UICollectionView!
    @IBOutlet var _tableView: UITableView!
    
    var isListMode: Bool = false
    
    fileprivate var checkLoadingTimer: Timer? // If DataManager is updating data, check if brands data is ready
    @IBOutlet fileprivate var _feedbackButton: UIButton!
    @IBOutlet fileprivate var _reloadButton: UIButton!
    @IBOutlet fileprivate var _loadingLabel: UILabel!
    @IBOutlet fileprivate var _loadingIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate var _loadingView: UIView!
    var isLoadingViewVisible: Bool = true {
        didSet {
            if self.isLoadingViewVisible {
                self._loadingView.alpha = 1
                self._loadingView.isHidden = false
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self._loadingView.alpha = 0
                }) { (finished) in
                    self._loadingView.isHidden = true
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
    
    override func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        return Brand.mr_fetchAllGrouped(by: isListMode ? "brandIndex" : nil,
                                        with: isListMode ? nil : FmtPredicate("isHot == true"),
                                        sortedBy: isListMode ? "brandIndex,order,id" : "order,id",
                                        ascending: true)
    }
    
    // Properties
    var transition: ZoomInteractiveTransition?
    
    var selectedIndexPath: IndexPath?
    
    // Class methods
    class func instantiate() -> BrandsViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewController(withIdentifier: "BrandsViewController") as! BrandsViewController
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = false
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("brands_vc_tab_title"),
                                       image: UIImage(named: "img_tab_tag"),
                                       selectedImage: UIImage(named: "img_tab_tag_selected"))
    }
    
    deinit {
        // Stop observing data updating
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Cons.DB.brandsUpdatingDidFinishNotification), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIViewController
        self.title = NSLocalizedString("brands_vc_title")
        
        // To let ProductsViewController's viewWillAppear()/viewDidAppear() be called
        self.navigationController?.delegate = self
        
        // Setup Search Controller
        self.setupSearchController()
        
        if isListMode {
            _collectionView.dataSource = nil
            _collectionView.delegate = nil
            _collectionView.removeFromSuperview()
            
            _tableView.isHidden = false
            _tableView.dataSource = self
            _tableView.delegate = self
            
            // Fix scroll view insets
            self.updateScrollViewInset(_tableView, 0, true, true, false, true)
            
            // Setups
            self.setupTableView()
        } else {
            _tableView.dataSource = nil
            _tableView.delegate = nil
            _tableView.removeFromSuperview()
            
            _collectionView.isHidden = false
            _collectionView.dataSource = self
            _collectionView.delegate = self
            
            // Fix scroll view insets
            self.updateScrollViewInset(_collectionView, 0, true, true, false, true)
            
            // Setups
            self.setupCollectionView()
        }
        
        // Observe data updating
        NotificationCenter.default.addObserver(self, selector: #selector(BrandsViewController.reloadDataWithoutCompletion), name: NSNotification.Name(rawValue: Cons.DB.brandsUpdatingDidFinishNotification), object: nil)
        
        // Load data
        self.showLoadingIndicator()
        self.reloadData(nil)
        
        // Transitions
        self.transition = ZoomInteractiveTransition(navigationController: self.navigationController)
        self.transition?.handleEdgePanBackGesture = false
        self.transition?.transitionDuration = 0.3
        let animationOpts: UIViewAnimationOptions = .curveEaseOut
        let keyFrameOpts: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOpts.rawValue)
        self.transition?.transitionAnimationOption = [UIViewKeyframeAnimationOptions.calculationModeCubic, keyFrameOpts]
        
        // Report problem button
        self._feedbackButton.setTitle(NSLocalizedString("brands_vc_beedback"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        // Hide toolbar. No animation because it might need to be shown immediately
        self.hideToolbar(false)
        // For navigation bar search bar
        self.definesPresentationContext = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = false
    }
    
    override func reloadData(_ completion: (() -> Void)?) {
        // Reload Data
        super.reloadData {
            // Original completion
            completion?()
            
            // After searching is completed, if there are results, hide the indicator
            if self.fetchedResultsController?.fetchedObjects?.count ?? 0 > 0 {
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BrandsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath as IndexPath) as? BrandsCollectionViewCell)!
        
        let brand = self.brandAtIndexPath(indexPath as IndexPath)!
            
        if let label = brand.label {
            cell.lblTitle.text = label
        }
        
        if let imageURLString = brand.imageUrl,
            let imageURL = URL(string: imageURLString) {
            cell.fgImageView?.sd_setImage(with: imageURL,
                                          placeholderImage: UIImage(named: "img_placeholder_3_2_m"),
                                          options: [.continueInBackground, .allowInvalidSSLCertificates],
                                          completed: { (image, error, type, url) -> Void in
                                            // Update the image with an animation
                                            if (collectionView.indexPathsForVisibleItems.contains(indexPath)) {
                                                if let image = image {
                                                    UIView.transition(with: cell.fgImageView,
                                                                      duration: 0.3,
                                                                      options: UIViewAnimationOptions.transitionCrossDissolve,
                                                                      animations: { cell.fgImageView.image = image },
                                                                      completion: nil)
                                                }
                                            }
            })
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MoreCollectionReusableView", for: indexPath as IndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        
        let brand = self.brandAtIndexPath(indexPath)!
        
        let brandViewController = BrandViewController.instantiate()
        
        // Prepare attributes
        var imageURLString: String? = nil
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) -> Void in
            guard let localBrand = brand.mr_(in: localContext) else { return }
            brandViewController.brandID = localBrand.id as! Int
            brandViewController.brandName = localBrand.label
            brandViewController.brandCategories = localBrand.categories as? [NSDictionary]
            imageURLString = localBrand.imageUrl
        })
        
        // Load brand image
        var image: UIImage?
        if let imageURLString = imageURLString,
            let imageURL = URL(string: imageURLString) {
            brandViewController.brandImageURL = imageURL
            
            let cacheKey = SDWebImageManager.shared().cacheKey(for: imageURL as URL!)
            image = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey)
        }
        if image == nil {
            if let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath as IndexPath) as? BrandsCollectionViewCell {
                image = cell.fgImageView.image
            }
        }
        brandViewController.brandImage = image
        
        // Push view
        self.navigationController?.pushViewController(brandViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BrandsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let brand = self.brandAtIndexPath(indexPath as IndexPath)!
        let cell = (tableView.dequeueReusableCell(withIdentifier: "BrandsTableViewCell", for: indexPath as IndexPath) as? BrandsTableViewCell)!
        
        cell.lblTitle.text = brand.label ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let brand = self.brandAtIndexPath(indexPath)!
        
        let brandViewController = BrandViewController.instantiate()
        
        // Prepare attributes
        var imageURLString: String? = nil
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) -> Void in
            guard let localBrand = brand.mr_(in: localContext) else { return }
            brandViewController.brandID = localBrand.id as! Int
            brandViewController.brandName = localBrand.label
            brandViewController.brandCategories = localBrand.categories as? [NSDictionary]
            imageURLString = localBrand.imageUrl
        })
        
        // Load brand image
        var image: UIImage?
        if let imageURLString = imageURLString,
            let imageURL = URL(string: imageURLString) {
            brandViewController.brandImageURL = imageURL
            
            let cacheKey = SDWebImageManager.shared().cacheKey(for: imageURL as URL!)
            image = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey)
        }
        brandViewController.brandImage = image
        
        // Push view
        self.navigationController?.pushViewController(brandViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fetchedResultsController?.sections?[section].name
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles = [String]()
        if let sectionInfos = self.fetchedResultsController?.sections {
            for sectionInfo in sectionInfos {
                if let indexTitle = sectionInfo.indexTitle {
                    titles.append(indexTitle)
                }
            }
        }
        return titles
    }
}

// MARK: Setup UITableView
extension BrandsViewController {
    
    func setupTableView() {
        _tableView.sectionIndexColor = UIColor.gray
        _tableView.sectionIndexBackgroundColor = UIColor.clear
        _tableView.sectionIndexTrackingBackgroundColor = UIColor(white: 0, alpha: 0.05)
    }
}

// MARK: - CollectionView Waterfall Layout
extension BrandsViewController: UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        _collectionView.indicatorStyle = .white

        // Create a flow layout
        let layout = UICollectionViewFlowLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        
        // Header view / Footer view
        layout.headerReferenceSize = CGSize(width: 0, height: 44.0)
        
        layout.sectionHeadersPinToVisibleBounds = true
        
        // Add the waterfall layout to your collection view
        _collectionView.collectionViewLayout = layout
        
        // Collection view attributes
        _collectionView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        _collectionView.alwaysBounceVertical = true
        
        // Load data
        _collectionView.reloadData()
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 3) / 2
        return CGSize(width: width, height: width * 2 / 3)
    }
}

// MARK: ZoomInteractiveTransition
extension BrandsViewController: ZoomTransitionProtocol {
    
    fileprivate func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            let cell = _collectionView.cellForItem(at: indexPath as IndexPath) as? BrandsCollectionViewCell,
            let imageView = cell.fgImageView {
                return imageView
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
            returnImageView.clipsToBounds = imageView.clipsToBounds
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransition(for operation: UINavigationControllerOperation, from fromVC: UIViewController!, to toVC: UIViewController!) -> Bool {
        if ((operation == .push && fromVC === self && toVC is BrandViewController) ||
            (operation == .pop && fromVC is BrandViewController && toVC === self)) {
            return true
        }
        return false
    }
}

// MARK: FetchedResultsController
extension BrandsViewController {
    
    func brandAtIndexPath(_ indexPath: IndexPath) -> Brand? {
        if let section = self.fetchedResultsController?.sections?[indexPath.section] {
            return section.objects?[indexPath.row] as? Brand
        }
        return nil
    }
}

// MARK: - SearchControler
extension BrandsViewController: UISearchControllerDelegate {
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(BrandViewController.showSearchController))
    }
    
    @objc func showSearchController() {
        if isListMode {
            self.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationItem.setRightBarButton(nil, animated: false)
            let searchBar = self.searchController!.searchBar
            if #available(iOS 11.0, *) {
                let searchBarContainer = SearchBarContainerView(searchBar: searchBar)
                searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
                self.navigationItem.titleView = searchBarContainer
            } else {
                self.navigationItem.titleView = searchBar
            }
        }
        self.searchController!.searchBar.becomeFirstResponder()
    }
    
    func hideSearchController() {
        if isListMode {
            self.setupRightBarButtonItem()
            self.navigationItem.titleView = nil
        }
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
        self.searchController!.searchBar.showsCancelButton = false
        self.searchController!.hidesNavigationBarDuringPresentation = false
        
        if isListMode {
            self.setupRightBarButtonItem()
        } else {
            let searchBar = self.searchController!.searchBar
            if #available(iOS 11.0, *) {
                let searchBarContainer = SearchBarContainerView(searchBar: searchBar)
                searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
                self.navigationItem.titleView = searchBarContainer
            } else {
                self.navigationItem.titleView = searchBar
            }
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.hideSearchController()
    }
}

// MARK: - UINavigationControllerDelegate
extension BrandsViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.viewWillAppear(animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        viewController.viewDidAppear(animated)
    }
}

// MARK: Updating data
extension BrandsViewController {
    
    fileprivate func beginCheckIsLoadingTimer() {
        self.endCheckIsLoadingTimer()
        self.checkLoadingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(BrandsViewController.checkIsLoading), userInfo: nil, repeats: true)
    }
    
    fileprivate func endCheckIsLoadingTimer() {
        if self.checkLoadingTimer != nil {
            self.checkLoadingTimer?.invalidate()
            self.checkLoadingTimer = nil
        }
    }
    
    @objc func checkIsLoading() {
        if DataManager.shared.isUpdatingData {
            self.showLoadingIndicator()
        } else {
            self.endCheckIsLoadingTimer()
            self.showReloadButton()
        }
    }
    
    fileprivate func showLoadingIndicator() {
        self._reloadButton.isHidden = true
        self._loadingIndicator.isHidden = false
        self._loadingIndicator.startAnimating()
        self._loadingLabel.text = NSLocalizedString("brands_vc_no_data_label_loading")
    }
    
    fileprivate func showReloadButton() {
        self._reloadButton.isHidden = false
        self._loadingIndicator.isHidden = true
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
        super.prepareForReuse()
        fgImageView.image = UIImage(named: "img_placeholder_3_2_m")
        lblTitle.text = nil
    }
}

class MoreCollectionReusableView: UICollectionReusableView {
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        lblTitle.text = NSLocalizedString("brands_vc_all_brands")
        lblTitle.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        lblTitle.layer.shadowOpacity = 1
        lblTitle.layer.shadowRadius = 2
        lblTitle.layer.shadowOffset = CGSize.zero
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
        super.prepareForReuse()
        lblTitle.text = nil
    }
}
