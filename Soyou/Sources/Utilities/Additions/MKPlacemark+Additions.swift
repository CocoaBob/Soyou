//
//  MKPlacemark+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 21/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

extension MKPlacemark {
    
    func addressString() -> String? {
        if let addressDict = self.addressDictionary {
            if #available(iOS 9.0, *) {
                let address = CNMutablePostalAddress()
                address.street = addressDict["Street"] as? String ?? ""
                address.state = addressDict["State"] as? String ?? ""
                address.city = addressDict["City"] as? String ?? ""
                address.country = addressDict["Country"] as? String ?? ""
                address.postalCode = addressDict["ZIP"] as? String ?? ""
                var addressString = CNPostalAddressFormatter.string(from: address, style: .mailingAddress)
                addressString = addressString.replacingOccurrences(of: "\n", with: ", ")
                addressString = addressString.trimmingCharacters(in: CharacterSet(charactersIn: ","))
                addressString = addressString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                return addressString
            } else {
                var formattedAddressLines = addressDict["FormattedAddressLines"] as? [String]
                if formattedAddressLines == nil {
                    formattedAddressLines = [String]()
                    if let component = addressDict["Street"] as? String {
                        formattedAddressLines?.append(component)
                    }
                    if let component = addressDict["ZIP"] as? String {
                        formattedAddressLines?.append(component)
                    }
                    if let component = addressDict["City"] as? String {
                        formattedAddressLines?.append(component)
                    }
                    if let component = addressDict["State"] as? String {
                        formattedAddressLines?.append(component)
                    }
                    if let component = addressDict["Country"] as? String {
                        formattedAddressLines?.append(component)
                    }
                }
                return formattedAddressLines?.joined(separator: ", ")
            }
        }
        return nil
    }
}
