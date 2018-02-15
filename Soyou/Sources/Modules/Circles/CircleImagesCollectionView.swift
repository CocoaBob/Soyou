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
    @IBOutlet var progressView: DACircularProgressView?
    
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
        self.imageView.sd_cancelCurrentImageLoad()
        self.imageView.image = UIImage(named: "img_placeholder_1_1_s")
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.borderWidth = 0
        self.progressView?.isHidden = true
        self.progressView?.thicknessRatio = 0.1
        self.progressView?.roundedCorners = 1
        self.progressView?.trackTintColor = UIColor(white:0, alpha: 0.2)
        self.progressView?.progressTintColor = UIColor(white:1, alpha: 1)
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
