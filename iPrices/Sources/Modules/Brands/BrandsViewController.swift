//
//  BrandsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class BrandsViewController: BaseViewController/*, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout*/ {
    
    @IBOutlet var _collectionView: UICollectionView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("brands_view_controller_tab_title", comment: ""), image: UIImage(named: "img_tab_price"), selectedImage: UIImage(named: "img_tab_price_selected"))
        self.tabBarController?.tabBar.translucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}