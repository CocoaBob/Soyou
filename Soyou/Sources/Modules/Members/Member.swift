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
    var username: String?
    var profileUrl: String?
    var matricule: Int = 0
    var badges: [Any]?
    
    init(id: Int = 0,
         gender: String = "",
         username: String? = nil,
         profileUrl: String? = nil,
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

// MARK: - Badge image
extension Member {
    
    // Type could be s, m or l
    static func badgeImage(_ id: Int?, _ type: String) -> UIImage? {
        guard let id = id else {
            return nil
        }
        var image_name = "img_badge_blue"
        if id == 1 {
            image_name = "img_badge_orange_v"
        } else if id == 2 {
            image_name = "img_badge_blue_v"
        } else if id == 3 {
            image_name = "img_badge_red_v"
        } else if id == 4 {
            image_name = "img_badge_green_v"
        } else if id == 5 {
            image_name = "img_badge_blue"
        } else if id == 6 {
            image_name = "img_badge_purple_v"
        } else if id == 7 {
            image_name = "img_badge_yellow_v"
        }
        image_name += "_" + type
        return UIImage(named: image_name)
    }
}

extension Member: Hashable {
    
    var hashValue: Int {
        return self.id
    }
}

extension Member: Equatable {
    
    static func ==(lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
}
