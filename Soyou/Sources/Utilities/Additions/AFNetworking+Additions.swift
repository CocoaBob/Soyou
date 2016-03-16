//
//  AFNetworking+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 21/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

func AFNetworkingGetResponseObjectFromError(error: NSError?) -> AnyObject? {
    
    if let error = error,
        userInfo = error.userInfo as? Dictionary<String, AnyObject>,
        responseData = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData {
        return GetObjectFromJSONData(responseData)
    } else {
        return nil
    }
}

func GetObjectFromJSONData(data: NSData?) -> AnyObject? {
    var returnValue: AnyObject?
    do {
        if let data = data {
            returnValue = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        }
    } catch {
        DLog(error)
    }
    return returnValue
}

func GetObjectFromJSONString(string: String) -> AnyObject? {
    return GetObjectFromJSONData(string.dataUsingEncoding(NSUTF8StringEncoding))
}
