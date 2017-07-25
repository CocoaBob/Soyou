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
        self.view.backgroundColor = Cons.UI.colorBG
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let hud = MBProgressHUD.show(self.view) {
            hud.mode = MBProgressHUDMode.indeterminate
            hud.label.text = NSLocalizedString("initializing_database")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MBProgressHUD.hide(self.view)
    }
}
