//
//  ActionViewController.swift
//  ImagesGrabber
//
//  Created by CocoaBob on 2018-05-25.
//  Copyright © 2018 Soyou. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var imgUrls: [String]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    
        // Get data from JavaScript
        guard let inputItems = self.extensionContext?.inputItems as? [NSExtensionItem] else { return }
        for inputItem in inputItems {
            guard let attachments = inputItem.attachments else { return }
            for attachment in attachments {
                guard let itemProvider = attachment as? NSItemProvider else { return }
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String, options: nil) { (item, error) in
                        if let dictionary = item as? Dictionary<String, Any>,
                            let jsData = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                            let imgUrls = jsData["imgs"] as? [String] {
                            self.imgUrls = imgUrls
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}

//// MARK: - UITableViewDataSource, UITableViewDelegate
extension ActionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgUrls?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionTableViewCell", for: indexPath)
        
        cell.textLabel?.text = imgUrls?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
