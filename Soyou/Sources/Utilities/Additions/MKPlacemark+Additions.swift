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
        }
        return nil
    }
}
