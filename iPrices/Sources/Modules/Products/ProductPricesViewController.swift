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
    var currencyRates: [CurrencyRate]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.currencyRates = CurrencyManager.shared.fetchCurrencyRates()
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

// MARK: Utility methods
extension ProductPricesViewController{
    private func getRateBySourceCode(sourceCode: String) -> CurrencyRate?{
        for rate in self.currencyRates!{
            if let code = rate.sourceCode {
                if sourceCode.caseInsensitiveCompare(code) == .OrderedSame{
                    return rate
                }
            }
        }
        
        return nil
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
        
        let country = item["country"] as! String
        let price = item["price"] as! NSNumber
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            let _cell = tableView.dequeueReusableCellWithIdentifier("ProductPricesTableViewCellCountry", forIndexPath: indexPath) as! ProductPricesTableViewCellCountry
            
            if let countryCode = CountryCode[country], image = UIImage(flagImageWithCountryCode: countryCode) {
                _cell.imgView.image = image
            } else {
                _cell.imgView.image = UIImage(flagImageForSpecialFlag: .World)
            }
            let countryNameCode = FmtString("country_name_%@",country)
            _cell.lblTitle.text = FmtString(NSLocalizedString("product_prices_vc_official_price"), NSLocalizedString(countryNameCode))
            cell = _cell
        } else {
            let _cell = tableView.dequeueReusableCellWithIdentifier("ProductPricesTableViewCellCurrency", forIndexPath: indexPath) as! ProductPricesTableViewCellCurrency
            
            if let sourceCurrencyCode = CurrencyCode[country], rate = self.getRateBySourceCode(sourceCurrencyCode) {
                    _cell.lblPriceCNY.text = "\(Int(round(price.doubleValue * (rate.rate?.doubleValue)!)))"
            }else{
                _cell.lblPriceCNY.text = NSLocalizedString("unavailable")
            }
            
            _cell.lblPrice.text = "\(price)"
            
            
            cell = _cell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        } else {
            return 32
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
        lblAccessory.text = NSLocalizedString("product_prices_vc_official_website")
    }
    
    override func prepareForReuse() {
        imgView.image = nil
        lblTitle.text = nil
    }
}

class ProductPricesTableViewCellCurrency: UITableViewCell {
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblEquivalent: UILabel!
    @IBOutlet var lblPriceCNY: UILabel!
    
    override func awakeFromNib() {
        lblEquivalent.text = NSLocalizedString("product_prices_vc_official_equivalent")
    }
    
    override func prepareForReuse() {
        lblPrice.text = nil
        lblPriceCNY.text = nil
    }
}