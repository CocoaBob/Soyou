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
    var childrenIsVisible: Bool = false
}

class BrandViewController: BaseViewController {
    
    @IBOutlet var _tableView: UITableView?
    @IBOutlet var _mapView: MKMapView?
    
    private var _locationManager = CLLocationManager()
    private var _sections = [CategoryItem]()
    
    var coverHeight:CGFloat = 200.0
    
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
    var brandImage: UIImage?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Hide tabs
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout the subviews (otherwise the tableview will be 600x600 at the very beginning)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        // UIViewController
        self.title = self.brandName
        
        // Twitter cover view
        self.updateTwitterCoverView()
        
        // Update footer view size
        self.updateFooterView()
        
        // Load data
        self.loadData()
        
        // Update user locations
        self.initLocationManager()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView()!, false, false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideToolbar(false)
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return Product.MR_fetchAllGroupedBy(nil, withPredicate: FmtPredicate("brandId == %@", self.brandID ?? ""), sortedBy: nil, ascending: true)
    }
    
    override func tableView() -> UITableView? {
        return _tableView
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
        self.tableView()?.reloadData()
    }
}


// MARK: Table View
extension BrandViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func updateTwitterCoverView() {
        guard let image = brandImage else { return }
        let coverWidth = self.view.bounds.size.width
        coverHeight = coverWidth * image.size.height / image.size.width
        if let tableView = self.tableView() {
            tableView.addTwitterCoverWithImage(image, coverHeight: coverHeight, noBlur: true)
            if let tableHeaderView = tableView.tableHeaderView {
                tableHeaderView.frame = CGRectMake(0, 0, coverWidth, coverHeight)
                tableView.tableHeaderView = tableHeaderView // Reset header view to update the frame
            }
        }
    }
    
    private func updateFooterView() {
        guard let footerView = self.tableView()?.tableFooterView else { return }
        let viewWidth = self.view.frame.size.width
        footerView.layoutMargins = UIEdgeInsetsMake(15, 15, 15, 15)
        let marginH = footerView.layoutMargins.left + footerView.layoutMargins.right
        let marginV = footerView.layoutMargins.top + footerView.layoutMargins.bottom
        footerView.frame = CGRectMake(0, 0, viewWidth, (viewWidth - marginH) * 0.5 + marginV)
        self.tableView()?.tableFooterView = footerView // Reset footer view to update the frame
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return _sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = _sections[section]
        return 1 + (item.childrenIsVisible ? _sections[section].children.count : 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = itemForIndexPath(indexPath)
        var cell: UITableViewCell?
        
        if isRootItem(indexPath) {
            let _cell = tableView.dequeueReusableCellWithIdentifier("BrandViewHierarchyListRootCell", forIndexPath: indexPath) as! BrandViewHierarchyListRootCell
            
            _cell.lblTitle!.text = item.label
            
            _cell.imgView.image = UIImage(named: item.childrenIsVisible ? "img_cell_opened" : "img_cell_closed")
            
            cell = _cell
        } else {
            let _cell = tableView.dequeueReusableCellWithIdentifier("BrandViewHierarchyListSubCell", forIndexPath: indexPath) as! BrandViewHierarchyListSubCell
            
            _cell.lblTitle!.text = item.label
            
            cell = _cell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if isRootItem(indexPath) {
            self.toggleHierarchyListRootItem(indexPath)
        } else {
            self.presentProductsViewController(indexPath)
        }
    }
}

// MARK: ZoomInteractiveTransition
extension BrandViewController: ZoomTransitionProtocol {
    
    func viewForZoomTransition(isSource: Bool) -> UIView? {
        if let twitterCoverView = self.tableView()?.twitterCoverView {
            return twitterCoverView
        }
        return nil
    }
}

// MARK: - Hierarchy List
extension BrandViewController {
    
    private func isRootItem(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 0
    }
    
    private func itemForIndexPath(indexPath: NSIndexPath) -> CategoryItem {
        return isRootItem(indexPath) ? _sections[indexPath.section] : _sections[indexPath.section].children[indexPath.row - 1]
    }
    
    private func toggleHierarchyListRootItem(indexPath: NSIndexPath) {
        var lastOpenedSection: Int = NSNotFound
        for (index, item) in _sections.enumerate() {
            if index != indexPath.section && item.childrenIsVisible {
                item.childrenIsVisible = false
                lastOpenedSection = index
            }
        }
        
        let item = itemForIndexPath(indexPath)
        item.childrenIsVisible = !item.childrenIsVisible
        
        let indexSet = NSMutableIndexSet(index: indexPath.section)
        if lastOpenedSection != NSNotFound {
            indexSet.addIndex(lastOpenedSection)
        }
        
        self.tableView()?.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    private func presentProductsViewController(indexPath: NSIndexPath) {
        let item = self.itemForIndexPath(indexPath)
        
        if let productsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductsViewController") as? ProductsViewController {
            productsViewController.brandID = self.brandID
            productsViewController.brandName = self.brandName
            productsViewController.categoryID = item.id
            self.navigationController?.pushViewController(productsViewController, animated: true)
        }
    }
    
    @IBAction func didTapAccessoryButton(sender: UIButton) {
        guard let tableView = self.tableView() else { return }
        let position = sender.convertPoint(CGPointZero, toView: tableView)
        guard let indexPath = tableView.indexPathForRowAtPoint(position) else { return }
        self.presentProductsViewController(indexPath)
    }
}

// MARK: CLLocationManager
extension BrandViewController: CLLocationManagerDelegate {
    
    private func initLocationManager() {
        _locationManager.delegate = self
        _locationManager.requestWhenInUseAuthorization()
        _locationManager.startUpdatingLocation()
        _locationManager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            _mapView?.setRegion(MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.5, 0.5)), animated: false)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        DLog(error)
    }
}

// MARK: - Custom cells
class BrandViewHierarchyListRootCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnAccessory: UIButton!
    
    override func awakeFromNib() {
        btnAccessory.setBackgroundImage(UIImage(named: "img_cell_disclosure"), forState: .Normal)
    }
    
    override func prepareForReuse() {
        lblTitle.text = nil
    }
}

class BrandViewHierarchyListSubCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnAccessory: UIButton!
    
    override func prepareForReuse() {
        lblTitle.text = nil
    }
}