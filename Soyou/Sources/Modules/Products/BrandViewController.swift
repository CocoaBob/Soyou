//
//  BrandViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

// MARK: CategoryItem
private class CategoryItem {
    var id: NSNumber = 0.0
    var label: String = ""
    var order: NSNumber = 0
    var level: Int = 0
    var parent: CategoryItem?
    var children: [CategoryItem] = [CategoryItem]()
    var childrenIsVisible: Bool = false
    func isLeaf() -> Bool {
        return children.isEmpty
    }
}

extension CategoryItem: Equatable, Comparable {
}

private func == (lhs: CategoryItem, rhs: CategoryItem) -> Bool {
    return (lhs.id.integerValue == rhs.id.integerValue)
}

private func < (lhs: CategoryItem, rhs: CategoryItem) -> Bool {
    if (lhs.order.integerValue < rhs.order.integerValue) {
        return true
    } else {
        return (lhs.label.compare(rhs.label, options: [.CaseInsensitiveSearch, .DiacriticInsensitiveSearch], range: nil, locale: NSLocale(localeIdentifier: "zh_CN")) == .OrderedAscending)
    }
}

// MARK: BrandTableViewItem
private class BrandTableViewItem {
    
    var categoryItem: CategoryItem!
    
    convenience init(categoryItem: CategoryItem) {
        self.init()
        self.categoryItem = categoryItem
    }
}

// MARK: BrandViewController
class BrandViewController: UIViewController {
    
    // Properties
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblTitleCategories: UILabel!
    @IBOutlet var lblTitleStores: UILabel!
    
    var searchController: UISearchController?
    
    private var _categoryItems = [CategoryItem]()
    private var _tableViewItems = [BrandTableViewItem]()
    
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
            })
        }
    }
    var brandImage: UIImage?
    
    // Class methods
    class func instantiate() -> BrandViewController {
        return (UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("BrandViewController") as? BrandViewController)!
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
        self.prepareCategories()
        self.loadTableViewItems(nil)
        
        // Reload table
        self.tableView.reloadData()
        
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
            if let storeMapViewController = segue.destinationViewController as? StoreMapViewController {
                storeMapViewController.brandID = self.brandID
            }
        } else if segue.identifier == "PushStoreMapViewController" {
            if let storeMapViewController = segue.destinationViewController as? StoreMapViewController {
                storeMapViewController.brandID = self.brandID
                storeMapViewController.brandName = self.brandName
                storeMapViewController.isFullMap = true
            }
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
    
    private func sortCategories(categories: [CategoryItem]) -> [CategoryItem] {
        for category in categories {
            category.children = self.sortCategories(category.children)
        }
        return categories.sort(<)
    }
    
    private func prepareCategories() {
        guard var categories = self.brandCategories else { return }
        
        // Prepare empty array
        _categoryItems = [CategoryItem]()
        
        // Add sections
        for dict in categories {
            if let parentID = dict["parentId"] where parentID is NSNull,
                let id = dict["id"] as? NSNumber,
                label = dict["label"] as? String,
                order = dict["order"] as? NSNumber {
                    let item = CategoryItem()
                    item.id = id
                    item.label = label
                    item.order = order
                    _categoryItems.append(item)
                    categories.removeAtIndex(categories.indexOf(dict)!)
            }
        }
        
        // Add children
        while !categories.isEmpty {
            for dict in categories {
                if let parentID = dict["parentId"] as? NSNumber,
                    parentItem = findCategoryItemWithID(_categoryItems, searchingID: parentID),
                    id = dict["id"] as? NSNumber,
                    label = dict["label"] as? String,
                    order = dict["order"] as? NSNumber {
                        let item = CategoryItem()
                        item.id = id
                        item.label = label
                        item.order = order
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
        _categoryItems = self.sortCategories(_categoryItems)
    }
    
    // Load category items into _tableViewItems
    private func loadCategoryItems(categoryItems: [CategoryItem]) {
        for categoryItem in categoryItems {
            _tableViewItems.append(BrandTableViewItem(categoryItem: categoryItem))
            if categoryItem.childrenIsVisible {
                self.loadCategoryItems(categoryItem.children)
            }
        }
    }
    
    private func closeChildren(categoryItems: [CategoryItem]) {
        for categoryItem in categoryItems {
            categoryItem.childrenIsVisible = false
            self.closeChildren(categoryItem.children)
        }
    }
    
    private func openParent(categoryItem: CategoryItem?) {
        if let categoryItem = categoryItem {
            categoryItem.childrenIsVisible = true
            self.openParent(categoryItem.parent)
        }
    }
    
    private func loadTableViewItems(lastOpenItem: CategoryItem?) {
        // Close all
        self.closeChildren(_categoryItems)
        
        // Open the parent tree for the last open item
        self.openParent(lastOpenItem)
        
        // Collect the items
        _tableViewItems.removeAll()
        self.loadCategoryItems(_categoryItems)
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
        footerView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: (viewWidth - marginH) * 0.5 + marginV)
        self.tableView.tableFooterView = footerView // Reset footer view to update the frame
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tableViewItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = itemForIndexPath(indexPath)
        var cell: UITableViewCell?
        
        if isRootItem(indexPath) && !item.isLeaf() {
            if let _cell = tableView.dequeueReusableCellWithIdentifier("BrandViewHierarchyListRootCell", forIndexPath: indexPath) as? BrandViewHierarchyListRootCell {
                _cell.lblTitle!.text = item.label
                _cell.imgTriangle.image = UIImage(named: item.childrenIsVisible ? "img_cell_opened" : "img_cell_closed")
                cell = _cell
            }
        } else {
            // Has children
            if !item.isLeaf() {
                if let _cell = tableView.dequeueReusableCellWithIdentifier("BrandViewHierarchyListChildCell", forIndexPath: indexPath) as? BrandViewHierarchyListChildCell {
                    _cell.lblTitle!.text = item.label
                    _cell.level = item.level
                    _cell.imgTriangle.image = UIImage(named: item.childrenIsVisible ? "img_cell_opened" : "img_cell_closed")
                    cell = _cell
                }
            }
            // Leaf item
            else {
                if let _cell = tableView.dequeueReusableCellWithIdentifier("BrandViewHierarchyListLeafCell", forIndexPath: indexPath) as? BrandViewHierarchyListLeafCell {
                    _cell.lblTitle!.text = item.label
                    _cell.level = item.level   
                    cell = _cell
                }
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let categoryItem = itemForIndexPath(indexPath)
        if !categoryItem.isLeaf() {
            self.toggleChildrenVisibility(indexPath)
        } else {
            self.presentProductsViewController(categoryItem)
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
    
    private func itemForIndexPath(indexPath: NSIndexPath) -> CategoryItem {
        return _tableViewItems[indexPath.row].categoryItem
    }
    
    private func indexForItem(categoryItem: CategoryItem) -> Int {
        for (index, tableViewItem) in _tableViewItems.enumerate() {
            if tableViewItem.categoryItem == categoryItem {
                return index
            }
        }
        return NSNotFound
    }
    
    private func isRootItem(indexPath: NSIndexPath) -> Bool {
        return self.itemForIndexPath(indexPath).parent == nil
    }
    
    private func toggleChildrenVisibility(indexPath: NSIndexPath) {
        let categoryItem = itemForIndexPath(indexPath)
        let wasVisible = categoryItem.childrenIsVisible
        self.loadTableViewItems(wasVisible ? categoryItem.parent : categoryItem)

        self.tableView.reloadData()
    }
    
    private func presentProductsViewController(item: CategoryItem) {
        let productsViewController = ProductsViewController.instantiate()
        productsViewController.categoryName = item.label
        productsViewController.categoryID = item.id
        productsViewController.brandID = self.brandID
        self.navigationController?.pushViewController(productsViewController, animated: true)
    }
    
    @IBAction func didTapAccessoryButton(sender: UIButton) {
        let position = sender.convertPoint(CGPoint.zero, toView: self.tableView)
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
        
        let searchResultsController = ProductsViewController.instantiate()
        searchResultsController.isSearchResultsViewController = true
        searchResultsController.searchFromViewController = self
        searchResultsController.brandID = self.brandID
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController!.delegate = self
        self.searchController!.searchResultsUpdater = searchResultsController
        self.searchController!.searchBar.delegate = searchResultsController
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
    @IBOutlet var imgTriangle: UIImageView!
    @IBOutlet var lblTitle: UILabel!
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
    @IBOutlet var leftMargin: NSLayoutConstraint!
    
    var level: Int = 0 {
        didSet {
            leftMargin.constant = CGFloat(self.leftMarginMin() + 15 * level)
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
    
    func leftMarginMin() -> Int {
        return 32
    }
}

class BrandViewHierarchyListChildCell: BrandViewHierarchyListSubCell {
    @IBOutlet var imgTriangle: UIImageView!
    @IBOutlet var btnAccessory: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        
        btnAccessory.setTitle(NSLocalizedString("brand_vc_root_cell_all"), forState: .Normal)
    }
    
    override func leftMarginMin() -> Int {
        return 15
    }
}

class BrandViewHierarchyListLeafCell: BrandViewHierarchyListSubCell {
    
}
