//
//  SplashScreenViewController.swift
//  Soyou
//
//  Created by CocoaBob on 06/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class SplashScreenViewController: UIViewController {
    
    var interstitial: GADInterstitial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: Cons.UI.colorBG)
        
        self.interstitial = self.createAndLoadInterstitial()
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

extension SplashScreenViewController: GADInterstitialDelegate {
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3349787729360682/3092020058")
        interstitial.delegate = self
        interstitial.loadRequest(GADRequest())
        return interstitial
    }
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        ad.presentFromRootViewController(self)
    }
}
