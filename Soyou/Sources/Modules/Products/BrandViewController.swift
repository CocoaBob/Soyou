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
    var order: NSNumber = 0
    var level: Int = 0
    var parent: CategoryItem?
    var children: [CategoryItem] = [CategoryItem]()
    var childrenIsVisible: Bool = false
    func isLeaf() -> Bool {
        return children.count == 0
    }
}

extension CategoryItem: Equatable {
}

private func == (lhs: CategoryItem, rhs: CategoryItem) -> Bool {
    return (lhs.id.integerValue == rhs.id.integerValue)
}

extension CategoryItem: Comparable {
}

private func < (lhs: CategoryItem, rhs: CategoryItem) -> Bool {
    if (lhs.order.integerValue < rhs.order.integerValue) {
        return true
    } else {
        return (lhs.label.compare(rhs.label, options: [.CaseInsensitiveSearch, .DiacriticInsensitiveSearch], range: nil, locale: NSLocale(localeIdentifier: "zh_CN")) == .OrderedAscending)
    }
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
        
        self.title = self.brandName
        
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
        self.updateScrollViewInset(self.tableView, self.tableView.parallaxHeader.height ?? 0, true, true, false, false)
        
        // Setup Search Controller
        self.setupSearchController()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
            storeMapViewController.isFullMap = true
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
    
    private func sortCategories(categories: [CategoryItem]) ->[CategoryItem] {
        for category in categories {
            category.children = self.sortCategories(category.children)
        }
        return categories.sort(<)
    }
    
    private func prepareCategories() {
        guard var categories = self.brandCategories else { return }
        
        // Prepare empty array
        _sections = [CategoryItem]()
        
        // Add sections
        for dict in categories {
            if let parentID = dict["parentId"] where parentID is NSNull {
                let item = CategoryItem()
                item.id = dict["id"] as! NSNumber
                item.label = dict["label"] as! String
                item.order = dict["order"] as! NSNumber
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
                    item.order = dict["order"] as! NSNumber
                    item.parent = parentItem
                    parentItem.children.append(item)
                    // Calculate level
                    var parent = item.parent
                    while parent != nil {
                        item.level += 1
                        parent = parent?.parent
                    }
                    categories.removeAtIndex(categories.indexOf(dict)!)
                }
            }
        }
        
        // Sort categories
        _sections = self.sortCategories(_sections)
    }
    
    private func loadData() {
        self.prepareCategories()
        
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
        headerView.clipsToBounds = true
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
        
        if isRootItem(indexPath) && !item.isLeaf() {
            let _cell = tableView.dequeueReusableCellWithIdentifier("BrandViewHierarchyListRootCell", forIndexPath: indexPath) as! BrandViewHierarchyListRootCell
            
            _cell.lblTitle!.text = item.label
            
            _cell.imgView.image = UIImage(named: item.childrenIsVisible ? "img_cell_opened" : "img_cell_closed")
            
            cell = _cell
        } else {
            let _cell = tableView.dequeueReusableCellWithIdentifier("BrandViewHierarchyListSubCell", forIndexPath: indexPath) as! BrandViewHierarchyListSubCell
            
            _cell.lblTitle!.text = item.label
            _cell.level = item.level
            
            cell = _cell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let item = itemForIndexPath(indexPath)
        if isRootItem(indexPath) && !item.isLeaf() {
            self.toggleHierarchyListRootItem(indexPath)
        } else {
            self.presentProductsViewController(item)
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
            returnImageView.clipsToBounds = imageView.clipsToBounds
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        // No zoom transition when edge swiping
        if self.isEdgeSwiping {
            return false
        }
        // Only available for opening a brand from brands view controller
        if ((operation == .Push && fromVC is BrandsViewController && toVC === self) ||
            (operation == .Pop && fromVC === self && toVC is BrandsViewController)) {
            return true
        }
        return false
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
    
    private func presentProductsViewController(item: CategoryItem) {
        let productsViewController = ProductsViewController.instantiate()
        productsViewController.categoryName = item.label
        productsViewController.categoryID = item.id
        productsViewController.brandID = self.brandID
        self.navigationController?.pushViewController(productsViewController, animated: true)
    }
    
    @IBAction func didTapAccessoryButton(sender: UIButton) {
        let position = sender.convertPoint(CGPointZero, toView: self.tableView)
        guard let indexPath = self.tableView.indexPathForRowAtPoint(position) else { return }
        self.presentProductsViewController(self.itemForIndexPath(indexPath))
    }
}

// MARK: - SearchControler
extension BrandViewController: UISearchControllerDelegate {
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showSearchController")
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
        self.setupRightBarButtonItem()
        
        let productsViewController = ProductsViewController.instantiate()
        productsViewController.isSearchResultsViewController = true
        productsViewController.searchFromViewController = self
        productsViewController.brandID = self.brandID
        self.searchController = UISearchController(searchResultsController: productsViewController)
        self.searchController!.delegate = self
        self.searchController!.searchResultsUpdater = productsViewController
        self.searchController!.searchBar.placeholder = FmtString(NSLocalizedString("brand_vc_search_bar_placeholder"),self.brandName ?? "")
        self.searchController!.hidesNavigationBarDuringPresentation = false
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.hideSearchController()
    }
}

// MARK: - Custom cells
class BrandViewHierarchyListRootCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnAccessory: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        
        btnAccessory.setTitle(NSLocalizedString("brand_vc_root_cell_all"), forState: .Normal)
    }
    
    override func prepareForReuse() {
        lblTitle.text = nil
    }
}

class BrandViewHierarchyListSubCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnAccessory: UIButton!
    @IBOutlet var leftMargin: NSLayoutConstraint!
    
    var level: Int = 0 {
        didSet {
            leftMargin.constant = CGFloat(32 + 15 * level)
            if level == 0 {
                self.backgroundColor = UIColor.whiteColor()
                self.lblTitle.textColor = UIColor(white: 0.25, alpha: 1)
                self.lblTitle.font = UIFont.boldSystemFontOfSize(16)
            } else {
                self.backgroundColor = UIColor(white: 0.96, alpha: 1)
                self.lblTitle.textColor = UIColor(white: 0.33, alpha: 1)
                self.lblTitle.font = UIFont.systemFontOfSize(16)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        lblTitle.text = nil
    }
}