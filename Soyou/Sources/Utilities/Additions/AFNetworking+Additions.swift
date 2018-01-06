
//
//  AFNetworking+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 21/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

func AFNetworkingGetResponseObjectFromError(_ error: Error?) -> Any? {
    
    if let error = error,
        let userInfo = (error as NSError?)?.userInfo,
        let responseData = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
        return GetObjectFromJSONData(responseData)
    } else {
        return nil
    }
}

func GetObjectFromJSONData(_ data: Data?) -> Any? {
    var returnValue: Any?
    do {
        if let data = data {
            returnValue = try JSONSerialization.jsonObject(with: data, options: [])
        }
    } catch {
        DLog(error)
    }
    return returnValue
}

func GetObjectFromJSONString(_ string: String) -> Any? {
    return GetObjectFromJSONData(string.data(using: String.Encoding.utf8)! as Data)
}
