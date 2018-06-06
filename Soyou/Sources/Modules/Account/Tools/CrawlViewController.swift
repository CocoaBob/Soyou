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
    
    var titleString: String?
    var urlString: String?
    
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
    }
}

extension CrawlViewController {
    
    @IBAction func action() {
        if let urlString = urlString, let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true, completion: nil)
        }
    }
}
