//
//  InfoNewCommentViewController.swift
//  Soyou
//
//  Created by CocoaBob on 29/07/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

protocol InfoNewCommentViewControllerDelegate {
    
    func didPostNewComment()
}

class InfoNewCommentViewController: UIViewController {
    
    var delegate: InfoNewCommentViewControllerDelegate?
    
    
}
