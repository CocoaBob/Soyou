//
//  ProductPricesViewController.swift
//  iPrices
//
//  Created by CocoaBob on 14/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

class ProductPricesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var prices: NSDictionary? //[ { "country": "法国", "price": 1450 } ]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let item = prices[indexPath.section] else { return UITableViewCell() }
        
        let country = item["country"] as! String
        let price = item["price"] as! NSNumber
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            let _cell = tableView.dequeueReusableCellWithIdentifier("ProductPricesTableViewCellCountry", forIndexPath: indexPath) as! ProductPricesTableViewCellCountry
            
            _cell.imgView.image = UIImage(named: "")
            let countryNameCode = FmtString("country_name_%@",country)
            _cell.lblTitle.text = FmtString(NSLocalizedString("product_prices_vc_official_price"), NSLocalizedString(countryNameCode))
            cell = _cell
        } else {
            let _cell = tableView.dequeueReusableCellWithIdentifier("ProductPricesTableViewCellCurrency", forIndexPath: indexPath) as! ProductPricesTableViewCellCurrency
            
            _cell.lblPrice.text = "\(price)"
            _cell.lblPriceCNY.text = "\(price)"
            
            cell = _cell
        }
        
        return cell!
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
    @IBOutlet var lblPriceCNY: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    override func prepareForReuse() {
        lblPrice.text = nil
        lblPriceCNY.text = nil
    }
}