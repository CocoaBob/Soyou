//
//  UserViewController.swift
//  iPrices
//
//  Created by CocoaBob on 19/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class UserViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("user_vc_title", comment: "")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "img_tab_user"), selectedImage: UIImage(named: "img_tab_user_selected"))
        self.tabBarItem.title = NSLocalizedString("user_vc_tab_title", comment: "")
        
        // Notifications of isLoggedIn
        NSNotificationCenter.defaultCenter().addObserverForName(Cons.Usr.IsLoggedInDidChangeNotification, object: nil, queue: nil) { (n) -> Void in
            self.updateNavBarButtonItems()
            self.updateChildViewController(true)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateNavBarButtonItems()
        self.updateChildViewController(false)
    }
}

// MARK: Routines
extension UserViewController {
    
    func updateNavBarButtonItems() {
        var leftBarButtonItem: UIBarButtonItem? = nil
        var rightBarButtonItem: UIBarButtonItem? = nil
        if UserManager.shared.isLoggedIn {
            leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_user"), style: .Plain, target: self, action: "showAccountViewController:")
        }
        rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_gear"), style: .Plain, target: self, action: "showSettingsViewController:")
        UIView.setAnimationsEnabled(false)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
    func updateChildViewController(animated: Bool) {
        // If it was register/forget/reset view controllers, we need to pop to root
        self.navigationController?.popToRootViewControllerAnimated(false)
        // Show favorites view controller
        guard let newChildViewController = self.storyboard?.instantiateViewControllerWithIdentifier(UserManager.shared.isLoggedIn ? "FavoritesViewController" : "LoginViewController") else { return }
        self.showChildViewController(newChildViewController, animated, !UserManager.shared.isLoggedIn) { () -> Void in
            
        }
    }
}

// MARK: Actions
extension UserViewController {
    
    func showAccountViewController(sender: UIBarButtonItem) {
        UserManager.shared.logOut()
//        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("AccountViewController") {
//            self.presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
//        }
    }
    
    func showSettingsViewController(sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") {
            self.presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
}