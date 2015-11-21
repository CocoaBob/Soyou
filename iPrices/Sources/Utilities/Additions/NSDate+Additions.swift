//
//  NSDate+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 20/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

public func == (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func != (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) != .OrderedSame
}

public func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

public func > (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}

public func <= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending || lhs.compare(rhs) == .OrderedSame
}

public func >= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending || lhs.compare(rhs) == .OrderedSame
}