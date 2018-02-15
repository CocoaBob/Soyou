//
//  CircleImagesCollectionView.swift
//  Soyou
//
//  Created by CocoaBob on 2018-01-09.
//  Copyright © 2018 Soyou. All rights reserved.
//

class CircleImagesCollectionView: UICollectionView {
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return super.contentSize
    }
    
    override func reloadData() {
        super.reloadData()
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
}

class CircleImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var indicator: UIActivityIndicatorView?
    
    var deleteAction: ((UICollectionViewCell)->Void)? {
        didSet {
            btnDelete.isHidden = deleteAction == nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = UIImage(named: "img_placeholder_1_1_s")
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.borderWidth = 0
        self.indicator?.isHidden = true
        self.contentView.layer.contents = nil
        self.contentView.layer.borderWidth = 0
        self.selectedBackgroundView?.layer.contents = nil
        self.selectedBackgroundView?.layer.borderWidth = 0
        self.selectedBackgroundView?.backgroundColor = UIColor.clear
    }
    
    @IBAction func delete() {
        self.deleteAction?(self)
    }
}
