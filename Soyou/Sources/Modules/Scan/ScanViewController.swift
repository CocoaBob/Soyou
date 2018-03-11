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

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{

    @IBOutlet weak var cameraView: UIView!
    weak var previewLayer:CALayer!
    weak var delegate: ScanViewControllerDelegate?
    var session:AVCaptureSession!
    
    // Class methods
    class func instantiate() -> ScanViewController {
        return  UIStoryboard(name: "ScanViewController", bundle: nil).instantiateViewController(withIdentifier: "ScanViewController") as! ScanViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanner()
        self.title = NSLocalizedString("scan_vc_title")
    }
    
    func setupScanner() {
        session = AVCaptureSession()
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: device!)
            session.addInput(input)

            let output = AVCaptureMetadataOutput()

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            let bounds = self.cameraView.layer.bounds
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.bounds = bounds
            previewLayer.position = CGPoint(x:bounds.midX, y:bounds.midY)
            self.previewLayer = previewLayer

            self.cameraView.layer.addSublayer(previewLayer)

        } catch {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session?.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.stopRunning()
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for item in metadataObjects {
            if let metadataObject = item as? AVMetadataMachineReadableCodeObject {
                session.stopRunning()
                self.dismiss(animated: true, completion: {
                    self.delegate?.scanViewControllerDidScanCode(scanVC: self, code: metadataObject.stringValue)
                })
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bounds = self.cameraView.layer.bounds
        previewLayer?.bounds = bounds
        previewLayer?.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
}
