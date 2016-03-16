//
//  MKPlacemark+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 21/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

extension MKPlacemark {
    
    func addressString() -> String? {
        if let addressDictionary = self.addressDictionary {
            if #available(iOS 9.0, *) {
                let address = CNMutablePostalAddress()
                address.street = addressDictionary["Street"] as? String ?? ""
                address.state = addressDictionary["State"] as? String ?? ""
                address.city = addressDictionary["City"] as? String ?? ""
                address.country = addressDictionary["Country"] as? String ?? ""
                address.postalCode = addressDictionary["ZIP"] as? String ?? ""
                var addressString = CNPostalAddressFormatter.stringFromPostalAddress(address, style: .MailingAddress)
                addressString = addressString.stringByReplacingOccurrencesOfString("\n", withString: ", ")
                addressString = addressString.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: ","))
                addressString = addressString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                return addressString
            } else {
                var formattedAddressLines = addressDictionary["FormattedAddressLines"] as? [String]
                if formattedAddressLines == nil {
                    formattedAddressLines = [String]()
                    if let component = addressDictionary["Street"] as? String {
                        formattedAddressLines?.append(component)
                    }
                    if let component = addressDictionary["ZIP"] as? String {
                        formattedAddressLines?.append(component)
                    }
                    if let component = addressDictionary["City"] as? String {
                        formattedAddressLines?.append(component)
                    }
                    if let component = addressDictionary["State"] as? String {
                        formattedAddressLines?.append(component)
                    }
                    if let component = addressDictionary["Country"] as? String {
                        formattedAddressLines?.append(component)
                    }
                }
                return formattedAddressLines?.joinWithSeparator(", ")
            }
        }
        return nil
    }
}
