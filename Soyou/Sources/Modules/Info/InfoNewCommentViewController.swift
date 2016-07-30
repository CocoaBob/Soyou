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
        
        self.tvContent.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.keyboardControlInstall()
        
        if let replyToComment = self.replyToComment {
            self.title = FmtString(NSLocalizedString("new_comment_vc_title_reply"), replyToComment.username)
        } else {
            self.title = NSLocalizedString(NSLocalizedString("new_comment_vc_title_new"))
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tvContent.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.keyboardControlUninstall()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.keyboardControlRotateWithTransitionCoordinator(coordinator)
    }
}

// MARK: KeyboardControl
extension InfoNewCommentViewController {
    
    override func adjustViewsForKeyboardFrame(keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: NSTimeInterval, _ options: UIViewAnimationOptions) {
        super.adjustViewsForKeyboardFrame(keyboardFrame, isAnimated, duration, options)
        if let scrollView = self.tvContent {
            self.updateScrollViewInset(scrollView, 0, true, true, false, false)
        }
    }
}

// MARK: Actions
extension InfoNewCommentViewController {
    
    @IBAction func post() {
        UserManager.shared.loginOrDo {
            DataManager.shared.createCommentForDiscount(self.infoID, self.replyToComment?.id ?? 0, self.tvContent.text) { (responseObject, error) in
                if error == nil {
                    self.navigationController?.popViewControllerAnimated(true)
                    if let delegate = self.delegate {
                        delegate.didPostNewComment()
                    }
                }
            }
        }
    }
}
