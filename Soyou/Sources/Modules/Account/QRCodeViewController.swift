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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "img_more"), style: .plain, target: self, action: #selector(QRCodeViewController.moreAction))
        
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
//        self.containerView.layer.borderWidth = 1
//        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.containerView.layer.shadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        self.containerView.layer.shadowOpacity = 1
        self.containerView.layer.shadowRadius = 2
        self.containerView.layer.shadowOffset = CGSize.zero
        self.containerView.clipsToBounds = false
        // Avatar
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
        self.imgQRCode.image = self.generateQRCode()
        
        // Soyou logo
        self.imgSoyouLogo.layer.cornerRadius = 8
        self.imgSoyouLogo.layer.borderColor = UIColor.white.cgColor
        self.imgSoyouLogo.layer.borderWidth = 4
        self.imgSoyouLogo.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.imgSoyouLogo.layer.shadowOpacity = 1
        self.imgSoyouLogo.layer.shadowRadius = 2
        self.imgSoyouLogo.layer.shadowOffset = CGSize.zero
        self.imgSoyouLogo.clipsToBounds = false
        
        // Footer
        self.lblFooter.text = NSLocalizedString("qr_code_vc_footer")
        
        // Share button
        self.btnShare.setTitle(NSLocalizedString("qr_code_vc_share"), for: .normal)
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
        return QRCode(url)?.image
    }
}

// MARK: - Save QR Code image
extension QRCodeViewController {
    
    @IBAction func shareQRCodeImage() {
        Utils.shareTextAndImagesToWeChat(from: self, text: NSLocalizedString("qr_code_vc_share_message"), images: [getQRCodeImage()])
    }
    
    @IBAction func saveQRCodeImage() {
        UIImageWriteToSavedPhotosAlbum(getQRCodeImage(), self, #selector(QRCodeViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
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
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        guard let window = self.view.window else { return }
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.isUserInteractionEnabled = false
        hud.mode = .text
        if let error = error {
            hud.label.text = FmtString(NSLocalizedString("qr_code_vc_save_image_fail"), error.localizedDescription)
        } else {
            hud.label.text = NSLocalizedString("qr_code_vc_save_image_succeed")
        }
        hud.hide(animated: true, afterDelay: 3)
    }
}

// MARK: - Actions
extension QRCodeViewController {
    
    @IBAction func moreAction() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("qr_code_vc_save_image"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            self.saveQRCodeImage()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_cancel"), style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
