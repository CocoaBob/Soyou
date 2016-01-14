//
//  ProductDescriptionsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 14/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

class ProductDescriptionsViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    var descriptions: String? {
        didSet {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIViewController
        self.title = NSLocalizedString("product_descriptions_vc_title")
        
        // Web View
        self.webView.scrollView.scrollEnabled = false
        
        // Load Content
        if let descriptions = self.descriptions {
            self.webView.loadHTMLString(descriptions, baseURL: nil)
        } else {
            self.webView.loadHTMLString(NSLocalizedString("product_descriptions_vc_empty"), baseURL: nil)
        }
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

// MARK: UIWebViewDelegate
extension ProductDescriptionsViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
}