//
//  AddCrawlViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-06-04.
//  Copyright © 2018 Soyou. All rights reserved.
//

class AddCrawlViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate var didAddNewCrawlHandler: (()->())?
    
    var crawls: [Crawl]? {
        didSet {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
    // Class methods
    class func instantiate(_ didAddNewCrawlHandler: (()->())?) -> AddCrawlViewController {
        let vc = UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "AddCrawlViewController") as! AddCrawlViewController
        vc.didAddNewCrawlHandler = didAddNewCrawlHandler
        return vc
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Bars
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        self.title = NSLocalizedString("add_crawl_vc_title")
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setup refresh controls
        self.setupRefreshControls()
        
        // Setup Table
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Load data
        self.loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddCrawlViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func numberOfRows() -> Int {
        return self.crawls?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            let returnValue = numberOfRows()
            return returnValue == 0 ? 1 : returnValue
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditCrawlTableViewCell", for: indexPath)
            if let cell = cell as? EditCrawlTableViewCell {
                cell.textfield.placeholder = NSLocalizedString(indexPath.row == 0 ? "add_crawl_vc_placeholder_title" : "add_crawl_vc_placeholder_url")
            }
            return cell
        } else {
            let count = self.numberOfRows()
            if count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatusMessageTableViewCell", for: indexPath)
                if let cell = cell as? StatusMessageTableViewCell {
                    cell.lblTitle.text = NSLocalizedString(self.crawls == nil ? "add_crawl_vc_loading_data" : "add_crawl_vc_no_result")
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CrawlTableViewCell", for: indexPath)
                if let cell = cell as? CrawlTableViewCell, let crawl = self.crawls?[indexPath.row] {
                    cell.crawl = crawl
                    cell.tintColor = .gray
                    if crawl.isSelected ?? false {
                        cell.accessoryType = .checkmark
                        cell.isUserInteractionEnabled = false
                    } else {
                        cell.accessoryType = .none
                        cell.isUserInteractionEnabled = true
                    }
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("add_crawl_vc_section_title_custom")
        } else if section == 1 {
            return NSLocalizedString("add_crawl_vc_section_title_recommendations")
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 64
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1,
            indexPath.row < self.crawls?.count ?? 0,
            let crawl = self.crawls?[indexPath.row] else {
            return
        }
        submitCrawl(crawl.label, crawl.url)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

// MARK: - Refreshing
extension AddCrawlViewController {
    
    func setupRefreshControls() {
        guard let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData()
        }) else { return }
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle"), for: .idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling"), for: .pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing"), for: .refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        header.lastUpdatedTimeLabel?.isHidden = true
        self.tableView.mj_header = header
    }
    
    func beginRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.main.async {
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    func endRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        DispatchQueue.main.async {
            self.tableView.mj_header.endRefreshing()
        }
    }
}

// MARK: - Load data
extension AddCrawlViewController {
    
    func loadData() {
        DataManager.shared.getCrawlSuggestions { responseObject, error in
            if let responseObject = responseObject as? [Crawl] {
                self.crawls = responseObject
            }
            self.endRefreshing()
        }
    }
}

// MARK: - Actions
extension AddCrawlViewController {
    
    func submitCrawl(_ inTitle: String? = nil, _ inUrl: String? = nil) {
        MBProgressHUD.show(self.view)
        var _title = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditCrawlTableViewCell)?.textfield.text
        if let inTitle = inTitle {
            _title = inTitle
        }
        var _url = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditCrawlTableViewCell)?.textfield.text
        if let inUrl = inUrl {
            _url = inUrl
        }
        guard let title = _title, let url = _url else {
            return
        }
        DataManager.shared.addCrawl(title, url) { responseObject, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.didAddNewCrawlHandler?()
                    MBProgressHUD.hide(self.view)
                    self.dismissSelf()
                }
            }
        }
    }
    
    @IBAction func saveNewCrawl() {
        submitCrawl()
    }
}
