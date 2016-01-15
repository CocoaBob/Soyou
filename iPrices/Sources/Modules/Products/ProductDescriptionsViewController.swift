//
//  ProductDescriptionsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 14/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

class ProductDescriptionsViewController: UIViewController {
    let lineTemplate: String = "<div class=\"row clearfix\">" +
                                    "<div class=\"key\">__KEY__</div>" +
                                    "<div class=\"value\">__VALUE__</div>" +
                                "</div>"
    
    @IBOutlet var webView: UIWebView!
    
    var descriptions: String? {
        didSet {
            
        }
    }
    
    var surname: String?
    var brand: String?
    var reference: String?
    
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
        var htmlContent: String = ""
        var cssContent: String?

        if let surname = self.surname {
            htmlContent = lineTemplate.stringByReplacingOccurrencesOfString("__KEY__", withString: NSLocalizedString("product_surname")).stringByReplacingOccurrencesOfString("__VALUE__", withString: surname)
        }else{
            htmlContent = lineTemplate.stringByReplacingOccurrencesOfString("__KEY__", withString: NSLocalizedString("product_surname")).stringByReplacingOccurrencesOfString("__VALUE__", withString: NSLocalizedString("product_unavailable"))
        }
        
        if let brand = self.brand {
            htmlContent = htmlContent + lineTemplate.stringByReplacingOccurrencesOfString("__KEY__", withString: NSLocalizedString("product_brand")).stringByReplacingOccurrencesOfString("__VALUE__", withString: brand)
        }else{
            htmlContent = htmlContent + lineTemplate.stringByReplacingOccurrencesOfString("__KEY__", withString: NSLocalizedString("product_brand")).stringByReplacingOccurrencesOfString("__VALUE__", withString: NSLocalizedString("product_unavailable"))
        }
        
        if let reference = self.reference {
            htmlContent = htmlContent + lineTemplate.stringByReplacingOccurrencesOfString("__KEY__", withString: NSLocalizedString("product_reference")).stringByReplacingOccurrencesOfString("__VALUE__", withString: reference)
        }else{
            htmlContent = htmlContent + lineTemplate.stringByReplacingOccurrencesOfString("__KEY__", withString: NSLocalizedString("product_reference")).stringByReplacingOccurrencesOfString("__VALUE__", withString: NSLocalizedString("product_unavailable"))
        }
        
        if let descriptions = self.descriptions {
            htmlContent = htmlContent + lineTemplate.stringByReplacingOccurrencesOfString("__KEY__", withString: NSLocalizedString("product_descriptions")).stringByReplacingOccurrencesOfString("__VALUE__", withString: descriptions)
        }else{
            htmlContent = htmlContent + lineTemplate.stringByReplacingOccurrencesOfString("__KEY__", withString: NSLocalizedString("product_descriptions")).stringByReplacingOccurrencesOfString("__VALUE__", withString: NSLocalizedString("product_unavailable"))
        }
        
        if htmlContent == "" {
            htmlContent = NSLocalizedString("product_descriptions_vc_empty")
        }
        
        var html: String?
        do {
            cssContent = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("productDescription", ofType: "css")!)
            html = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("productDescription", ofType: "html")!)
        } catch {
                        
        }
        
        if let cssContent = cssContent, var html = html {
            html = html.stringByReplacingOccurrencesOfString("__CONTENT__", withString: htmlContent)
            html = html.stringByReplacingOccurrencesOfString("__CSS__", withString: cssContent)
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }
}

// MARK: UIWebViewDelegate
extension ProductDescriptionsViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
}