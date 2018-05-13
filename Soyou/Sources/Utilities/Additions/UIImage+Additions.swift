//
//  UIImage+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2018-04-18.
//  Copyright © 2018 Soyou. All rights reserved.
//

extension UIImage {
    
    static let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: CIContext(), options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
    
    func rotated() -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    func detectQRCodes() -> [String]? {
        guard let ciImage = CIImage(image: self) else { return nil }
        var codes = [String]()
        if let features = UIImage.qrDetector?.features(in: ciImage) as? [CIQRCodeFeature] {
            for feature in features  {
                if let code = feature.messageString {
                    codes.append(code)
                }
            }
        }
        return codes.isEmpty ? nil : codes
    }
}
