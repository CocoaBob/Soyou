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
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nav bar button items
        self.updateNavBarButtonItems()
        
        // Notifications of isLoggedIn
        NSNotificationCenter.defaultCenter().addObserverForName(Cons.Usr.IsLoggedInDidChangeNotification, object: UserManager.shared, queue: nil) { (n) -> Void in
            self.updateChildViewController(true)
        }
        
        // Update Child View Controller
        updateChildViewController(false)
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
        if UserManager.shared.isLoggedIn {
            if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("FavoritesViewController") {
                self.showChildViewController(viewController)
            }
        } else {
            if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") {
                self.showChildViewController(viewController)
            }
        }
    }
}

// MARK: Actions
extension UserViewController {
    
    func showAccountViewController(sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("AccountViewController") {
            self.presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
    
    func showSettingsViewController(sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") {
            self.presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
}