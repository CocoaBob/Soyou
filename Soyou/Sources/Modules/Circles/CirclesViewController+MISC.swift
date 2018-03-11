//
//  CirclesViewController+MISC.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-20.
//  Copyright © 2018 Soyou. All rights reserved.
//

// MARK: - Status Bar Cover
extension CirclesViewController {
    
    func setupStatusBarCover() {
        // Status Bar Cover
        self.statusBarCover.backgroundColor = UIColor.white
    }
    
    func updateStatusBarCover(_ offsetY: CGFloat) {
        if isStatusBarCoverVisible && offsetY < 0 {
            self.removeStatusBarCover()
        } else if !isStatusBarCoverVisible && offsetY >= 0 {
            self.addStatusBarCover()
        }
    }
    
    func addStatusBarCover() {
        self.isStatusBarCoverVisible = true
        self.tabBarController?.view.addSubview(self.statusBarCover)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 1
        })
    }
    
    func removeStatusBarCover() {
        self.isStatusBarCoverVisible = false
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 0
        }, completion: { (finished) -> Void in
            self.statusBarCover.removeFromSuperview()
        })
    }
}

// MARK: - Parallax Header
extension CirclesViewController {
    
    func setupParallaxHeader() {
        // Parallax View
        self.tableView().parallaxHeader.height = self.parallaxHeaderView.frame.height
        self.tableView().parallaxHeader.view = self.parallaxHeaderView
        self.tableView().parallaxHeader.mode = .fill
    }
}

// MARK: - Pull Down Refresh
extension CirclesViewController {
    
    func updateRefreshIndicator(_ offsetY: CGFloat) {
        struct Constant {
            static let headerHeight = CGFloat(240)
            static let triggerY = CGFloat(-40)
        }
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let offsetY = offsetY + statusBarHeight + Constant.headerHeight
        self.showRefreshIndicator(offsetY)
        
        if !self.isLoadingData && !self.tableView().isDragging && offsetY <= Constant.triggerY {
            self.loadData(nil, completion: nil)
        }
    }
    
    func showRefreshIndicator(_ offsetY: CGFloat) {
        struct Constant {
            static let triggerY = CGFloat(-38)
        }
        UIView.animate(withDuration: 0.3) {
            if self.isLoadingData {
                self.loadingIndicatorBottom.constant = Constant.triggerY
            } else {
                self.loadingIndicatorBottom.constant = max(offsetY, Constant.triggerY)
                self.loadingIndicator.transform = CGAffineTransform(rotationAngle: offsetY / 20.0)
            }
        }
    }
    
    func hideRefreshIndicator() {
        UIView.animate(withDuration: 0.3) {
            self.loadingIndicatorBottom.constant = UIApplication.shared.statusBarFrame.height
        }
    }
}

// MARK: - Refreshing
extension CirclesViewController {
    
    func setupRefreshControls() {
        guard let footer = MJRefreshAutoStateFooter(refreshingBlock: { () -> Void in
            self.loadNextData()
        }) else { return }
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), for: .idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), for: .pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), for: .refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        self.tableView().mj_footer = footer
    }
    
    func beginRefreshing() {
        self.isLoadingData = true
        self.loadingIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endRefreshing(_ resultCount: Int) {
        self.hideRefreshIndicator()
        DispatchQueue.main.async {
            resultCount > 0 ? self.tableView().mj_footer.endRefreshing() : self.tableView().mj_footer.endRefreshingWithNoMoreData()
        }
        self.isLoadingData = false
        self.loadingIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func showNoDataMessage() {
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("circles_vc_no_data"), for: .noMoreData)
    }
    
    func showLoadingMessage() {
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("circles_vc_loading"), for: .idle)
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("circles_vc_loading"), for: .noMoreData)
    }
    
    func resetFooterMessage() {
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), for: .idle)
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
    }
}

// MARK: - Single User Mode
extension CirclesViewController {
    
    func clearAllCirclesOfCurrentUser() {
        self.singleUserMemCtx().save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            Circle.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
        })
    }
}
