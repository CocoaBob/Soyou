//
//  MarginLabel.swift
//  Soyou
//
//  Created by CocoaBob on 17/08/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

public class MarginLabel: UILabel {
	
	@IBInspectable var topInset: CGFloat = 0.0
	@IBInspectable var bottomInset: CGFloat = 0.0
	@IBInspectable var leftInset: CGFloat = 0.0
	@IBInspectable var rightInset: CGFloat = 0.0
	
	@IBInspectable var noInsetWhenEmpty: Bool = true
	
    override public func drawText(in rect: CGRect) {
		if let text = self.text {
			if !text.isEmpty {
				let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
                super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
				return
			}
		}
        super.drawText(in: rect)
	}
	
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
		if let text = self.text {
			if !text.isEmpty || !self.noInsetWhenEmpty {
				intrinsicSuperViewContentSize.height += topInset + bottomInset
				intrinsicSuperViewContentSize.width += leftInset + rightInset
			}
		}
		return intrinsicSuperViewContentSize
	}
}
