//
//  BrandViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

private class CategoryItem: AnyObject {
    var id: NSNumber = 0.0
    var label: String = ""
    var parent: CategoryItem?
    var children: [CategoryItem] = [CategoryItem]()
}

class BrandViewController: BaseViewController {
    
    @IBOutlet var _tableView: UITableView?
    @IBOutlet var _mapView: MKMapView?
    var _locationManager = CLLocationManager()
    
    private var _sections = [CategoryItem]()
    
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    var brandID: String?
    var brandName: String?
    var brandCategories: [NSDictionary]?
    var brandImageURL: NSURL? {
        didSet {
            SDWebImageManager.sharedManager().downloadImageWithURL(
                brandImageURL,
                options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                progress: { (receivedSize: NSInteger, expectedSize: NSInteger) -> Void in
                    
                },
                completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, finished: Bool, url: NSURL!) -> Void in
                    self.brandImage = image
                }
            )
        }
    }
    var brandImage: UIImage? {
        didSet {
            if let image = brandImage {
                let coverWidth = self.view.bounds.size.width
                let coverHeight = coverWidth * image.size.height / image.size.width
                _tableView!.addTwitterCoverWithImage(image, coverHeight: coverHeight, noBlur: true)
                _tableView!.tableHeaderView?.frame = CGRectMake(0, 0, coverWidth, coverHeight)
                _tableView!.tableHeaderView = _tableView!.tableHeaderView // Reset header view to update the frame
            }
        }
    }
    
    init(id: String?, name: String?, categories: [NSDictionary]?) {
        self.brandID = id
        self.brandName = name
        self.brandCategories = categories
        
        super.init(nibName: nil, bundle: nil)
        
        // Hide tabs
        self.hidesBottomBarWhenPushed = true
    }
    
    convenience init() {
        self.init(id: nil, name: nil, categories: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIViewController
        self.title = self.brandName
        
        // Update footer view size
        if let footerView = _tableView?.tableFooterView {
            let viewWidth = self.view.frame.size.width
            footerView.layoutMargins = UIEdgeInsetsMake(15, 15, 15, 15)
            let marginH = footerView.layoutMargins.left + footerView.layoutMargins.right
            let marginV = footerView.layoutMargins.top + footerView.layoutMargins.bottom
            footerView.frame = CGRectMake(0, 0, viewWidth, (viewWidth - marginH) * 0.5 + marginV)
            _tableView?.tableFooterView = footerView // Reset footer view to update the frame
        }
        
        // Data
        self.loadData()
        
        // Locations
        _locationManager.delegate = self
        _locationManager.requestWhenInUseAuthorization()
        _locationManager.startUpdatingLocation()
        _locationManager.requestLocation()
        
        // Prepare map view
//        _mapView?.region = MKCoordinateRegionForMapRect(MKMapRectWorld)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideToolbar(false)
        
        if let navigationController = self.navigationController {
            if navigationController.delegate == nil || navigationController.delegate! !== self {
                // UINavigationController delegate
                navigationController.delegate = self
                navigationController.interactivePopGestureRecognizer?.delegate = self
                
                // Fix scroll view insets
                self.updateScrollViewInset(_tableView!, false, false)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return Product.MR_fetchAllGroupedBy(nil, withPredicate: FmtPredicate("brandId == %@", self.brandID ?? ""), sortedBy: nil, ascending: true)
    }

}

// MARK: Data
extension BrandViewController {
    
    private func findCategoryItemWithID(items: [CategoryItem], searchingID: NSNumber) -> CategoryItem? {
        for item in items {
            if item.id == searchingID {
                return item
            } else if let returnValue = findCategoryItemWithID(item.children, searchingID: searchingID) {
                return returnValue
            }
        }
        return nil
    }
    
    private func loadData() {
        guard var categories = self.brandCategories else { return }
        
        // Prepare empty array
        _sections = [CategoryItem]()
        
        // Add sections
        for dict in categories {
            if let parentID = dict["parentId"] where parentID is NSNull {
                let item = CategoryItem()
                item.id = dict["id"] as! NSNumber
                item.label = dict["label"] as! String
                _sections.append(item)
                categories.removeAtIndex(categories.indexOf(dict)!)
            }
        }
        
        // Add children
        while categories.count > 0 {
            for dict in categories {
                if let parentItem = findCategoryItemWithID(_sections, searchingID: dict["parentId"] as! NSNumber) {
                    let item = CategoryItem()
                    item.id = dict["id"] as! NSNumber
                    item.label = dict["label"] as! String
                    item.parent = parentItem
                    parentItem.children.append(item)
                    categories.removeAtIndex(categories.indexOf(dict)!)
                }
            }
        }
        
        // Reload table
        _tableView?.reloadData()
    }
}


// MARK: UITableViewDataSource, UITableViewDelegate
extension BrandViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return _sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _sections[section].children.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = (indexPath.row == 0) ? _sections[indexPath.section] : _sections[indexPath.section].children[indexPath.row - 1]
        let cell = tableView.dequeueReusableCellWithIdentifier("BrandTableViewCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = item.label
        cell.textLabel?.font = (indexPath.row == 0) ? UIFont.boldSystemFontOfSize(13) : UIFont.systemFontOfSize(13)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let item = (indexPath.row == 0) ? _sections[indexPath.section] : _sections[indexPath.section].children[indexPath.row - 1]
        if let productsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductsViewController") as? ProductsViewController {
            productsViewController.brandID = self.brandID
            productsViewController.brandName = self.brandName
            productsViewController.categoryID = item.id
            self.navigationController?.pushViewController(productsViewController, animated: true)
        }
    }
}

// MARK: UIGestureRecognizerDelegate (interactivePopGestureRecognizer.delegate)
extension BrandViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.isEdgeSwiping = true
        return true
    }
}

// MARK: - UINavigationControllerDelegate
extension BrandViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.isEdgeSwiping {
            self.isEdgeSwiping = false
            return nil
        }
        
        if fromVC is RMPZoomTransitionAnimating && toVC is RMPZoomTransitionAnimating {
            let src = fromVC as! protocol<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>
            let dest = toVC as! protocol<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>
            
            // If one of the frames is invisible
            if (operation == .Pop &&
                src.transitionDestinationImageViewFrame().size.height == 0) {
                    return nil
            }
            
            let animator = RMPZoomTransitionAnimator()
            animator.goingForward = (operation == .Push)
            animator.sourceTransition = src
            animator.destinationTransition = dest
            return animator
        }
        
        return nil
    }
}

// MARK: - CLLocationManagerDelegate
extension BrandViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            _mapView?.setCenterCoordinate(coordinate, animated: false)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        DLog(error)
    }
}