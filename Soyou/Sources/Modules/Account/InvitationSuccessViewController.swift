//
//  InvitationSuccessViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-12.
//  Copyright © 2018 Soyou. All rights reserved.
//

class InvitationSuccessViewController: UIViewController {
    
    fileprivate var matricule: Int?
    fileprivate var profileUrl: URL?
    fileprivate var name: String?
    
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblFooter: UILabel!
    @IBOutlet var btnVisit: UIButton!
    @IBOutlet var btnClose: UIButton!
    
    // Class methods
    class func instantiate(matricule: Int, profileUrl: URL?, name: String?) -> InvitationSuccessViewController {
        let vc = UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "InvitationSuccessViewController") as! InvitationSuccessViewController
        vc.matricule = matricule
        vc.profileUrl = profileUrl
        vc.name = name
        return vc
    }
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        self.title = NSLocalizedString("invitation_success_vc_title")
        
        // Setup views
        self.setupViews()
    }
}

// MARK: - Views
extension InvitationSuccessViewController {
    
    fileprivate func setupViews() {
        // Avatar
        self.imgAvatar.sd_setImage(with: self.profileUrl,
                                   placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                   options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                   completed: nil)
        
        // Message
        self.lblMessage.text = NSLocalizedString("invitation_success_vc_message")
        
        // Name
        self.lblName.text = self.name
        
        // Footer
        self.lblFooter.text = NSLocalizedString("invitation_success_vc_footer")
        
        // Buttons
        self.btnVisit.setTitle(NSLocalizedString("invitation_success_vc_btn_circles"), for: .normal)
        self.btnClose.setTitle(NSLocalizedString("invitation_success_vc_btn_close"), for: .normal)
    }
}

// MARK: - Actions
extension InvitationSuccessViewController {
    
    @IBAction func visitAction() {
        
    }
}
