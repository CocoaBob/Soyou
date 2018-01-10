//
//  PicturePickerCell.swift
//  TLPhotoPicker
//
//  Created by wade.hawk on 2017. 5. 15..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import Foundation
import PhotosUI
import TLPhotoPicker

class PicturePickerCell: TLPhotoCollectionViewCell {
    
    override var isCameraCell: Bool {
        didSet {
            self.orderLabel?.isHidden = self.isCameraCell
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedView?.isHidden = true
        self.selectedView?.layer.borderWidth = 0
        self.selectedView?.layer.cornerRadius = 0
        self.selectedView?.backgroundColor = UIColor(white: 1, alpha: 0.33)
        self.orderBgView?.backgroundColor = UIColor.clear
        self.orderBgView?.layer.borderWidth = 1
        self.orderBgView?.layer.borderColor = UIColor.white.cgColor
        self.orderBgView?.layer.cornerRadius = 12
        self.orderBgView?.layer.shadowRadius = 1
        self.orderBgView?.layer.shadowOpacity = 1
        self.orderBgView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.orderBgView?.layer.shadowColor = UIColor(white: 0, alpha: 0.75).cgColor
    }
}
