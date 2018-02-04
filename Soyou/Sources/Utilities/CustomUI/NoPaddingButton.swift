//
//  NoPaddingButton.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-03.
//  Copyright © 2018 Soyou. All rights reserved.
//

class NoPaddingButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        return titleLabel?.intrinsicContentSize ?? super.intrinsicContentSize
    }
}
