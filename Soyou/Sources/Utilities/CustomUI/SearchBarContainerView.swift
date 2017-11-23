//
//  SearchBarContainerView.swift
//  Soyou
//
//  Created by CocoaBob on 2017-11-23.
//  Copyright © 2017 Soyou. All rights reserved.
//

class SearchBarContainerView: UIView {
    
    let searchBar: UISearchBar
    
    init(searchBar: UISearchBar) {
        self.searchBar = searchBar
        super.init(frame: CGRect.zero)
        addSubview(searchBar)
        self.backgroundColor = .clear
    }
    
    override convenience init(frame: CGRect) {
        self.init(searchBar: UISearchBar())
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
