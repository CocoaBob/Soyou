//
//  BrandViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

private class CategoryItem: AnyObject {
    var id: NSNumber = 0.0
    var label: String = ""
    var parent: CategoryItem?
    var children: [CategoryItem] = [CategoryItem]()
    var childrenIsVisible: Bool = false
}

class BrandViewController: UIViewController {
    
    // Properties
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblTitleCategories: UILabel!
    @IBOutlet var lblTitleStores: UILabel!
    
    var searchController: UISearchController?
    
    private var _sections = [CategoryItem]()
    
    var brandID: NSNumber?
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
    
    // Class methods
    class func instantiate() -> BrandViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("BrandViewController") as! BrandViewController
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Hide tabs
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitleCategories.text = NSLocalizedString("brand_vc_root_title_categories")
        self.lblTitleStores.text = NSLocalizedString("brand_vc_root_title_stores")
        
        // Layout the subviews (otherwise the tableview will be 600x600 at the very beginning)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        // UIViewController
        self.title = self.brandName
        
        // Update footer view size
        self.updateFooterView()
        
        // Load data
        self.loadData()
        
        // Parallax Header
        self.setupParallaxHeader()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, self.tableView.parallaxHeader.height ?? 0, false, false)
        
        // Setup Search Controller
        self.setupSearchController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EmbedStoreMapViewController" {
            let storeMapViewController = segue.destinationViewController as! StoreMapViewController
            storeMapViewController.brandID = self.brandID
        } else if segue.identifier == "PushStoreMapViewController" {
            let storeMapViewController = segue.destinationViewController as! StoreMapViewController
            storeMapViewController.brandID = self.brandID
            storeMapViewController.brandName = self.brandName
        }

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
        self.tableView.reloadData()
    }
}

// MARK: Parallax Header
extension BrandViewController {
    
    private func setupParallaxHeader() {
        // Image
        guard let image = brandImage else { return }
        // Height
        let headerHeight = self.view.bounds.size.width * image.size.height / image.size.width
        // Header View
        let headerView = UIImageView(image: image)
        headerView.contentMode = .ScaleAspectFill
        // Parallax View
        let scrollView = self.tableView
        scrollView.parallaxHeader.height = headerHeight
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.mode = .Fill
    }
}

// MARK: Table View
extension BrandViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func updateFooterView() {
        guard let footerView = self.tableView.tableFooterView else { return }
        let viewWidth = self.view.frame.size.width
        footerView.layoutMargins = UIEdgeInsetsMake(15, 15, 15, 15)
        let marginH = footerView.layoutMargins.left + footerView.layoutMargins.right
        let marginV = footerView.layoutMargins.top + footerView.layoutMargins.bottom
        footerView.frame = CGRectMake(0, 0, viewWidth, (viewWidth - marginH) * 0.5 + marginV)
        self.tableView.tableFooterView = footerView // Reset footer view to update the frame
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

// MARK: UIGestureRecognizerDelegate
extension BrandViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            self.isEdgeSwiping = true
        }
        return true
    }
}

// MARK: ZoomInteractiveTransition
extension BrandViewController: ZoomTransitionProtocol {
    
    private func imageViewForZoomTransition() -> UIImageView? {
        if let parallaxHeaderView = self.tableView.parallaxHeader.view {
            parallaxHeaderView.setNeedsLayout()
            parallaxHeaderView.layoutIfNeeded()
            return parallaxHeaderView as? UIImageView
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
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        // No zoom transition from BrandVC to ProductsVC
        if operation == .Push && fromVC === self && toVC is ProductsViewController {
            return false
        }
        
        // No zoom transition when edge swiping
        if self.isEdgeSwiping {
            return false
        }
        return true
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
        
        self.tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    private func presentProductsViewController(indexPath: NSIndexPath) {
        let productsViewController = ProductsViewController.instantiate()
        let item = itemForIndexPath(indexPath)
        productsViewController.categoryName = item.label
        productsViewController.categoryID = self.itemForIndexPath(indexPath).id
        productsViewController.brandID = self.brandID
        self.navigationController?.pushViewController(productsViewController, animated: true)
    }
    
    @IBAction func didTapAccessoryButton(sender: UIButton) {
        let position = sender.convertPoint(CGPointZero, toView: self.tableView)
        guard let indexPath = self.tableView.indexPathForRowAtPoint(position) else { return }
        self.presentProductsViewController(indexPath)
    }
}

// MARK: - SearchControler
extension BrandViewController: UISearchControllerDelegate {
    
    func setupSearchController() {
        let searchResultsController = ProductsViewController.instantiate()
        searchResultsController.isSearchResultsViewController = true
        searchResultsController.brandID = self.brandID
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController?.delegate = self
        self.searchController?.searchResultsUpdater = searchResultsController
        self.searchController!.searchBar.placeholder = FmtString(NSLocalizedString("brand_vc_search_bar_placeholder"),self.brandName ?? "")
        self.searchController?.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = self.searchController!.searchBar
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
}

// MARK: - Custom cells
class BrandViewHierarchyListRootCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnAccessory: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnAccessory.setTitle(NSLocalizedString("brand_vc_root_cell_all"), forState: .Normal)
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