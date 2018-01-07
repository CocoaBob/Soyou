//
//  CircleComposeViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-01-06.
//  Copyright © 2018 Soyou. All rights reserved.
//

protocol CircleComposeViewControllerDelegate {
    
    func didPostNewCircle()
}

class CircleComposeViewController: UIViewController {
    
    var infoID: Int!
    var delegate: CircleComposeViewControllerDelegate?
    
    @IBOutlet var tvContent: UITextView!
    
    // Class methods
    class func instantiate() -> CircleComposeViewController {
        return UIStoryboard(name: "CirclesViewController", bundle: nil).instantiateViewController(withIdentifier: "CircleComposeViewController") as! CircleComposeViewController
    }
    
    // UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide tabs
        self.hidesBottomBarWhenPushed = true
        // Action button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("new_comment_vc_title_post"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(CircleComposeViewController.post))
        // Text view
        self.tvContent.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        self.keyboardControlInstall()
        
        self.title = NSLocalizedString(NSLocalizedString("new_comment_vc_title_new"))
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
extension CircleComposeViewController {
    
    override func adjustViewsForKeyboardFrame(_ keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: TimeInterval, _ options: UIViewAnimationOptions) {
        super.adjustViewsForKeyboardFrame(keyboardFrame, isAnimated, duration, options)
        if let scrollView = self.tvContent {
            self.updateScrollViewInset(scrollView, 0, true, true, false, false)
        }
    }
}

// MARK: Actions
extension CircleComposeViewController {
    
    @IBAction func post() {
        UserManager.shared.loginOrDo {
            var comment = self.tvContent.text ?? ""
            if comment.count == 0 {
                return
            }
            comment = self.tvContent.text.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? comment
            DataManager.shared.createCicle(comment, nil, CircleVisibility.everyone) { (responseObject, error) in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                    if let delegate = self.delegate {
                        delegate.didPostNewCircle()
                    }
                }
            }
        }
    }
}
