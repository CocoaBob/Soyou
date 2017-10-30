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
    return (lhs.id.intValue == rhs.id.intValue)
}

private func < (lhs: CategoryItem, rhs: CategoryItem) -> Bool {
    if (lhs.order.intValue < rhs.order.intValue) {
        return true
    } else {
        return (lhs.label.compare(rhs.label, options: [.caseInsensitive, .diacriticInsensitive], range: nil, locale: Locale(identifier: "zh_CN")) == .orderedAscending)
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
    
    fileprivate var _categoryItems = [CategoryItem]()
    fileprivate var _tableViewItems = [BrandTableViewItem]()
    
    var brandID: NSNumber?
    var brandName: String?
    var brandCategories: [NSDictionary]?
    var brandImageURL: URL? {
        didSet {
            SDWebImageManager.shared().imageDownloader?.downloadImage(
                with: brandImageURL,
                options: [.continueInBackground, .allowInvalidSSLCertificates],
                progress: nil,
                completed: { (image, data, error, finished) -> Void in
                    self.brandImage = image
            })
        }
    }
    var brandImage: UIImage?
    
    // Class methods
    class func instantiate() -> BrandViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewController(withIdentifier: "BrandViewController") as! BrandViewController
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
        
        DispatchQueue.global(qos: .background).async {
            // Load categories data
            self.prepareCategories()
            self.loadTableViewItems(nil)
            
            DispatchQueue.main.async {
                // Reload table
                self.tableView.reloadData()
            }
        }
        
        // Parallax Header
        self.setupParallaxHeader()
        
        // Setup Search Controller
        self.setupSearchController()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, self.tableView.parallaxHeader.height , true, true, false, false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = false
        // Make sure interactive gesture's delegate is nil before disappearing
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedStoreMapViewController" {
            if let storeMapViewController = segue.destination as? StoreMapViewController {
                storeMapViewController.brandID = self.brandID
            }
        } else if segue.identifier == "PushStoreMapViewController" {
            if let storeMapViewController = segue.destination as? StoreMapViewController {
                storeMapViewController.brandID = self.brandID
                storeMapViewController.brandName = self.brandName
                storeMapViewController.isFullMap = true
            }
        }

    }
}

// MARK: Data
extension BrandViewController {
    
    fileprivate func findCategoryItemWithID(_ items: [CategoryItem], searchingID: NSNumber) -> CategoryItem? {
        for item in items {
            if item.id == searchingID {
                return item
            } else if let returnValue = findCategoryItemWithID(item.children, searchingID: searchingID) {
                return returnValue
            }
        }
        return nil
    }
    
    fileprivate func sortCategories(_ categories: [CategoryItem]) -> [CategoryItem] {
        for category in categories {
            category.children = self.sortCategories(category.children)
        }
        return categories.sorted(by: <)
    }
    
    fileprivate func prepareCategories() {
        guard var categories = self.brandCategories else { return }
        
        // Prepare empty array
        _categoryItems = [CategoryItem]()
        
        // Add sections
        for dict in categories {
            if let parentID = dict["parentId"], parentID is NSNull,
                let id = dict["id"] as? NSNumber,
                let label = dict["label"] as? String,
                let order = dict["order"] as? NSNumber {
                    let item = CategoryItem()
                    item.id = id
                    item.label = label
                    item.order = order
                    _categoryItems.append(item)
                    categories.remove(at: categories.index(of: dict)!)
            }
        }
        
        // Add children
        while !categories.isEmpty {
            for dict in categories {
                if let parentID = dict["parentId"] as? NSNumber,
                    let parentItem = findCategoryItemWithID(_categoryItems, searchingID: parentID),
                    let id = dict["id"] as? NSNumber,
                    let label = dict["label"] as? String,
                    let order = dict["order"] as? NSNumber {
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
                        categories.remove(at: categories.index(of: dict)!)
                        
                }
            }
        }
        
        // Sort categories
        _categoryItems = self.sortCategories(_categoryItems)
    }
    
    // Load category items into _tableViewItems
    fileprivate func loadCategoryItems(_ categoryItems: [CategoryItem]) {
        for categoryItem in categoryItems {
            _tableViewItems.append(BrandTableViewItem(categoryItem: categoryItem))
            if categoryItem.childrenIsVisible {
                self.loadCategoryItems(categoryItem.children)
            }
        }
    }
    
    fileprivate func closeChildren(_ categoryItems: [CategoryItem]) {
        for categoryItem in categoryItems {
            categoryItem.childrenIsVisible = false
            self.closeChildren(categoryItem.children)
        }
    }
    
    fileprivate func openParent(_ categoryItem: CategoryItem?) {
        if let categoryItem = categoryItem {
            categoryItem.childrenIsVisible = true
            self.openParent(categoryItem.parent)
        }
    }
    
    fileprivate func loadTableViewItems(_ lastOpenItem: CategoryItem?) {
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
    
    fileprivate func setupParallaxHeader() {
        // Image
        guard let image = brandImage else { return }
        // Height
        let headerHeight = self.view.bounds.width * image.size.height / image.size.width
        // Header View
        let headerView = UIImageView(image: image)
        headerView.contentMode = .scaleAspectFill
        headerView.clipsToBounds = true
        // Parallax View
        let scrollView = self.tableView as UIScrollView
        scrollView.parallaxHeader.height = headerHeight
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.mode = .fill
    }
}

// MARK: Table View
extension BrandViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func updateFooterView() {
        guard let footerView = self.tableView.tableFooterView else { return }
        let viewWidth = self.view.frame.width
        footerView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let marginH = footerView.layoutMargins.left + footerView.layoutMargins.right
        let marginV = footerView.layoutMargins.top + footerView.layoutMargins.bottom
        footerView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: (viewWidth - marginH) * 0.5 + marginV)
        self.tableView.tableFooterView = footerView // Reset footer view to update the frame
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemForIndexPath(indexPath)
        var cell: UITableViewCell?
        
        if isRootItem(indexPath) && !item.isLeaf() {
            if let _cell = tableView.dequeueReusableCell(withIdentifier: "BrandViewHierarchyListRootCell", for: indexPath) as? BrandViewHierarchyListRootCell {
                _cell.lblTitle!.text = item.label
                _cell.imgTriangle.image = UIImage(named: item.childrenIsVisible ? "img_cell_opened" : "img_cell_closed")
                cell = _cell
            }
        } else {
            // Has children
            if !item.isLeaf() {
                if let _cell = tableView.dequeueReusableCell(withIdentifier: "BrandViewHierarchyListChildCell", for: indexPath) as? BrandViewHierarchyListChildCell {
                    _cell.lblTitle!.text = item.label
                    _cell.level = item.level
                    _cell.imgTriangle.image = UIImage(named: item.childrenIsVisible ? "img_cell_opened" : "img_cell_closed")
                    cell = _cell
                }
            }
            // Leaf item
            else {
                if let _cell = tableView.dequeueReusableCell(withIdentifier: "BrandViewHierarchyListLeafCell", for: indexPath) as? BrandViewHierarchyListLeafCell {
                    _cell.lblTitle!.text = item.label
                    _cell.level = item.level   
                    cell = _cell
                }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            self.isEdgeSwiping = true
        }
        return true
    }
}

// MARK: ZoomInteractiveTransition
extension BrandViewController: ZoomTransitionProtocol {
    
    fileprivate func imageViewForZoomTransition() -> UIImageView? {
        if let parallaxHeaderView = self.tableView.parallaxHeader.view {
            parallaxHeaderView.setNeedsLayout()
            parallaxHeaderView.layoutIfNeeded()
            return parallaxHeaderView as? UIImageView
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
        // No zoom transition when edge swiping
        if self.isEdgeSwiping {
            return false
        }
        // Only available for opening a brand from brands view controller
        if ((operation == .push && fromVC is BrandsViewController && toVC === self) ||
            (operation == .pop && fromVC === self && toVC is BrandsViewController)) {
            return true
        }
        return false
    }
}

// MARK: - Hierarchy List
extension BrandViewController {
    
    fileprivate func itemForIndexPath(_ indexPath: IndexPath) -> CategoryItem {
        return _tableViewItems[indexPath.row].categoryItem
    }
    
    fileprivate func indexForItem(_ categoryItem: CategoryItem) -> Int {
        for (index, tableViewItem) in _tableViewItems.enumerated() {
            if tableViewItem.categoryItem == categoryItem {
                return index
            }
        }
        return NSNotFound
    }
    
    fileprivate func isRootItem(_ indexPath: IndexPath) -> Bool {
        return self.itemForIndexPath(indexPath).parent == nil
    }
    
    fileprivate func toggleChildrenVisibility(_ indexPath: IndexPath) {
        let categoryItem = itemForIndexPath(indexPath)
        let wasVisible = categoryItem.childrenIsVisible
        self.loadTableViewItems(wasVisible ? categoryItem.parent : categoryItem)

        self.tableView.reloadData()
    }
    
    fileprivate func presentProductsViewController(_ item: CategoryItem) {
        let productsViewController = ProductsViewController.instantiate()
        productsViewController.categoryName = item.label
        productsViewController.categoryID = item.id
        productsViewController.brandID = self.brandID
        self.navigationController?.pushViewController(productsViewController, animated: true)
    }
    
    @IBAction func didTapAccessoryButton(_ sender: UIButton) {
        let position = sender.convert(CGPoint.zero, to: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: position) else { return }
        self.presentProductsViewController(self.itemForIndexPath(indexPath))
    }
}

// MARK: - SearchControler
extension BrandViewController: UISearchControllerDelegate {
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(BrandViewController.showSearchController))
    }
    
    @objc func showSearchController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setRightBarButton(nil, animated: false)
        let searchBar = self.searchController!.searchBar
        self.navigationItem.titleView = searchBar
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
    
    func willDismissSearchController(_ searchController: UISearchController) {
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
        
        btnAccessory.setTitle(NSLocalizedString("brand_vc_root_cell_all"), for: .normal)
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
                self.backgroundColor = UIColor.white
                self.lblTitle.textColor = UIColor(white: 0.25, alpha: 1)
                self.lblTitle.font = UIFont.boldSystemFont(ofSize: 16)
            } else {
                self.backgroundColor = UIColor(white: 0.96, alpha: 1)
                self.lblTitle.textColor = UIColor(white: 0.33, alpha: 1)
                self.lblTitle.font = UIFont.systemFont(ofSize: 16)
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
        
        btnAccessory.setTitle(NSLocalizedString("brand_vc_root_cell_all"), for: .normal)
    }
    
    override func leftMarginMin() -> Int {
        return 15
    }
}

class BrandViewHierarchyListLeafCell: BrandViewHierarchyListSubCell {
    
}
