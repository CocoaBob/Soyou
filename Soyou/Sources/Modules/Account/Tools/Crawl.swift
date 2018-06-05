//
//  Crawl.swift
//  Soyou
//
//  Created by CocoaBob on 2018-06-05.
//  Copyright © 2018 Soyou. All rights reserved.
//

struct Crawl {
    var id: Int?
    var label: String?
    var url: String?
    var isSelected: Bool?
}

extension Crawl: Hashable {
    
    var hashValue: Int {
        return self.id ?? -1
    }
}

extension Crawl: Equatable {
    
    static func ==(lhs: Crawl, rhs: Crawl) -> Bool {
        return (lhs.id ?? -1) == (rhs.id ?? -1)
    }
}
