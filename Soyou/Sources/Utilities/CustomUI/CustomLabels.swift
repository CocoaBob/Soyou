//
//  MarginLabel.swift
//  Soyou
//
//  Created by CocoaBob on 17/08/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

public class MenuLabel: UILabel {
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPressed(_:))
            )
        )
    }
    
    // MARK: - Actions
    
    @objc internal func handleLongPressed(_ gesture: UILongPressGestureRecognizer) {
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        }
        return false
    }
    
    override public func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
}

public class MarginLabel: MenuLabel {
	
	@IBInspectable var topInset: CGFloat = 0.0
	@IBInspectable var bottomInset: CGFloat = 0.0
	@IBInspectable var leftInset: CGFloat = 0.0
	@IBInspectable var rightInset: CGFloat = 0.0
	
	@IBInspectable var noInsetWhenEmpty: Bool = true
	
    override public func drawText(in rect: CGRect) {
		if let text = self.text, !text.isEmpty {
            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            super.drawText(in: rect)
        }
	}
	
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
		if let text = self.text, (!text.isEmpty || !self.noInsetWhenEmpty) {
            intrinsicSuperViewContentSize.height += topInset + bottomInset
            intrinsicSuperViewContentSize.width += leftInset + rightInset
		}
		return intrinsicSuperViewContentSize
	}
}
