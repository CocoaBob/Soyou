//
//  ProductPricesViewController.swift
//  iPrices
//
//  Created by CocoaBob on 14/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

class ProductPricesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var prices: [[String: AnyObject]]? //[ { "country": "法国", "price": 1450 } ]
    
    // Class methods
    class func instantiate() -> ProductPricesViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("ProductPricesViewController") as! ProductPricesViewController
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
        
        let countryCode = item["country"] as! String
        let price = item["price"] as! NSNumber
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            let _cell = tableView.dequeueReusableCellWithIdentifier("ProductPricesTableViewCellCountry", forIndexPath: indexPath) as! ProductPricesTableViewCellCountry
            
            if let image = UIImage(flagImageWithCountryCode: countryCode) {
                _cell.imgView.image = image
            } else {
                _cell.imgView.image = UIImage(flagImageForSpecialFlag: .World)
            }
            let countryName = CurrencyManager.shared.countryName(countryCode)
            _cell.lblTitle.text = FmtString(NSLocalizedString("product_prices_vc_official_price"), countryName ?? "")
            cell = _cell
        } else {
            let _cell = tableView.dequeueReusableCellWithIdentifier("ProductPricesTableViewCellCurrency", forIndexPath: indexPath) as! ProductPricesTableViewCellCurrency
            
            _cell.lblRetail.text = NSLocalizedString("product_prices_vc_official_retail")
            _cell.lblRetailCurrency.text = CurrencyManager.shared.currencyName(countryCode ?? "")
            _cell.lblRetailPrice.text = CurrencyManager.shared.formattedPrice(price, nil, nil)
            _cell.lblEquivalent.text = NSLocalizedString("product_prices_vc_official_equivalent")
            _cell.lblEquivalentCurrency.text = CurrencyManager.shared.currencyName("CN")
            if let priceCNY = CurrencyManager.shared.equivalentCNYFromCurrency(countryCode, price: price) {
                _cell.lblEquivalentPrice.text = CurrencyManager.shared.formattedPrice(priceCNY, nil, nil)
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
        
        lblAccessory.text = NSLocalizedString("product_prices_vc_official_website")
    }
    
    override func prepareForReuse() {
        imgView.image = nil
        lblTitle.text = nil
    }
}

class ProductPricesTableViewCellCurrency: UITableViewCell {
    @IBOutlet var lblRetail: UILabel!
    @IBOutlet var lblRetailCurrency: UILabel!
    @IBOutlet var lblRetailPrice: UILabel!
    @IBOutlet var lblEquivalent: UILabel!
    @IBOutlet var lblEquivalentCurrency: UILabel!
    @IBOutlet var lblEquivalentPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblEquivalent.text = NSLocalizedString("product_prices_vc_official_equivalent")
    }
    
    override func prepareForReuse() {
        lblRetail.text = nil
        lblRetailCurrency.text = nil
        lblRetailPrice.text = nil
        lblEquivalent.text = nil
        lblEquivalentCurrency.text = nil
        lblEquivalentPrice.text = nil
    }
}