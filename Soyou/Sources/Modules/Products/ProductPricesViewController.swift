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
    
    var product: Product? {
        didSet {
            let closure: (NSManagedObjectContext) -> () = { (context: NSManagedObjectContext) -> () in
                guard let localProduct = self.product?.mr_(in: context) else { return }
                if let objectData = localProduct.prices, let object = Utils.decrypt(objectData) as? [[String: AnyObject]] {
                    self.prices = object
                } else {
                    self.prices = nil
                }
            }
            if let context = self.product?.managedObjectContext {
                context.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                    closure(localContext)
                })
            } else {
                MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                    closure(localContext)
                })
            }
            self.tableView.reloadData()
        }
    }
    
    // //[ { "country": "FR", "price": 1450 } ]
    var prices: [[String: AnyObject]]? {
        didSet {
            if let _prices = prices {
                for (index, var price) in _prices.enumerated() {
                    price["priceUserCurrency"] = CurrencyManager.shared.priceInUserCurrencyFromPriceItem(price as NSDictionary)
                    prices![index] = price
                }
                
                prices!.sort(by: {
                    let item0 = $0 as [String: AnyObject]
                    let item1 = $1 as [String: AnyObject]
                    if let price0 = item0["priceUserCurrency"] as? NSNumber,
                        let price1 = item1["priceUserCurrency"] as? NSNumber {
                            return price0.doubleValue < price1.doubleValue
                    }
                    return false
                })
            }
        }
    }
    
    // Class methods
    class func instantiate() -> ProductPricesViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewController(withIdentifier: "ProductPricesViewController") as! ProductPricesViewController
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.prices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let prices = self.prices else { return UITableViewCell() }
        guard let item: [String: AnyObject] = prices[indexPath.section] else { return UITableViewCell() }
        guard let price = item["price"] as? NSNumber else { return UITableViewCell() }
        let countryCode = item["country"] as? String
        let currencyCode = item["currency"] as? String
        
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            let _cell = (tableView.dequeueReusableCell(withIdentifier: "ProductPricesTableViewCellCountry", for: indexPath) as? ProductPricesTableViewCellCountry)!
            
            if let countryCode = countryCode, let image = Flag(countryCode: countryCode)?.image(style: .roundedRect) {
                _cell.imgView.image = image
            } else {
                _cell.imgView.image = nil
            }
            if let countryCode = countryCode, let countryName = CurrencyManager.shared.countryName(countryCode) {
                _cell.lblTitle.text = countryName
            } else {
                _cell.lblTitle.text = NSLocalizedString("product_prices_vc_official_price_unknown_country")
            }
            
            // Hide website label if not available
            if let officialUrlString = item["officialUrl"] as? String {
                _cell.lblAccessory.isHidden = officialUrlString.isEmpty
                _cell.accessoryType = _cell.lblAccessory.isHidden ? .none : .disclosureIndicator
            } else {
                _cell.lblAccessory.isHidden = true
                _cell.accessoryType = .none
            }

            cell = _cell
        } else {
            let _cell = (tableView.dequeueReusableCell(withIdentifier: "ProductPricesTableViewCellCurrency", for: indexPath) as? ProductPricesTableViewCellCurrency)!
            if currencyCode != nil {
                _cell.lblRetailCurrency.text = CurrencyManager.shared.currencyNameFromCurrencyCode(currencyCode ?? "")
            } else {
                _cell.lblRetailCurrency.text = CurrencyManager.shared.currencyNameFromCountryCode(countryCode ?? "")
            }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        } else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            guard let prices = self.prices else { return }
            guard let item: [String: AnyObject] = prices[indexPath.section] else { return }
            guard let officialUrlString = item["officialUrl"] as? String else { return }
            if officialUrlString.isEmpty {
                return
            }
            guard let officialUrl = URL(string: officialUrlString) else { return }
            let webViewController = SFSafariViewController(url: officialUrl, entersReaderIfAvailable: false)
            self.productViewController?.present(webViewController, animated: true, completion: nil)
        } else {
            
        }
    }
}

// MARK: Routines
extension ProductPricesViewController {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        super.prepareForReuse()
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
        super.prepareForReuse()
        lblRetailCurrency.text = nil
        lblRetailPrice.text = nil
        lblEquivalentCurrency.text = nil
        lblEquivalentPrice.text = nil
    }
}
