//
//  Follower.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-04.
//  Copyright © 2018 Soyou. All rights reserved.
//

struct Member {
    
    var id: Int = 0
    var gender: String = ""
    var username: String = ""
    var profileUrl: String = ""
    var matricule: Int = 0
    var badges: [Any]?
    
    init(id: Int = 0,
         gender: String = "",
         username: String = "",
         profileUrl: String = "",
         matricule: Int = 0,
         badges: [Any]? = nil) {
        self.id = id
        self.gender = gender
        self.username = username
        self.profileUrl = profileUrl
        self.matricule = matricule
        self.badges = badges
    }
    
    static func newList(dicts: [NSDictionary]) -> [Member] {
        var followers = [Member]()
        for dict in dicts {
            followers.append(Member(dict: dict))
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
