//
//  InvitationSuccessViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-12.
//  Copyright © 2018 Soyou. All rights reserved.
//

class InvitationSuccessViewController: UIViewController {
    
    fileprivate var matricule: Int?
    fileprivate var userID: Int?
    fileprivate var profileUrl: URL?
    fileprivate var name: String?
    fileprivate var gender: String?
    fileprivate var region: String?
    
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgGender: UIImageView!
    @IBOutlet var lblMatricule: UILabel!
    @IBOutlet var lblRegion: UILabel!
    @IBOutlet var lblFooter: UILabel!
    @IBOutlet var btnVisit: UIButton!
    
    // Class methods
    class func instantiate(matricule: Int, userID: Int, profileUrl: URL?, name: String?, gender: String?, region: String?) -> InvitationSuccessViewController {
        let vc = UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "InvitationSuccessViewController") as! InvitationSuccessViewController
        vc.matricule = matricule
        vc.userID = userID
        vc.profileUrl = profileUrl
        vc.name = name
        vc.gender = gender
        vc.region = region
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
    
    override func viewWillAppear(_ animated: Bool) {
        // Nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround to make sure navigation bar is updated even the slide-back gesture is cancelled.
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
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
        
        // Name
        self.lblName.text = self.name
        
        // Gender
        if let gender = self.gender {
            if gender == "\(Cons.Usr.genderMale)" {
                self.imgGender.isHidden = false
                self.imgGender.image = UIImage(named: "img_gender_male")
            } else if gender == "\(Cons.Usr.genderFemale)" {
                self.imgGender.isHidden = false
                self.imgGender.image = UIImage(named: "img_gender_female")
            } else {
                self.imgGender.isHidden = true
            }
        } else {
            self.imgGender.isHidden = true
        }
        
        // Matricule
        if let matricule = self.matricule {
            self.lblMatricule.text = FmtString(NSLocalizedString("qr_code_vc_soyou_id"), "\(matricule)")
        } else {
            self.lblMatricule.text = nil
        }
        
        // Region
        if let region = self.region {
            self.lblRegion.text = FmtString(NSLocalizedString("qr_code_vc_region"), "\(region)")
        } else {
            self.lblRegion.text = nil
        }
        
        // Footer
        self.lblFooter.text = NSLocalizedString("invitation_success_vc_footer")
        
        // Buttons
        self.btnVisit.setTitle(NSLocalizedString("invitation_success_vc_btn_circles"), for: .normal)
    }
}

// MARK: - Actions
extension InvitationSuccessViewController {
    
    @IBAction func visitAction() {
        guard let matricule = self.matricule,
            let profileUrl = self.profileUrl,
            let username = self.name else {
                return
        }
        let vc = CirclesViewController.instantiate(self.userID, profileUrl.absoluteString, username)
        self.navigationController?.pushViewController(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.navigationController?.setViewControllers([vc], animated: false)
        }
    }
}
