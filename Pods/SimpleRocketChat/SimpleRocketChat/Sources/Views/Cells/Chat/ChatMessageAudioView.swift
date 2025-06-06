//
//  ChatMessageAudioView.swift
//  Rocket.Chat
//
//  Created by Matheus Cardoso on 9/26/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageAudioView: ChatMessageAttachmentView {
    override static var defaultHeight: CGFloat {
        return 80
    }

    var attachment: Attachment? {
        didSet {
            self.titleLabel.text = attachment?.title
            self.detailText.text = attachment?.descriptionText
            self.detailTextIndicator.isHidden = attachment?.descriptionText?.isEmpty ?? true
            let fullHeight = ChatMessageAudioView.heightFor(withText: attachment?.descriptionText)
            fullHeightConstraint.constant = fullHeight
            detailTextHeightConstraint.constant = fullHeight - ChatMessageAudioView.defaultHeight
            loading = true
            playing = false
            updateAudio()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var detailTextIndicator: UILabel!
    @IBOutlet weak var detailTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider! {
        didSet {
            if let progressImage = UIImage(namedInBundle:"Player Progress") {
                timeSlider.setThumbImage(progressImage.resizeWith(width: 15)?.imageWithTint(.RCGray()), for: .normal)
                timeSlider.setThumbImage(progressImage.resizeWith(width: 15)?.imageWithTint(.RCDarkGray()), for: .highlighted)
            }
        }
    }
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.tintColor = .gray
            playButton.imageView?.tintColor = .gray
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var player: AVAudioPlayer? {
        didSet {
            player?.delegate = self
        }
    }

    var playing = false {
        didSet {
            if playing {
                player?.play()
            } else {
                player?.pause()
            }
            guard let pause = UIImage(namedInBundle:"Player Pause")?.withRenderingMode(.alwaysTemplate),
                let play = UIImage(namedInBundle:"Player Play")?.withRenderingMode(.alwaysTemplate) else {
                    return
            }
            playButton.setImage(playing ? pause : play, for: .normal)
            playButton.imageView?.tintColor = .RCDarkGray()
        }
    }

    var loading = true {
        didSet {
            playButton.isHidden = loading
            loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

    var updateTimer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()

        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            guard let player = self.player else { return }

            self.timeSlider.maximumValue = Float(player.duration)

            if self.playing {
                self.timeSlider.value = Float(player.currentTime)
            }

            let displayTime = self.playing ? Int(player.currentTime) : Int(player.duration)
            self.timeLabel.text = String(format: "%02d:%02d", (displayTime/60) % 60, displayTime % 60)
        }
    }

    override func didMoveToSuperview() {
        playing = false
    }

    func updateAudio() {
        loading = true

        guard let attachment = attachment, let identifier = attachment.identifier else { return }
        guard let url = attachment.fullAudioURL() else { return }
        guard let localURL = DownloadManager.localFileURLFor(identifier) else { return }

        func updatePlayer() throws {
            let data = try Data(contentsOf: localURL)
            player = try AVAudioPlayer(data: data)
            player?.prepareToPlay()

            loading = false
        }

        if DownloadManager.fileExists(localURL) {
            try? updatePlayer()
        } else {
            // Download file and cache it to be used later
            DownloadManager.download(url: url, to: localURL) {
                DispatchQueue.main.async {
                    try? updatePlayer()
                }
            }
        }
    }
    @IBAction func didStartSlidingSlider(_ sender: UISlider) {
        playing = false
    }

    @IBAction func didFinishSlidingSlider(_ sender: UISlider) {
        self.player?.currentTime = Double(sender.value)
        playing = true
    }

    @IBAction func didPressPlayButton(_ sender: UIButton) {
        playing = !playing
    }
}

extension ChatMessageAudioView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playing = false
        self.timeSlider.value = 0.0
    }
}
