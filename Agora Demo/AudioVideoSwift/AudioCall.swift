//
//  AudioCall.swift
//  Agora Demo
//
//  Created by iOS Team on 28/07/25.
//

import UIKit
import IBAnimatable
import AgoraRtcKit
import AVFoundation
import MediaPlayer

class AudioCall: UIViewController {

    @IBOutlet weak var callerImage: AnimatableImageView!
    @IBOutlet weak var lblTimer: UILabel!
    private let agora =  AgoraManager.shared
    private let callManager = CallManager.shared
    private let pushKitManager = PushKitManager.shared
    var user: remoteUserInfo!
    var callTimer: Timer?
    var totalSeconds = 0
    private var audioRoutePickerView: MPVolumeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTimer.text = "Calling..."
        setupAgoraClosures()
        user = remoteUserInfo(name: "Harsh", userID: 2, profilePic: "")
        let userId = UserDefaults.standard.integer(forKey: "localUserID")
        if user.userID != userId{
            callManager.startCall(channelName: "harsh_Demo")
        }
    }
    
    func setupAgoraClosures() {
        callManager.agoraManager.closureAudioCallJoined = {[weak self] uid in
            guard let self = self else { return }
            startCallTimer()
        }
        callManager.agoraManager.closureCallLeft = { [weak self] in
            guard let self = self else { return }
            leftCall()
        }
    }
    
    func startCallTimer() {
        totalSeconds = 0
        self.lblTimer.text = "00:00:00"
        callTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.totalSeconds += 1
            let hours = self.totalSeconds / 3600
            let minutes = (self.totalSeconds % 3600) / 60
            let seconds = self.totalSeconds % 60
            self.lblTimer.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    func leftCall() {
        callManager.endCall()
        callTimer?.invalidate()
        callTimer = nil
        self.dismiss(animated: true)
    }
    
    private func clearAgoraClosures() {
        callManager.agoraManager.closureCallLeft = nil
    }
    
    @IBAction func tapCallEndBtn(_ sender: UIButton) {
        leftCall()
    }
    
    @IBAction func tapMicrophoneBtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isMuted = sender.isSelected
        callManager.agoraManager.muteCall(isMute: isMuted)
        sender.setImage(UIImage(systemName: isMuted ? "microphone.slash.fill" : "microphone.fill"), for: .normal)
    }
    
    @IBAction func tapSpeakerBtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        callManager.agoraManager.setEnableSpeakerphone()
        sender.setImage(UIImage(systemName: sender.isSelected ? "speaker.slash.fill" : "speaker.fill"), for: .normal)
    }
}
