//
//  ScanViewController.swift
//  Intime
//
//  Created by Zhao Zhe on 8/26/16.
//  Copyright © 2016 Zhao Zhe. All rights reserved.
//

protocol ScanViewControllerDelegate: class {
    
    func scanViewControllerDidScanCode(scanVC: ScanViewController, code: String?)
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var overlayView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var myQRCodeButton: UIButton!
    
    weak var delegate: ScanViewControllerDelegate?
    
    fileprivate var session: AVCaptureSession?
    fileprivate var overlayLayer: CAShapeLayer?
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    
    fileprivate var animationLayer: CALayer?
    fileprivate var animationTimer: Timer?
    fileprivate var animationProgress: CGFloat = 0
    
    // Class methods
    class func instantiate() -> ScanViewController {
        return  UIStoryboard(name: "ScanViewController", bundle: nil).instantiateViewController(withIdentifier: "ScanViewController") as! ScanViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("scan_vc_title")
        self.messageLabel.text = NSLocalizedString("scan_vc_message")
        self.myQRCodeButton.setTitle(NSLocalizedString("scan_vc_my_qr_code"), for: .normal)
        self.setupScanner()
        self.setupOverlayView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startScanning()
        self.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopScanning()
        self.stopAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Layout Preview Layer
        self.setupPreviewLayer()
        
        // Layout Overlay Layer
        self.setupOverlayView()
    }
}

// MARK: - UI
extension ScanViewController {
    
    fileprivate func setupScanner() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        let session = AVCaptureSession()
        self.session = session
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.cameraView.layer.addSublayer(previewLayer)
            self.previewLayer = previewLayer
            self.setupPreviewLayer()
        } catch {
            
        }
    }
    
    fileprivate func setupPreviewLayer() {
        let bounds = self.cameraView.layer.bounds
        self.previewLayer?.bounds = bounds
        self.previewLayer?.position = CGPoint(x:bounds.midX, y:bounds.midY)
    }
    
    fileprivate func setupOverlayView() {
        let coverPath = UIBezierPath(rect: overlayView.bounds)
        let maskPath = UIBezierPath(rect: CGRect(x: overlayView.bounds.width / 2.0 - 140, y: overlayView.bounds.height / 2.0 - 140, width: 280, height: 280))
        
        coverPath.append(maskPath)
        coverPath.usesEvenOddFillRule = true
        
        if self.overlayLayer == nil {
            let overlayLayer = CAShapeLayer()
            overlayLayer.fillRule = kCAFillRuleEvenOdd
            overlayLayer.fillColor = UIColor(white: 0, alpha: 0.5).cgColor
            overlayView.layer.addSublayer(overlayLayer)
            self.overlayLayer = overlayLayer
        }
        
        self.overlayLayer?.path = coverPath.cgPath;
    }
}

// MARK: - Scan
extension ScanViewController {
    
    fileprivate func startScanning() {
        self.session?.startRunning()
    }
    
    fileprivate func stopScanning() {
        self.session?.stopRunning()
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for item in metadataObjects {
            if let metadataObject = item as? AVMetadataMachineReadableCodeObject {
                self.stopScanning()
                self.dismiss(animated: true, completion: {
                    self.delegate?.scanViewControllerDidScanCode(scanVC: self, code: metadataObject.stringValue)
                })
            }
        }
    }
}

// MARK: - Animation
extension ScanViewController {
    
    fileprivate func startAnimation() {
        self.stopAnimation()
        self.animationProgress = 0
        let animationLayer = CALayer()
        animationLayer.bounds = CGRect(x: 0, y: 0, width: 280, height: 2)
        animationLayer.contents = UIImage(named: "img_scan_view_fg")?.cgImage
        animationLayer.contentsGravity = kCAGravityCenter
        animationLayer.contentsScale = 2
        self.overlayLayer?.addSublayer(animationLayer)
        self.animationLayer = animationLayer
        self.updateAnimation()
        self.animationTimer = Timer.scheduledTimer(timeInterval: 1 / 60.0, target: self, selector: #selector(ScanViewController.updateAnimation), userInfo: nil, repeats: true)
    }
    
    fileprivate func stopAnimation() {
        if self.animationTimer != nil {
            self.animationTimer?.invalidate()
            self.animationTimer = nil
            self.animationLayer?.removeFromSuperlayer()
            self.animationLayer = nil
        }
    }
    
    @objc fileprivate func updateAnimation() {
        let step = CGFloat(0.005)
        if self.animationProgress >= CGFloat(1) {
            self.animationProgress = 0
        }
        self.animationProgress = self.animationProgress + step
        var position = CGPoint(x: overlayView.bounds.midX, y: overlayView.bounds.midY - 140)
        position.y = position.y + 280 * self.animationProgress
        CATransaction.setDisableActions(true)
        self.animationLayer?.position = position
        CATransaction.setDisableActions(false)
    }
}

// MARK: - Actions
extension ScanViewController {

    @IBAction func showMyQRCode() {
        guard let matricule = UserManager.shared.matricule else { return }
        var countryName: String?
        if let countryCode = UserManager.shared.region {
            countryName = CurrencyManager.shared.countryName(countryCode)
        }
        var avatar: UIImage?
        if let url = URL(string: UserManager.shared.avatar ?? "") {
            avatar = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: url))
        }
        let vc = QRCodeViewController.instantiate(matricule: matricule,
                                                  avatar: avatar,
                                                  name: UserManager.shared.username,
                                                  gender: UserManager.shared["gender"] as? String,
                                                  region: countryName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
