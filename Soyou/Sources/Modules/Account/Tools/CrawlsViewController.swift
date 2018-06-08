//
//  CrawlsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-06-03.
//  Copyright © 2018 Soyou. All rights reserved.
//

class CrawlsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    var crawls: [Crawl]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // Class methods
    class func instantiate() -> CrawlsViewController {
        return UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "CrawlsViewController") as! CrawlsViewController
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
        title = NSLocalizedString("crawls_vc_title")
        
        // Fix scroll view insets
        updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setup refresh controls
        setupRefreshControls()
        
        // Setup Table
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Load data
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CrawlsViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func numberOfRows() -> Int {
        return self.crawls?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let returnValue = numberOfRows()
        return returnValue == 0 ? 1 : returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = self.numberOfRows()
        if count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusMessageTableViewCell", for: indexPath)
            if let cell = cell as? StatusMessageTableViewCell {
                cell.lblTitle.text = NSLocalizedString(self.crawls == nil ? "crawls_vc_loading_data" : "crawls_vc_no_result")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CrawlTableViewCell", for: indexPath)
            if let cell = cell as? CrawlTableViewCell, let crawl = self.crawls?[indexPath.row] {
                cell.crawl = crawl
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < self.crawls?.count ?? 0 else {
            return
        }
        guard let crawl = self.crawls?[indexPath.row] else {
            return
        }
        let vc = CrawlViewController.instantiate(crawl.label, crawl.url)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let crawl = self.crawls?[indexPath.row], let crawlId = crawl.id {
            MBProgressHUD.show(self.view)
            DataManager.shared.deleteCrawl(crawlId, { (responseObject, error) in
                MBProgressHUD.hide(self.view)
                if error == nil {
                    self.tableView.beginUpdates()
                    self.crawls?.remove(at: indexPath.row)
                    if self.crawls?.count ?? 0 == 0 {
                        self.tableView.reloadData()
                    } else {
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                    self.tableView.endUpdates()
                }
            })
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

// MARK: - Refreshing
extension CrawlsViewController {
    
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
extension CrawlsViewController {
    
    func loadData() {
        DataManager.shared.getCrawls() { responseObject, error in
            if let responseObject = responseObject as? [Crawl] {
                self.crawls = responseObject
            }
            self.endRefreshing()
        }
    }
}

// MARK: - Actions
extension CrawlsViewController {
    
    @IBAction func addNewCrawl() {
        let vc = AddCrawlViewController.instantiate()
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}
