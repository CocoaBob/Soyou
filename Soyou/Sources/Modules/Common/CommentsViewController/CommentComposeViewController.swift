//
//  CommentComposeViewController.swift
//  Soyou
//
//  Created by CocoaBob on 29/07/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

protocol CommentComposeViewControllerDelegate {
    
    func didPostNewComment()
}

class CommentComposeViewController: UIViewController {
    
    var infoID: Int!
    var replyToComment: Comment?
    var delegate: CommentComposeViewControllerDelegate?
    var commentCreator: ((_ id: Int, _ commentId: Int?, _ comment: String, _ completion: @escaping CompletionClosure) -> ())?
    
    @IBOutlet var tvContent: UITextView!
    
    // Class methods
    class func instantiate() -> CommentComposeViewController {
        return UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewController(withIdentifier: "CommentComposeViewController") as! CommentComposeViewController
    }
    
    // UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("new_comment_vc_title_post"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(CommentComposeViewController.post))
        
        self.tvContent.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tvContent, 0, true, true, false, false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.keyboardControlInstall()
        
        if let replyToComment = self.replyToComment {
            self.title = FmtString(NSLocalizedString("new_comment_vc_title_reply"), replyToComment.username)
        } else {
            self.title = NSLocalizedString("new_comment_vc_title_new")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tvContent.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.keyboardControlUninstall()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.keyboardControlRotateWithTransitionCoordinator(coordinator)
    }
}

// MARK: KeyboardControl
extension CommentComposeViewController {
    
    override func adjustViewsForKeyboardFrame(_ keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: TimeInterval, _ options: UIViewAnimationOptions) {
        super.adjustViewsForKeyboardFrame(keyboardFrame, isAnimated, duration, options)
        if let scrollView = self.tvContent {
            self.updateScrollViewInset(scrollView, 0, true, true, false, false)
        }
    }
}

// MARK: Actions
extension CommentComposeViewController {
    
    @IBAction func post() {
        var comment = self.tvContent.text ?? ""
        if comment.count == 0 {
            return
        }
        CensorshipManager.censorThenDo(comment) {
            UserManager.shared.loginOrDo {
                comment = self.tvContent.text.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? comment
                self.commentCreator?(self.infoID, self.replyToComment?.id, comment) { (responseObject, error) in
                    if error == nil {
                        self.navigationController?.popViewController(animated: true)
                        if let delegate = self.delegate {
                            delegate.didPostNewComment()
                        }
                    }
                }
            }
        }
    }
}
