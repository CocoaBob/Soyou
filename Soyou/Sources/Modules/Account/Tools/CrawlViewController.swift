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
    
    var titleString: String?
    var urlString: String?
    var isBarsHidden = false
    
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
        
        // Title
        self.title = titleString
        if let urlString = urlString, let url = URL(string: urlString) {
            self.webview.loadRequest(URLRequest(url: url))
        }
        
        // Setup webview
        webview.scrollView.delegate = self
        webview.delegate = self
        
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return isBarsHidden
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
            hideBars(velocity.y > 0)
        }
    }
    
    func hideBars(_ isHidden: Bool) {
        self.navigationController?.setNavigationBarHidden(isHidden, animated: true)
        self.navigationController?.setToolbarHidden(isHidden, animated: true)
        isBarsHidden = isHidden
        self.setNeedsStatusBarAppearanceUpdate()
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
        
    }
}
