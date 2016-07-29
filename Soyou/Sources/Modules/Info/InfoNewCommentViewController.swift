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
    
    var infoID: NSNumber!
    var replyToComment: Comment?
    var delegate: InfoNewCommentViewControllerDelegate?
    
    @IBOutlet var tvContent: UITextView!
    
    // Class methods
    class func instantiate() -> InfoNewCommentViewController {
        return (UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewControllerWithIdentifier("InfoNewCommentViewController") as? InfoNewCommentViewController)!
    }
    
    // UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("new_comment_vc_title_post"),
                                                                 style: .Plain,
                                                                 target: self,
                                                                 action: #selector(InfoNewCommentViewController.post))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let replyToComment = self.replyToComment {
            self.title = FmtString(NSLocalizedString("new_comment_vc_title_reply"), replyToComment.username)
        } else {
            self.title = NSLocalizedString(NSLocalizedString("new_comment_vc_title_new"))
        }
    }
}

// MARK: Actions
extension InfoNewCommentViewController {
    
    @IBAction func post() {
        UserManager.shared.loginOrDo {
            DataManager.shared.createCommentForDiscount(self.infoID, self.replyToComment?.id ?? 0, self.tvContent.text) { (responseObject, error) in
                dispatch_async(dispatch_get_main_queue(), { 
                    self.dismissSelf()
                })
                if let delegate = self.delegate {
                    delegate.didPostNewComment()
                }
            }
        }
    }
}
