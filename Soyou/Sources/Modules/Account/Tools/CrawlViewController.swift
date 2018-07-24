//
//  CrawlViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-06-05.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import UIKit

class CrawlViewController: UIViewController {
    
    @IBOutlet var webview: UIWebView!
    @IBOutlet var goBackBarButtonItem: UIBarButtonItem!
    @IBOutlet var goForwardBarButtonItem: UIBarButtonItem!
    @IBOutlet var refreshBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var toolbar: UIView!
    @IBOutlet var toolbarSeparatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet var toolbarBottomConstraint: NSLayoutConstraint!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var crawlButton: UIButton!
    
    var titleString: String?
    var urlString: String?
    var isStatusBarHidden = false
    
    // KVO Context
    fileprivate var KVOContextCrawlViewController = 0
    
    // Class methods
    class func instantiate(_ titleString: String?, _ urlString: String?) -> CrawlViewController {
        let vc = UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "CrawlViewController") as! CrawlViewController
        vc.titleString = titleString
        vc.urlString = urlString
        return vc
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Title
        self.title = titleString
        if let urlString = urlString, let url = URL(string: urlString) {
            self.webview.loadRequest(URLRequest(url: url))
        }
        
        // Setup webview
        webview.scrollView.delegate = self
        webview.delegate = self
        
        // Steup toolbar
        toolbarSeparatorHeightConstraint.constant = 1 / UIScreen.main.scale
        favoriteButton.addTarget(self, action: #selector(bookmarkThisPage), for: .touchUpInside)
        favoriteButton.setTitle(NSLocalizedString("crawl_vc_favorite_button"), for: .normal)
        crawlButton.addTarget(self, action: #selector(grabImages), for: .touchUpInside)
        crawlButton.setTitle(NSLocalizedString("crawl_vc_crawl_button"), for: .normal)
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

// MARK: - Bar and buttons
extension CrawlViewController {
    
    func updateUI() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = webview.isLoading
        refreshBarButtonItem.image = UIImage(named: webview.isLoading ? "img_web_stop" : "img_web_refresh")
        goBackBarButtonItem.isEnabled = webview.canGoBack
        goForwardBarButtonItem.isEnabled = webview.canGoForward
    }
}

// MARK: - UIWebViewDelegate
extension CrawlViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        updateUI()
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        updateUI()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        updateUI()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        updateUI()
    }
}

// MARK: - UIScrollViewDelegate
extension CrawlViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (fabs(velocity.y) > 0) {
            setFullScreen(velocity.y > 0)
        }
    }
    
    func setFullScreen(_ isFullScreen: Bool) {
        isStatusBarHidden = isFullScreen
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(isFullScreen, animated: true)
        self.toolbarBottomConstraint.constant = isFullScreen ? -44 : 0
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: Web Images
extension CrawlViewController {
    
    func showImagesViewController() {
        if let imgURLs = webview.allImgURLs() {
            // Prepare TLPHAsset
            var assets = [TLPHAsset]()
            for url in imgURLs {
                if let imageURL = URL(string: url) {
                    if let imageResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageURL)),
                        let image = UIImage(data: imageResponse.data) {
                        assets.append(TLPHAsset(image: image))
                    } else {
                        assets.append(TLPHAsset(url: imageURL))
                    }
                }
            }
            self.createCircle(assets)
        }
    }
}

// MARK: - Create a circle
extension CrawlViewController: CircleComposeViewControllerDelegate {
    
    func createCircle(_ assets: [TLPHAsset]) {
        let vc = CircleComposeViewController.instantiate()
        vc.customAssets = assets
        vc.isSharing = true
        vc.visibility = CircleVisibility.friends
        vc.isPublicDisabled = !UserManager.shared.hasCurrentUserBadges
        vc.delegate = self
        let navC = UINavigationController(rootViewController: vc)
        self.present(navC, animated: true, completion: nil)
    }
    
    func didDismiss(text: String?, images: [UIImage]?, needsToShare: Bool) {
        if needsToShare {
            Utils.copyTextAndShareImages(from: self, text: text, images: images)
        }
    }
}

extension CrawlViewController {
    
    @IBAction func goBack() {
        if webview.canGoBack {
            webview.goBack()
        }
    }
    
    @IBAction func goForward() {
        if webview.canGoForward {
            webview.goForward()
        }
    }
    
    @IBAction func refreshOrStop() {
        if webview.isLoading {
            webview.stopLoading()
        } else {
            webview.reload()
        }
    }
    
    @IBAction func bookmarkThisPage() {
        let title = webview.stringByEvaluatingJavaScript(from: "document.title")
        let url = webview.request?.mainDocumentURL?.absoluteString
        let vc = AddCrawlViewController.instantiate(title, url, false)
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @IBAction func grabImages() {
        showImagesViewController()
    }
}
