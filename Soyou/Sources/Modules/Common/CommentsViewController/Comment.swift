//
//  Comment.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-04.
//  Copyright © 2018 Soyou. All rights reserved.
//

//{
//    "message":"OK",
//    "data": [
//        {
//            "id": 13,
//            "username": "jiyuny",
//            "matricule": 100001,
//            "comment": "哈哈哈就",
//            "canDelete": 1,
//            "parentUsername": null,
//            "parentMatricule": null,
//            "parentComment": null
//        },
//        {
//            "id": 10,
//            "username": "jiyuny",
//            "matricule": 100001,
//            "comment": "Hh",
//            "canDelete": 0,
//            "parentUsername": "CocoaBob",
//            "parentMatricule": 100003,
//            "parentComment": "Test Comment at 491439367.379247"
//        }
//    ]
//}

struct Comment {
    var id: Int = 0
    var username: String = ""
    var matricule: Int = -1
    var comment: String = ""
    var canDelete: Int = 0
    var parentUsername: String?
    var parentMatricule: Int?
    var parentComment: String?
    
    init(id: Int = 0,
         username: String = "",
         matricule: Int = -1,
         comment: String = "",
         canDelete: Int = 0,
         parentUsername: String? = nil,
         parentMatricule: Int? = nil,
         parentComment: String? = nil) {
        self.id = id
        self.username = username
        self.matricule = matricule
        self.comment = comment
        self.canDelete = canDelete
        self.parentUsername = parentUsername
        self.parentMatricule = parentMatricule
        self.parentComment = parentComment
    }
    
    init() {
        
    }
    
    init(json: JSON) {
        self.importDataFromJSON(json)
    }
    
    mutating func importDataFromJSON(_ json: JSON) {
        self.id = json["id"].intValue
        let username = json["username"].stringValue
        self.username = username.removingPercentEncoding ?? username
        self.matricule = json["matricule"].intValue
        let comment = json["comment"].stringValue
        self.comment = comment.removingPercentEncoding ?? comment
        self.canDelete = json["canDelete"].intValue
        self.parentUsername = json["parentUsername"].string
        self.parentMatricule = json["parentMatricule"].int
        let parentComment = json["parentComment"].string
        self.parentComment = parentComment?.removingPercentEncoding ?? parentComment
    }
}
