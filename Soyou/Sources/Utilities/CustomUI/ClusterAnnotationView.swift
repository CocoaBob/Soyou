//
//  ClusterAnnotationView.swift
//  MapViewDemo
//
//  Created by Max Kupetskiy on 12/11/15.
//  Copyright © 2015 Ravi Shankar. All rights reserved.
//

import UIKit
import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ClusterAnnotationView: MKAnnotationView {
    @IBOutlet var countLabel: UILabel!
    
    var count: Int? {
        didSet {
//            self.canShowCallout = count == 1
            countLabel.text = "\(count!)"
            self.setNeedsLayout()
        }
    }
    var isUniqueLocation: Bool? {
        didSet {
//            if let isUniqueLocation = isUniqueLocation {
//                self.canShowCallout = isUniqueLocation
//            }
            self.setNeedsLayout()
        }
    }
    
    init() {
        super.init(annotation: nil, reuseIdentifier: nil)
        count = 1
        isUniqueLocation = false
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        count = 1
        isUniqueLocation = false
        
        self.backgroundColor = UIColor.clear
        self.setUpLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLabel() {
        countLabel = UILabel(frame: self.bounds)
        countLabel.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.clear
        countLabel.textColor = UIColor.white
        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.minimumScaleFactor = 2
        countLabel.numberOfLines = 1
        countLabel.font = UIFont.boldSystemFont(ofSize: 12)
        countLabel.baselineAdjustment = .alignCenters
        
        self.addSubview(countLabel)
    }
    
    override func layoutSubviews() {
        var image: UIImage?
        var centerOffset: CGPoint?
        var countLabelFrame: CGRect?
        
        if isUniqueLocation! {
            let imageName = "img_map_annotation_square"
            image = UIImage(named: imageName)
            centerOffset = CGPoint(x: 0, y: image!.size.height * 0.5)
            var frame: CGRect = self.bounds
            frame.origin.y -= 2
            countLabelFrame = frame
        } else {
            var suffix: String?
            if count > 200 {
                suffix = "39"
            } else if count > 100 {
                suffix = "38"
            } else if count > 50 {
                suffix = "36"
            } else if count > 20 {
                suffix = "34"
            } else if count > 10 {
                suffix = "31"
            } else {
                suffix = "28"
            }
            
            let imageName = "img_map_annotation_circle_" + suffix!
            image = UIImage(named: imageName)
            
            centerOffset = CGPoint.zero
            countLabelFrame = self.bounds
        }
        
        self.countLabel.frame = countLabelFrame!
        self.image = image!
        self.centerOffset = centerOffset!
    }
}
