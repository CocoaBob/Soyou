//
//  ChatControllerUploader.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 31/01/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func buttonUploadDidPressed() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: localized("chat.upload.take_photo"), style: .default, handler: { (_) in
                self.openCamera()
            }))

//            alert.addAction(UIAlertAction(title: localized("chat.upload.shoot_video"), style: .default, handler: { (_) in
//                self.openCamera(video: true)
//            }))
        }

        alert.addAction(UIAlertAction(title: localized("chat.upload.choose_from_library"), style: .default, handler: { (_) in
            self.openPhotosLibrary()
        }))

//        alert.addAction(UIAlertAction(title: localized("chat.upload.import_file"), style: .default, handler: { (_) in
//            self.openDocumentPicker()
//        }))

        alert.addAction(UIAlertAction(title: localized("global.cancel"), style: .cancel, handler: nil))

        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = leftButton
            presenter.sourceRect = leftButton.bounds
        }

        present(alert, animated: true, completion: nil)
    }

    fileprivate func openCamera(video: Bool = false) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return assertionFailure("Device camera is not availbale")
        }

        let imagePicker  = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.cameraFlashMode = .off
        imagePicker.mediaTypes = video ? [kUTTypeMovie as String] : [kUTTypeImage as String]
        imagePicker.cameraCaptureMode = video ? .video : .photo
        self.present(imagePicker, animated: true, completion: nil)
    }

    fileprivate func openPhotosLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = [kUTTypeImage as String]

        present(picker, animated: true, completion: nil)
    }

    // MARK: UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var filename = String.random()
        var file: FileUpload?

        if let assetURL = info[UIImagePickerControllerReferenceURL] as? URL,
            let asset = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: nil).firstObject {
            if let resource = PHAssetResource.assetResources(for: asset).first {
                filename = resource.originalFilename
            }

            let mimeType = UploadHelper.mimeTypeFor(assetURL)

            if mimeType == "image/gif" {
                PHImageManager.default().requestImageData(for: asset, options: nil) { data, _, _, _ in
                    guard let data = data else { return }

                    let file = UploadHelper.file(
                        for: data,
                        name: "\(filename.components(separatedBy: ".").first ?? "image").gif",
                        mimeType: "image/gif"
                    )

                    self.uploadDialog(file)
                    self.dismiss(animated: true, completion: nil)
                }

                return
            }
        }

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if image.containsNonSoyouLink() {
                let alertController = UIAlertController(title: nil, message: localized("forbidden_qr_code_alert"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: localized("alert_button_ok"),
                                                        style: UIAlertActionStyle.default,
                                                        handler: nil))
                var presentingVC = UIApplication.shared.keyWindow?.rootViewController
                if let presentedVC = presentingVC?.presentedViewController {
                    presentingVC = presentedVC
                }
                presentingVC?.present(alertController, animated: true, completion: nil)
                return
            } else {
                let resizedImage = image.resizeWith(width: 1024) ?? image
                guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.9) else { return }
                
                file = UploadHelper.file(
                    for: imageData,
                    name: "\(filename.components(separatedBy: ".").first ?? "image").jpeg",
                    mimeType: "image/jpeg"
                )
            }
        }

        if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            let assetURL = AVURLAsset(url: videoURL)
            let semaphore = DispatchSemaphore(value: 0)

            UploadVideoCompression.toMediumQuality(sourceAsset: assetURL, completion: { (videoData, _) in
                guard let videoData = videoData else {
                    semaphore.signal()
                    return
                }

                file = UploadHelper.file(
                    for: videoData as Data,
                    name: "\(filename.components(separatedBy: ".").first ?? "video").mp4",
                    mimeType: "video/mp4"
                )

                semaphore.signal()
            })

            _ = semaphore.wait(timeout: .distantFuture)
        }

        if let file = file {
            uploadDialog(file)
        }

        dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: UIDocumentMenuDelegate

extension ChatViewController: UIDocumentMenuDelegate {

    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self

        if let presenter = documentPicker.popoverPresentationController {
            presenter.sourceView = leftButton
            presenter.sourceRect = leftButton.bounds
        }

        present(documentPicker, animated: true, completion: nil)
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }

}

extension ChatViewController: UIDocumentPickerDelegate {

    func openDocumentPicker() {
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.item"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet

        if let presenter = importMenu.popoverPresentationController {
            presenter.sourceView = leftButton
            presenter.sourceRect = leftButton.bounds
        }

        self.present(importMenu, animated: true, completion: nil)
    }

    // MARK: UIDocumentPickerDelegate

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == .import {
            if let file = UploadHelper.file(for: url) {
                uploadDialog(file)
            }
        }
    }

}

// MARK: Uploading a FileUpload

extension ChatViewController {

    func startLoadingUpload(_ fileName: String) {
        showHeaderStatusView()

        let message = String(format: localized("chat.upload.uploading_file"), fileName)
        chatHeaderViewStatus?.labelTitle.text = message
        chatHeaderViewStatus?.buttonRefresh.isHidden = true
        chatHeaderViewStatus?.backgroundColor = .RCLightGray()
        chatHeaderViewStatus?.setTextColor(.RCDarkBlue())
        chatHeaderViewStatus?.activityIndicator.startAnimating()
    }

    func stopLoadingUpload() {
        hideHeaderStatusView()
    }

    func upload(_ file: FileUpload, fileName: String, description: String?) {
        guard let subscription = subscription else { return }

        startLoadingUpload(fileName)

        func stopLoadingUpload() {
            DispatchQueue.main.async { [weak self] in
                self?.stopLoadingUpload()
            }
        }

        let client = API.current()?.client(UploadClient.self)
        client?.upload(roomId: subscription.rid, data: file.data, filename: fileName, mimetype: file.type, description: description ?? "",
                       completion: stopLoadingUpload, versionFallback: { deprecatedMethod() })

        func deprecatedMethod() {
            UploadManager.shared.upload(file: file, fileName: fileName, subscription: subscription, progress: { _ in
                // We currently don't have progress being called.
            }, completion: { [unowned self] (response, error) in
                self.stopLoadingUpload()

                if error {
                    var errorMessage = localized("error.socket.default_error.message")

                    if let response = response {
                        if let message = response.result["error"]["message"].string {
                            errorMessage = message
                        }
                    }

                    Alert(
                        title: localized("error.socket.default_error.title"),
                        message: errorMessage
                    ).present()
                }
            })
        }
    }

    func uploadDialog(_ file: FileUpload) {
        self.upload(file, fileName: file.name, description: nil)
    }
}
