//
//  UIImage+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2018-04-18.
//  Copyright © 2018 Soyou. All rights reserved.
//

extension UIImage {
    
    func rotated() -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    func detectQRCode() -> String? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let context = CIContext()
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: nil)
        if let features = detector?.features(in: ciImage) as? [CIQRCodeFeature] {
            for feature in features  {
                if let decodedString = feature.messageString {
                    return decodedString
                }
            }
        }
        return nil
    }
}
