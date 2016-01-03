//
//  AFNetworking+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 21/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

func AFNetworkingGetResponseObjectFromError(error: NSError?) -> AnyObject? {
    
    if let error = error,
        userInfo = error.userInfo as? Dictionary<String, AnyObject>,
        responseData = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData
    {
        return AFNetworkingGetObjectFromJSONData(responseData)
    } else {
        return nil
    }
}

let _jsonResponseSerializer = AFJSONResponseSerializer()

func AFNetworkingGetObjectFromJSONData(data: NSData?) -> AnyObject? {
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

func AFNetworkingGetObjectFromJSONString(string: String) -> AnyObject? {
    return AFNetworkingGetObjectFromJSONData(string.dataUsingEncoding(NSUTF8StringEncoding))
}