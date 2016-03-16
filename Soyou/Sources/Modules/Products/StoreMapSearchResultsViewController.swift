//
//  StoreMapSearchResultsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 20/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

protocol StoreMapSearchResultsViewControllerDelegate {
    
    func searchRegion() -> MKCoordinateRegion
    func didSelectSearchResult(mapItem: MKMapItem)
    
}

class StoreMapSearchResultsViewController: UITableViewController {
    
    var delegate: StoreMapSearchResultsViewControllerDelegate?
    var searchTimer: NSTimer?
    var searchText: String?
    var searchResults: [MKMapItem] = [MKMapItem]()
    
    // Class methods
    class func instantiate() -> StoreMapSearchResultsViewController {
        return (UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("StoreMapSearchResultsViewController") as? StoreMapSearchResultsViewController)!
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension StoreMapSearchResultsViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "StoreMapSearchResultsTableViewCell")
        
        let item = self.searchResults[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        // Address
        cell.detailTextLabel?.text = item.placemark.addressString()
        if let countryCode = item.placemark.countryCode, image = UIImage(flagImageWithCountryCode: countryCode) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(flagImageForSpecialFlag: .World)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.delegate?.didSelectSearchResult(self.searchResults[indexPath.row])
    }
}

// MARK: UISearchResultsUpdating
extension StoreMapSearchResultsViewController: UISearchResultsUpdating {
    
    func startSearchTimer() {
        stopSearchTimer()
        self.searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "searchAddress", userInfo: nil, repeats: false)
    }
    
    func stopSearchTimer() {
        self.searchTimer?.invalidate()
        self.searchTimer = nil
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.stopSearchTimer()
        
        if searchController.active {
            self.searchText = searchController.searchBar.text
        } else {
            self.searchText = nil
        }
        
        self.startSearchTimer()
    }
}

// MARK: Rountines
extension StoreMapSearchResultsViewController {
    
    func searchAddress() {
        let request = MKLocalSearchRequest()
        if let region = self.delegate?.searchRegion() {
            request.region = region
        }
        request.naturalLanguageQuery = self.searchText
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in
            if let mapItems = response?.mapItems {
                self.searchResults = mapItems
                self.tableView.reloadData()
            }
        }
    }
}

class StoreMapSearchResultsTableViewCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        lblTitle.text = nil
    }
}
