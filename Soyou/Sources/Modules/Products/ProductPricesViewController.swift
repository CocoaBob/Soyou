//
//  ProductPricesViewController.swift
//  Soyou
//
//  Created by CocoaBob on 14/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class ProductPricesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    weak var productViewController: ProductViewController?
    
    // //[ { "country": "FR", "price": 1450 } ]
    var prices: [[String: AnyObject]]? {
        didSet {
            if let _prices = prices {
                for (index, var price) in _prices.enumerate() {
                    if let countryCode = price["country"] as? String,
                        priceOriginal = price["price"] as? NSNumber {
                            price["priceUserCurrency"] = CurrencyManager.shared.userCurrencyFromCurrency(countryCode, price: priceOriginal)
                            prices![index] = price
                    }
                }
                
                prices!.sortInPlace({
                    let item0 = $0 as [String: AnyObject]
                    let item1 = $1 as [String: AnyObject]
                    if let price0 = item0["priceUserCurrency"] as? NSNumber,
                        price1 = item1["priceUserCurrency"] as? NSNumber {
                            return price0.doubleValue < price1.doubleValue
                    }
                    return false
                })
            }
        }
    }
    
    // Class methods
    class func instantiate() -> ProductPricesViewController {
        return (UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("ProductPricesViewController") as? ProductPricesViewController)!
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
}

// MARK: Table View
extension ProductPricesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.prices?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let prices = self.prices else { return UITableViewCell() }
        guard let item: [String: AnyObject] = prices[indexPath.section] else { return UITableViewCell() }
        guard let countryCode = item["country"] as? String else { return UITableViewCell() }
        guard let price = item["price"] as? NSNumber else { return UITableViewCell() }
        
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            let _cell = (tableView.dequeueReusableCellWithIdentifier("ProductPricesTableViewCellCountry", forIndexPath: indexPath) as? ProductPricesTableViewCellCountry)!
            
            if let image = UIImage(flagImageWithCountryCode: countryCode) {
                _cell.imgView.image = image
            } else {
                _cell.imgView.image = UIImage(flagImageForSpecialFlag: .World)
            }
            let countryName = CurrencyManager.shared.countryName(countryCode)
            _cell.lblTitle.text = FmtString(NSLocalizedString("product_prices_vc_official_price"), countryName ?? "")
            
            // Hide website label if not available
            if let officialUrlString = item["officialUrl"] as? String {
                _cell.lblAccessory.hidden = officialUrlString.characters.isEmpty
                _cell.accessoryType = _cell.lblAccessory.hidden ? .None : .DisclosureIndicator
            } else {
                _cell.lblAccessory.hidden = true
                _cell.accessoryType = .None
            }

            cell = _cell
        } else {
            let _cell = (tableView.dequeueReusableCellWithIdentifier("ProductPricesTableViewCellCurrency", forIndexPath: indexPath) as? ProductPricesTableViewCellCurrency)!
            
            _cell.lblRetailCurrency.text = CurrencyManager.shared.currencyName(countryCode ?? "")
            _cell.lblRetailPrice.text = CurrencyManager.shared.formattedPrice(price, nil, false)
            _cell.lblEquivalentCurrency.text = CurrencyManager.shared.currencyNameFromCurrencyCode(CurrencyManager.shared.userCurrency) ?? NSLocalizedString("currency_unknown")
            if let priceUserCurrency = item["priceUserCurrency"] as? NSNumber {
                _cell.lblEquivalentPrice.text = CurrencyManager.shared.formattedPrice(priceUserCurrency, nil, false)
            } else {
                _cell.lblEquivalentPrice.text = NSLocalizedString("product_prices_vc_unavailable")
            }
            
            cell = _cell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        } else {
            return 56
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            guard let prices = self.prices else { return }
            guard let item: [String: AnyObject] = prices[indexPath.section] else { return }
            guard let officialUrlString = item["officialUrl"] as? String else { return }
            if officialUrlString.characters.isEmpty {
                return
            }
            guard let officialUrl = NSURL(string: officialUrlString) else { return }
            if #available(iOS 9.0, *) {
                let webViewController = SFSafariViewController(URL: officialUrl, entersReaderIfAvailable: false)
                self.productViewController?.presentViewController(webViewController, animated: true, completion: nil)
            } else {
                let webViewController = SVWebViewController(URL: officialUrl)
                self.productViewController?.navigationController?.pushViewController(webViewController, animated: true)
                self.productViewController?.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        } else {
            
        }
    }
}

class ProductPricesTableViewCellCountry: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAccessory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        
        lblAccessory.text = NSLocalizedString("product_prices_vc_official_website")
    }
    
    override func prepareForReuse() {
        imgView.image = nil
        lblTitle.text = nil
    }
}

class ProductPricesTableViewCellCurrency: UITableViewCell {
    @IBOutlet var lblRetailCurrency: UILabel!
    @IBOutlet var lblRetailPrice: UILabel!
    @IBOutlet var lblEquivalentCurrency: UILabel!
    @IBOutlet var lblEquivalentPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        lblRetailCurrency.text = nil
        lblRetailPrice.text = nil
        lblEquivalentCurrency.text = nil
        lblEquivalentPrice.text = nil
    }
}
