//
//  FavoritesViewController.swift
//  iPrices
//
//  Created by CocoaBob on 19/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

enum FavoriteType: Int {
    case News
    case Products
}

class FavoritesViewController: BaseViewController {
    
    // Override BaseViewController
    @IBOutlet var _tableView: UITableView!
    
    override func tableView() -> UITableView {
        return _tableView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        switch (type) {
        case .News:
            return News.MR_fetchAllGroupedBy(nil, withPredicate: FmtPredicate("appIsLiked == %@", NSNumber(bool: true)), sortedBy: "datePublication:false,id:false,appIsMore:true", ascending: false)
        case .Products:
            return Product.MR_fetchAllGroupedBy(nil, withPredicate: FmtPredicate("appIsLiked == %@", NSNumber(bool: true)), sortedBy: "order,id", ascending: true)
        }
    }
    
    // Properties
    var type: FavoriteType = .Products
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table
        self.tableView().estimatedRowHeight = 44
        self.tableView().rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

// MARK: Table View
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch (type) {
        case .News:
            let _cell = tableView.dequeueReusableCellWithIdentifier("FavoriteNewsTableViewCell", forIndexPath: indexPath) as! FavoriteNewsTableViewCell
            let news = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
            // Title
            _cell.lblTitle.text = news.title
            // Image
            if let imageURLString = news.image, let imageURL = NSURL(string: imageURLString) {
                _cell.imgView.sd_setImageWithURL(imageURL,
                    placeholderImage: UIImage.imageWithRandomColor(nil),
                    options: [.ContinueInBackground, .AllowInvalidSSLCertificates, .HighPriority],
                    completed: nil)
            }
            cell = _cell
        case .Products:
            let _cell = tableView.dequeueReusableCellWithIdentifier("FavoriteProductsTableViewCell", forIndexPath: indexPath) as! FavoriteProductsTableViewCell
            let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
            // Title
            _cell.lblTitle?.text = product.title
            // Brand
            _cell.lblBrand?.text = product.brandLabel
            // Price
            if let prices = product.prices as? NSArray {
                if let price = prices.firstObject as! NSDictionary?, priceNumber = price["price"] as? NSNumber {
                    _cell.lblPrice?.text = FmtString("%@",priceNumber)
                }
            }
            // Image
            if let images = product.images as? NSArray, let imageURLString = images.firstObject as? String, let imageURL = NSURL(string: imageURLString) {
                _cell.imgView?.sd_setImageWithURL(imageURL,
                    placeholderImage: UIImage.imageWithRandomColor(nil),
                    options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                    completed: nil)
            }
            cell = _cell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch (type) {
        case .News:
            break
        case .Products:
            break
        }
    }
}

// MARK: - Custom cells
class FavoriteNewsTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imgView.image = nil
        lblTitle.text = nil
    }
}

class FavoriteProductsTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        lblBrand.text = nil
        lblTitle.text = nil
        lblPrice.text = nil
    }
}