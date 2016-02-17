//
//  ProductDescriptionsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 14/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

protocol WebViewHeightDelegate {
    func webView(webView: UIWebView, didChangeHeight height: CGFloat)
}

class ProductDescriptionsViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    var webViewHeightDelegate: WebViewHeightDelegate?
    
    var productViewController: ProductViewController?
    
    var descriptions: String? {
        didSet {
            
        }
    }
    
    var surname: String?
    var brand: String?
    var reference: String?
    var id: NSNumber?
    var descriptionZH: String?
    var isDisplayingTranslatedText = false
    var dimension: String?
    
    // Class methods
    class func instantiate() -> ProductDescriptionsViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("ProductDescriptionsViewController") as! ProductDescriptionsViewController
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = true
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
            htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__KEY__SURNAME__", withString: NSLocalizedString("product_surname")).stringByReplacingOccurrencesOfString("__KEY__BRAND__", withString: NSLocalizedString("product_brand")).stringByReplacingOccurrencesOfString("__KEY__REFERENCE__", withString: NSLocalizedString("product_reference")).stringByReplacingOccurrencesOfString("__KEY__DESCRIPTION__", withString: NSLocalizedString("product_descriptions")).stringByReplacingOccurrencesOfString("__KEY__DIMENSION__", withString: NSLocalizedString("product_dimension"))
            
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
            
            if let dimension = self.dimension {
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__DIMENSION__", withString: dimension)
            }else{
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__VALUE__DIMENSION__", withString: NSLocalizedString("product_unavailable"))
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
    
    private func updateWebViewHeight(webView: UIWebView){
        if let heightStr = webView.stringByEvaluatingJavaScriptFromString("document.getElementById('main').offsetHeight") {
            let heightFloat = CGFloat((heightStr as NSString).floatValue)
            if let delegate = self.webViewHeightDelegate {
                delegate.webView(self.webView, didChangeHeight: heightFloat)
            }
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let js = "document.getElementById('btn-translation').addEventListener('click', function(){ window.location.href = 'inapp://translate'});"
        webView.stringByEvaluatingJavaScriptFromString(js)
        
        // Update web view height
        updateWebViewHeight(webView)
    }
    
    private func toggleTranslationState(webView: UIWebView) {
        MBProgressHUD.showLoader(self.productViewController?.view)
        if self.isDisplayingTranslatedText {
            let js = "document.getElementById('descriptionZH').className = 'hide';document.getElementById('description').className = '';document.getElementById('btn-translation').innerHTML = '\(NSLocalizedString("product_translation"))'"
            webView.stringByEvaluatingJavaScriptFromString(js)
            updateWebViewHeight(webView)
            self.isDisplayingTranslatedText = false
            MBProgressHUD.hideLoader(self.productViewController?.view)
        } else{
            if let _ = self.descriptionZH {
                let js = "document.getElementById('description').className = 'hide';document.getElementById('descriptionZH').className = '';document.getElementById('btn-translation').innerHTML = '\(NSLocalizedString("product_back"))'"
                webView.stringByEvaluatingJavaScriptFromString(js)
                updateWebViewHeight(webView)
                self.isDisplayingTranslatedText = true
                MBProgressHUD.hideLoader(self.productViewController?.view)
            } else {
                DataManager.shared.translateProduct(self.id!) { responseObject, error in
                    defer {
                        MBProgressHUD.hideLoader(self.productViewController?.view)
                    }
                    guard let data = responseObject?["data"] else { return }
                    if let data = data {
                        if let translation = data["descriptions"] as? String {
                            self.descriptionZH = translation
                            let js = "document.getElementById('description').className = 'hide';document.getElementById('descriptionZH').className = '';document.getElementById('descriptionZH').innerHTML = '\(translation)';document.getElementById('btn-translation').innerHTML = '\(NSLocalizedString("product_back"))'"
                            webView.stringByEvaluatingJavaScriptFromString(js)
                        }
                    }
                    self.updateWebViewHeight(webView)
                    self.isDisplayingTranslatedText = true
                }
            }
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        if let url = request.URL{
            if "inapp".caseInsensitiveCompare(url.scheme) == .OrderedSame {
                if "translate".caseInsensitiveCompare(url.host!) == .OrderedSame {
                    toggleTranslationState(webView);
                }
                
                return false
            }
        }
        return true
    }
}