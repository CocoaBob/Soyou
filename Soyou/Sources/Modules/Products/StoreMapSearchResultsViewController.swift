//
//  StoreMapSearchResultsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 20/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

protocol StoreMapSearchResultsViewControllerDelegate {
    
    func searchRegion() -> MKCoordinateRegion
    func didSelectSearchResult(_ mapItem: MKMapItem)
    
}

class StoreMapSearchResultsViewController: UITableViewController {
    
    var delegate: StoreMapSearchResultsViewControllerDelegate?
    var searchTimer: Timer?
    var searchText: String?
    var searchResults: [MKMapItem] = [MKMapItem]()
    
    // Class methods
    class func instantiate() -> StoreMapSearchResultsViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewController(withIdentifier: "StoreMapSearchResultsViewController") as! StoreMapSearchResultsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension StoreMapSearchResultsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "StoreMapSearchResultsTableViewCell")
        
        let item = self.searchResults[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        // Address
        cell.detailTextLabel?.text = item.placemark.addressString()
        if let countryCode = item.placemark.countryCode, let image = Flag(countryCode: countryCode)?.image(style: .roundedRect) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.didSelectSearchResult(self.searchResults[indexPath.row])
    }
}

// MARK: UISearchResultsUpdating
extension StoreMapSearchResultsViewController: UISearchResultsUpdating {
    
    func startSearchTimer() {
        stopSearchTimer()
        self.searchTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(StoreMapSearchResultsViewController.searchAddress), userInfo: nil, repeats: false)
    }
    
    func stopSearchTimer() {
        self.searchTimer?.invalidate()
        self.searchTimer = nil
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.stopSearchTimer()
        
        if searchController.isActive {
            self.searchText = searchController.searchBar.text
        } else {
            self.searchText = nil
        }
        
        self.startSearchTimer()
    }
}

// MARK: Rountines
extension StoreMapSearchResultsViewController {
    
    @objc func searchAddress() {
        let request = MKLocalSearchRequest()
        if let region = self.delegate?.searchRegion() {
            request.region = region
        }
        request.naturalLanguageQuery = self.searchText
        let search = MKLocalSearch(request: request)
        search.start { (response: MKLocalSearchResponse?, error: Error?) -> Void in
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
        super.prepareForReuse()
        lblTitle.text = nil
    }
}
