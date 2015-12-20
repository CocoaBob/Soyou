//
//  UserViewController.swift
//  iPrices
//
//  Created by CocoaBob on 19/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class UserViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    var isKeyboardVisible: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("user_vc_title", comment: "")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "img_tab_user"), selectedImage: UIImage(named: "img_tab_user_selected"))
        self.tabBarItem.title = NSLocalizedString("user_vc_tab_title", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nav bar button items
        self.updateNavBarButtonItems()
        
        // Register Keyboard notifications
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { (n) -> Void in
            self.isKeyboardVisible = true
            self.updateNavBarButtonItems()
        }
        defaultCenter.addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { (n) -> Void in
            self.isKeyboardVisible = false
            self.updateNavBarButtonItems()
        }
    }
}

// MARK: Routines
extension UserViewController {
    
    func updateNavBarButtonItems() {
        var leftBarButtonItem: UIBarButtonItem? = nil
        var rightBarButtonItem: UIBarButtonItem? = nil
        if UserManager.shared.isAuthenticated() {
            leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_user"), style: .Plain, target: self, action: "showSettings:")
        }
        if self.isKeyboardVisible {
            rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissKeyboard")
        } else {
            rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_gear"), style: .Plain, target: self, action: "showSettings:")
        }
        UIView.setAnimationsEnabled(false)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        UIView.setAnimationsEnabled(true)
    }
}

// MARK: Actions
extension UserViewController {
    
    func showSettings(sender: UIBarButtonItem) {
        print("\(__FUNCTION__)")
    }
}