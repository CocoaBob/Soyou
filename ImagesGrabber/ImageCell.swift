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
    
    var imageItem: ImageItem? {
        didSet {
            updateImageItem()
        }
    }
    
    @objc open var isSelectedItem: Bool = false {
        willSet(newValue) {
            self.selectedView?.isHidden = !newValue
            if !newValue {
                self.orderLabel?.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = ImageCell.placeholderImage
    }
    
    func updateImageItem() {
        if let image = imageItem?.image {
            imageView?.image = image
        } else if let url = imageItem?.url {
            imageView?.sd_setImage(with: url,
                                   placeholderImage: ImageCell.placeholderImage,
                                   options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                   completed: nil)
        }
    }
}
