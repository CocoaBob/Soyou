//
//  SplashScreenViewController.swift
//  Soyou
//
//  Created by CocoaBob on 06/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgba: Cons.UI.colorBG)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let hud = MBProgressHUD.showLoader(self.view) {
            hud.mode = MBProgressHUDMode.Indeterminate
            hud.labelText = NSLocalizedString("initializing_database")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MBProgressHUD.hideLoader(self.view)
    }
}
