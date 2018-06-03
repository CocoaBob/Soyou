//
//  ImageCell.swift
//  ImagesGrabber
//
//  Created by CocoaBob on 2018-06-01.
//  Copyright © 2018 Soyou. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCell: UICollectionViewCell {
    
    @IBOutlet open var imageView: UIImageView?
    @IBOutlet open var selectedView: UIView?
    @IBOutlet open var orderLabel: UILabel?
    @IBOutlet open var orderBgView: UIView?
    
    static var placeholderImage = UIImage(named: "img_placeholder_1_1_s")
    
    var item: ImageItem? {
        didSet {
            updateImageItem()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectedView?.isHidden = true
        self.selectedView?.layer.borderWidth = 0
        self.selectedView?.layer.cornerRadius = 0
        self.selectedView?.backgroundColor = UIColor(white: 1, alpha: 0.33)
        self.orderBgView?.layer.borderWidth = 1
        self.orderBgView?.layer.borderColor = UIColor.white.cgColor
        self.orderBgView?.layer.cornerRadius = 12
        self.orderBgView?.layer.shadowRadius = 1
        self.orderBgView?.layer.shadowOpacity = 1
        self.orderBgView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.orderBgView?.layer.shadowColor = UIColor(white: 0, alpha: 0.75).cgColor
        
        let selectedColor = UIColor(red: 88/255, green: 144/255, blue: 255/255, alpha: 1.0)
        self.selectedView?.layer.borderColor = selectedColor.cgColor
        self.orderBgView?.backgroundColor = selectedColor
        
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = ImageCell.placeholderImage
    }
    
    func updateImageItem() {
        if let image = item?.image {
            imageView?.image = image
        } else if let url = item?.url {
            imageView?.sd_setImage(with: url,
                                   placeholderImage: ImageCell.placeholderImage,
                                   options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                   completed: nil)
        }
    }
    
    func updateSelection() {
        if let item = item {
            selectedView?.isHidden = !item.isSelected
            orderLabel?.text = "\(item.order)"
        } else {
            selectedView?.isHidden = true
        }
    }
}
