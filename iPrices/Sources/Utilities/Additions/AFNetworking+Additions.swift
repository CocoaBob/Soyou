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
//        response = userInfo[AFNetworkingOperationFailingURLResponseErrorKey] as? NSURLResponse,
        responseData = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData
    {
        return AFNetworkingGetObjectFromJSONData(responseData)
    } else {
        return nil
    }
}

let _jsonResponseSerializer = AFJSONResponseSerializer()

func AFNetworkingGetObjectFromJSONData(data: NSData) -> AnyObject? {
    return _jsonResponseSerializer.responseObjectForResponse(nil, data: data, error: nil)
}