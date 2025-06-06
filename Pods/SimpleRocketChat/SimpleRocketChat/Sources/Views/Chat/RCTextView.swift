//
//  RCTextView.swift
//  Rocket.Chat
//
//  Created by Artur Rymarz on 21.10.2017.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import Foundation
import UIKit

class HighlightLayoutManager: NSLayoutManager {
    override func fillBackgroundRectArray(_ rectArray: UnsafePointer<CGRect>, count rectCount: Int, forCharacterRange charRange: NSRange, color: UIColor) {
        let cornerRadius: CGFloat = 5
        let path = CGMutablePath.init()

        if rectCount == 1 || (rectCount == 2 && (rectArray[1].maxX < rectArray[0].maxX)) {
            path.addRect(rectArray[0].insetBy(dx: cornerRadius, dy: cornerRadius))

            if rectCount == 2 {
                path.addRect(rectArray[1].insetBy(dx: cornerRadius, dy: cornerRadius))
            }
        } else {
            let lastRect = rectCount - 1

            path.move(to: CGPoint(x: rectArray[0].minX + cornerRadius, y: rectArray[0].maxY + cornerRadius))

            path.addLine(to: CGPoint(x: rectArray[0].minX + cornerRadius, y: rectArray[0].minY + cornerRadius))
            path.addLine(to: CGPoint(x: rectArray[0].maxX - cornerRadius, y: rectArray[0].minY + cornerRadius))

            path.addLine(to: CGPoint(x: rectArray[0].maxX - cornerRadius, y: rectArray[lastRect].minY - cornerRadius))
            path.addLine(to: CGPoint(x: rectArray[lastRect].maxX - cornerRadius, y: rectArray[lastRect].minY - cornerRadius))

            path.addLine(to: CGPoint(x: rectArray[lastRect].maxX - cornerRadius, y: rectArray[lastRect].maxY - cornerRadius))
            path.addLine(to: CGPoint(x: rectArray[lastRect].minX + cornerRadius, y: rectArray[lastRect].maxY - cornerRadius))

            path.addLine(to: CGPoint(x: rectArray[lastRect].minX + cornerRadius, y: rectArray[0].maxY + cornerRadius))

            path.closeSubpath()
        }

        color.set()

        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }

        ctx.setLineWidth(cornerRadius * 1.9)
        ctx.setLineJoin(.round)

        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)

        ctx.addPath(path)
        ctx.drawPath(using: .fillStroke)
    }
}

@IBDesignable class RCTextView: UIView {

    private var textView: UITextView!

    weak var delegate: ChatMessageCellProtocol?

    var message: NSAttributedString! {
        didSet {
            textView.attributedText = message
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        let textStorage = NSTextStorage()
        let layoutManager = HighlightLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer.init(size: bounds.size)
        layoutManager.addTextContainer(textContainer)
        textView = UITextView.init(frame: .zero, textContainer: textContainer)
        configureTextView()

        addSubview(textView)
    }

    private func configureTextView() {
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .clear
        textView.dataDetectorTypes = .all
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        textView.frame = bounds
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        textView.text = "HighlightTextView"
    }
}

extension RCTextView: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "http" || URL.scheme == "https" {
            delegate?.openURL(url: URL)
            return false
        }

        return true
    }
}

extension RCTextView {
    
    func sizeToFitWidth(_ width: CGFloat) -> CGSize {
        var size = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        size.height = ceil(size.height)
        return size
    }
}
