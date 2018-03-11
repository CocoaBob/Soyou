//
//  QRCodeViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-11.
//  Copyright © 2018 Soyou. All rights reserved.
//

class QRCodeViewController: UIViewController {
    
    fileprivate var matricule: Int?
    fileprivate var avatar: UIImage?
    fileprivate var name: String?
    fileprivate var gender: String?
    fileprivate var region: String?
    
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgGender: UIImageView!
    @IBOutlet var lblMatricule: UILabel!
    @IBOutlet var lblRegion: UILabel!
    @IBOutlet var imgQRCode: UIImageView!
    @IBOutlet var imgSoyouLogo: UIImageView!
    @IBOutlet var lblFooter: UILabel!
    @IBOutlet var btnShare: UIButton!
    
    // Class methods
    class func instantiate(matricule: Int, avatar: UIImage?, name: String?, gender: String?, region: String?) -> QRCodeViewController {
        let vc = UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
        vc.matricule = matricule
        vc.avatar = avatar
        vc.name = name
        vc.gender = gender
        vc.region = region
        return vc
    }
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        self.title = NSLocalizedString("qr_code_vc_title")
        
        // Navigation Items
        if let vcs = self.navigationController?.viewControllers, vcs.count == 1, vcs.last == self {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(QRCodeViewController.shareQRCodeImage))
        
        // Setup views
        self.setupViews()
    }
}

// MARK: - Views
extension QRCodeViewController {
    
    fileprivate func setupViews() {
        // Message
        self.lblMessage.text = NSLocalizedString("qr_code_vc_share_message")
        // Container View
        self.containerView.layer.shadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        self.containerView.layer.shadowOpacity = 1
        self.containerView.layer.shadowRadius = 2
        self.containerView.layer.shadowOffset = CGSize.zero
        self.containerView.clipsToBounds = false
        // Avatar
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.width / 2.0
        self.imgAvatar.image = self.avatar ?? UIImage(named: "img_placeholder_1_1_s")
        
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
        
        // QR Code
        let qrCode = self.generateQRCode()
        self.imgQRCode.image = qrCode
        
        // Soyou logo
        self.imgSoyouLogo.layer.cornerRadius = 8
        self.imgSoyouLogo.layer.borderColor = UIColor.white.cgColor
        self.imgSoyouLogo.layer.borderWidth = 3
        self.imgSoyouLogo.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.imgSoyouLogo.layer.shadowOpacity = 1
        self.imgSoyouLogo.layer.shadowRadius = 1
        self.imgSoyouLogo.layer.shadowOffset = CGSize.zero
        self.imgSoyouLogo.clipsToBounds = false
        
        // Footer
        self.lblFooter.text = NSLocalizedString("qr_code_vc_footer")
        
        // Share button
        self.btnShare.setTitle(NSLocalizedString("qr_code_vc_share"), for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update corner radius
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.width / 2.0
    }
}

// MARK: - QRCode
extension QRCodeViewController {
    
    fileprivate func invitationURL() -> URL? {
        guard let matricule = self.matricule else { return nil }
        return URL(string: "https://www.soyou.io/invitation?matricule=\(matricule)")
    }
    
    fileprivate func generateQRCode() -> UIImage? {
        guard let url = invitationURL() else { return nil }
        var qrCode = QRCode(url)
        qrCode?.errorCorrection = .Medium
        return qrCode?.image
    }
}

// MARK: - Save QR Code image
extension QRCodeViewController {
    
    @IBAction func shareQRCodeImage() {
        Utils.shareItems(items: [NSLocalizedString("qr_code_vc_share_message"), getQRCodeImage()]) {
            Utils.copyText(text: self.lblMessage.text)
        }
    }
    
    func getQRCodeImage() -> UIImage {
        var bounds = self.containerView.bounds
        bounds = bounds.insetBy(dx: -4, dy: -4)
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { rendererContext in
            self.containerView.layer.render(in: rendererContext.cgContext)
        }
        return image
    }
}
