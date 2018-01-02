//
//  ProductDescriptionsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 14/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

protocol WebViewHeightDelegate {
    func webView(_ webView: UIWebView, didChangeHeight height: CGFloat)
}

class ProductDescriptionsViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    var webViewHeightDelegate: WebViewHeightDelegate?
    
    weak var productViewController: ProductViewController?
    
    var product: Product? {
        didSet {
            self.product?.managedObjectContext?.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                guard let localProduct = self.product?.mr_(in: localContext) else { return }
                self.descriptions = localProduct.descriptions
                self.surname = localProduct.surname
                self.brand = localProduct.brandLabel
                self.reference = localProduct.reference
                self.dimension = localProduct.dimension
                self.id = localProduct.id as? Int
            })
            
            // Load Content
            loadContent()
        }
    }
    var descriptions: String?
    var surname: String?
    var brand: String?
    var reference: String?
    var id: Int?
    var descriptionZH: String?
    var isDisplayingTranslatedText = false
    var dimension: String?
    
    // Class methods
    class func instantiate() -> ProductDescriptionsViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewController(withIdentifier: "ProductDescriptionsViewController") as! ProductDescriptionsViewController
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
        self.webView.scrollView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

// MARK: Data
extension ProductDescriptionsViewController {

    // Load HTML
    fileprivate func loadContent() {
        var cssContent: String?
        var htmlContent: String = ""
        
        do {
            cssContent = try String(contentsOfFile: Bundle.main.path(forResource: "productDescription", ofType: "css")!)
            htmlContent = try String(contentsOfFile: Bundle.main.path(forResource: "productDescription", ofType: "html")!)
        } catch {
            
        }
        
        if let cssContent = cssContent {
            htmlContent = htmlContent.replacingOccurrences(of: "__KEY__SURNAME__", with: NSLocalizedString("product_surname")).replacingOccurrences(of: "__KEY__BRAND__", with: NSLocalizedString("product_brand")).replacingOccurrences(of: "__KEY__REFERENCE__", with: NSLocalizedString("product_reference")).replacingOccurrences(of: "__KEY__DESCRIPTION__", with: NSLocalizedString("product_descriptions")).replacingOccurrences(of: "__KEY__DIMENSION__", with: NSLocalizedString("product_dimension"))
            
            let stringUnavailable = NSLocalizedString("product_unavailable")
            htmlContent = htmlContent.replacingOccurrences(of: "__VALUE__SURNAME__", with: self.surname ?? stringUnavailable)
            htmlContent = htmlContent.replacingOccurrences(of: "__VALUE__BRAND__", with: self.brand ?? stringUnavailable)
            htmlContent = htmlContent.replacingOccurrences(of: "__VALUE__REFERENCE__", with: self.reference ?? stringUnavailable)
            htmlContent = htmlContent.replacingOccurrences(of: "__VALUE__DIMENSION__", with: self.dimension ?? stringUnavailable)
            htmlContent = htmlContent.replacingOccurrences(of: "__VALUE__DESCRIPTION__", with: self.descriptions ?? stringUnavailable)
            htmlContent = htmlContent.replacingOccurrences(of: "__CSS__", with: cssContent)
        }
        
        if htmlContent == "" {
            htmlContent = NSLocalizedString("product_descriptions_vc_empty")
        }
        
        self.webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

// MARK: Routines
extension ProductDescriptionsViewController {
    
    func reloadData() {
        self.loadContent()
    }
}


// MARK: UIWebViewDelegate
extension ProductDescriptionsViewController: UIWebViewDelegate {
    
    fileprivate func updateWebViewHeight(_ webView: UIWebView) {
        if let heightStr = webView.stringByEvaluatingJavaScript(from: "document.getElementById('main').offsetHeight") {
            let heightFloat = CGFloat((heightStr as NSString).floatValue)
            if let delegate = self.webViewHeightDelegate {
                delegate.webView(self.webView, didChangeHeight: heightFloat)
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let js = "document.getElementById('btn-translation').addEventListener('click', function() { window.location.href = 'inapp://translate'});"
        webView.stringByEvaluatingJavaScript(from: js)
        
        // Update web view height
        updateWebViewHeight(webView)
    }
    
    fileprivate func toggleTranslationState(_ webView: UIWebView) {
        MBProgressHUD.show(self.productViewController?.view)
        if self.isDisplayingTranslatedText {
            let js = "document.getElementById('descriptionZH').className = 'hide';document.getElementById('description').className = '';document.getElementById('btn-translation').innerHTML = '\(NSLocalizedString("product_translation"))'"
            webView.stringByEvaluatingJavaScript(from: js)
            updateWebViewHeight(webView)
            self.isDisplayingTranslatedText = false
            MBProgressHUD.hide(self.productViewController?.view)
        } else {
            if let _ = self.descriptionZH {
                let js = "document.getElementById('description').className = 'hide';document.getElementById('descriptionZH').className = '';document.getElementById('btn-translation').innerHTML = '\(NSLocalizedString("product_back"))'"
                webView.stringByEvaluatingJavaScript(from: js)
                updateWebViewHeight(webView)
                self.isDisplayingTranslatedText = true
                MBProgressHUD.hide(self.productViewController?.view)
            } else {
                DataManager.shared.translateProduct(self.id!) { responseObject, error in
                    defer {
                        MBProgressHUD.hide(self.productViewController?.view)
                    }
                    if let responseObject = responseObject as? [String:AnyObject],
                        let data = responseObject["data"] as? [String:AnyObject],
                        let translation = data["descriptions"] as? String {
                        self.descriptionZH = translation
                        let js = "document.getElementById('description').className = 'hide';document.getElementById('descriptionZH').className = '';document.getElementById('descriptionZH').innerHTML = '\(translation)';document.getElementById('btn-translation').innerHTML = '\(NSLocalizedString("product_back"))'"
                        webView.stringByEvaluatingJavaScript(from: js)
                    }
                    self.updateWebViewHeight(webView)
                    self.isDisplayingTranslatedText = true
                }
            }
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url, let scheme = url.scheme {
            if "inapp".caseInsensitiveCompare(scheme) == .orderedSame {
                if "translate".caseInsensitiveCompare(url.host!) == .orderedSame {
                    toggleTranslationState(webView)
                }
                return false
            }
        }
        return true
    }
}
