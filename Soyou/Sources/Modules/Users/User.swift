//
//  Follower.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-04.
//  Copyright © 2018 Soyou. All rights reserved.
//

struct User {
    
    var id: Int = 0
    var gender: String = ""
    var username: String = ""
    var profileUrl: String = ""
    var matricule: Int = 0
    var badges: [Any]?
    
    static func newList(dicts: [NSDictionary]) -> [User] {
        var followers = [User]()
        for dict in dicts {
            followers.append(User(dict: dict))
        }
        return followers
    }
    
    init(dict: NSDictionary) {
        self.init(json: JSON(dict))
    }
    
    init(json: JSON) {
        self.importDataFromJSON(json)
    }
    
    mutating func importDataFromJSON(_ json: JSON) {
        self.id = json["id"].intValue
        self.gender = json["gender"].stringValue
        let username = json["username"].stringValue
        self.username = username.removingPercentEncoding ?? username
        self.matricule = json["matricule"].intValue
        self.profileUrl = json["profileUrl"].stringValue
        self.badges = json["badges"].arrayObject
    }
}
