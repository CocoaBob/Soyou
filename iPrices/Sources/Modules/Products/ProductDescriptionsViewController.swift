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
    
    var surname: String?
    var brand: String?
    var reference: String?
    var id: NSNumber?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Web View
        self.webView.scrollView.scrollEnabled = false
        
        // Load Content
        loadContent()
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
// MARK: Data
extension ProductDescriptionsViewController {

    // Load HTML
    private func loadContent() {
        var cssContent: String?
        var htmlContent: String = ""
        
        do {
            cssContent = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("productDescription", ofType: "css")!)
            htmlContent = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("productDescription", ofType: "html")!)
        } catch {
            
        }
        
        if let cssContent = cssContent {
            htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__KEY__SURNAME__", withString: NSLocalizedString("product_surname")).stringByReplacingOccurrencesOfString("__KEY__BRAND__", withString: NSLocalizedString("product_brand")).stringByReplacingOccurrencesOfString("__KEY__REFERENCE__", withString: NSLocalizedString("product_reference")).stringByReplacingOccurrencesOfString("__KEY__DESCRIPTION__", withString: NSLocalizedString("product_descriptions"))
            
            if let surname = self.surname {
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__SURNAME__", withString: surname)
            }else{
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__SURNAME__", withString: NSLocalizedString("product_unavailable"))
            }
            
            if let brand = self.brand {
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__BRAND__", withString: brand)
            }else{
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__BRAND__", withString: NSLocalizedString("product_unavailable"))
            }
            
            if let reference = self.reference {
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__REFERENCE__", withString: reference)
            }else{
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__REFERENCE__", withString: NSLocalizedString("product_unavailable"))
            }
            
            if let descriptions = self.descriptions {
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__DESCRIPTION__", withString: descriptions).stringByReplacingOccurrencesOfString("__BTN_TRANSLATION__", withString: "<div><button id=\"btn-translation\">\(NSLocalizedString("product_translation"))</button></div>")
            }else{
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__DESCRIPTION__", withString: NSLocalizedString("product_unavailable"))
            }
            
            htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__CSS__", withString: cssContent)
        }
        
        if htmlContent == "" {
            htmlContent = NSLocalizedString("product_descriptions_vc_empty")
        }
        
        self.webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}


// MARK: UIWebViewDelegate
extension ProductDescriptionsViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let js = "document.getElementById('btn-translation').addEventListener('click', function(){ window.location.href = 'inapp://translate'});"
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        if let url = request.URL{
            if ("inapp".caseInsensitiveCompare(url.scheme) == .OrderedSame) {
                if ("translate".caseInsensitiveCompare(url.host!) == .OrderedSame) {
                    MBProgressHUD.showLoader(self.view)
                    DataManager.shared.translateProduct(self.id!,
                        { (data: AnyObject?) in
                            if let data = data {
                                if let translation = data["descriptions"] as? String {
                                    let js = "document.getElementById('description').innerHTML = '\(translation)'"
                                    webView.stringByEvaluatingJavaScriptFromString(js)
                                }
                            }
                            
                            MBProgressHUD.hideLoader(self.view)
                        })
                }
                false;
            }
        }
        return true
    }
}