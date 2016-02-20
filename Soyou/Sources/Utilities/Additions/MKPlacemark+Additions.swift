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
        }
        return nil
    }
}