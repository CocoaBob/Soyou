//
//  ObjCRuntime+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2018-01-12.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation

func associatedObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>) -> ValueType? {
    if let associated = objc_getAssociatedObject(base, key) as? ValueType {
        return associated
    }
    return nil
}
func associateObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType?) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}
